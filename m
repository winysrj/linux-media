Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45156 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756057AbZLXWJs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2009 17:09:48 -0500
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: Andy Walls <awalls@radix.net>
Subject: Re: [ivtv-devel] PVR150 Tinny/fuzzy audio w/ patch?
Date: Thu, 24 Dec 2009 23:09:34 +0100
Cc: linux-media@vger.kernel.org,
	Argus <pthorn-ivtvd@styx2002.no-ip.org>,
	Chris Kennedy <ivtv@groovy.org>,
	Moasat <ivtv@moasat.dyndns.org>, Mike Isely <isely@isely.net>,
	isely@pobox.com, Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>
References: <mailman.1.1260010802.13507.ivtv-devel@ivtvdriver.org> <200912061944.43481.martin.dauskardt@gmx.de> <1261671789.12520.14.camel@palomino.walls.org>
In-Reply-To: <1261671789.12520.14.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912242309.34376.martin.dauskardt@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody and Merry Christmas,

Andy Walls wrote:

> I have a version of the change for the ivtv/PVR-150 tinny audio fix at
> 
> 	http://linuxtv.org/hg/~awalls/v4l-dvb-bugfix
> 	http://linuxtv.org/hg/~awalls/v4l-dvb-bugfix/rev/7753cdcebd28
> 
> 
> It separates out the enable/disable of audio & video streaming from each
> other for the cx25840 module.  Then the ivtv driver can set them
> independently to avoid both the unpredictable PCI hang and the tinny
> audio in a very generic way.  Please test when you can.

@ Andy:
now we have a second 300ms delay in ivtv-streams.c

     2.6  		/* Initialize Digitizer for Capture */
     2.7 +		/* Avoid tinny audio problem - ensure audio clocks are going */
     2.8 +		v4l2_subdev_call(itv->sd_audio, audio, s_stream, 1);
     2.9 +		/* Avoid unpredictable PCI bus hang - disable video clocks */
    2.10  		v4l2_subdev_call(itv->sd_video, video, s_stream, 0);
    2.11  		ivtv_msleep_timeout(300, 1);
    2.12  		ivtv_vapi(itv, CX2341X_ENC_INITIALIZE_INPUT, 0);
    2.13  		v4l2_subdev_call(itv->sd_video, video, s_stream, 1);
    2.14 +		ivtv_msleep_timeout(300, 1);


This would increase the time for channel switching (using encoder stop/start) 
noticeable. My suggestion was to move the 300ms sleep at the point after the 
stream is re-enabled, so we don't need the first msleep.

I have not tested your code, hope I can do this during the next days.

> 
> Mike,
> 
> I had to add another subdev call to pvrusb2 to get the same end result
> of s_stream calls to the cx25840 module.
> 

@ Mike:
do you remember my posting in the pvrusb2 list about sporadic black screen 
after starting a stream? We had the same problem in ivtv, and the 300ms sleep 
after disabling the digitizer solved the problem.

I implemented this in a similary way in the pvrusb2 driver and the problem 
never appeared again:

--- v4l-dvb-309f16461cf4-orig/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	
2009-12-05 13:34:21.000000000 +0100
+++ v4l-dvb-309f16461cf4-patched/linux/drivers/media/video/pvrusb2/pvrusb2-
hdw.c	2009-12-24 22:42:49.746899065 +0100
@@ -4689,6 +4689,7 @@
 		del_timer_sync(&hdw->quiescent_timer);
 		if (hdw->flag_decoder_missed) return 0;
 		if (pvr2_decoder_enable(hdw,!0) < 0) return 0;
+		msleep(300);
 		hdw->state_decoder_quiescent = 0;
 		hdw->state_decoder_run = !0;
 	}



My initial idea was to avoid disabling/enabling the digitizer for devices with 
cx2584x-digitizer.  Channel changing (using encoder stop/start) with a PVR150 
and HVR1900 took always about a second longer than with saa7115-based devices. 
Without disabling/enabling the digitizer around the 
CX2341X_ENC_INITIALIZE_INPUT call it speeds up noticeable.

So this is the alternate patch for the pvrusb2 driver (similar code for ivtv 
was in my last posting which Andy had in his mail):

--- v4l-dvb-309f16461cf4-orig/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	
2009-12-05 13:34:21.000000000 +0100
+++ v4l-dvb-309f16461cf4-patched/linux/drivers/media/video/pvrusb2/pvrusb2-
hdw.c	2009-12-24 22:48:03.481899379 +0100
@@ -4646,9 +4646,9 @@
 			    !hdw->state_pipeline_pause &&
 			    hdw->state_pathway_ok) return 0;
 		}
-		if (!hdw->flag_decoder_missed) {
-			pvr2_decoder_enable(hdw,0);
-		}
+                if (hdw->decoder_client_id != PVR2_CLIENT_ID_CX25840 && !hdw-
>flag_decoder_missed) {
+         		pvr2_decoder_enable(hdw,0);
+                }
 		hdw->state_decoder_quiescent = 0;
 		hdw->state_decoder_run = 0;
 		/* paranoia - solve race if timer just completed */
@@ -4688,7 +4688,10 @@
 		    !hdw->state_encoder_ok) return 0;
 		del_timer_sync(&hdw->quiescent_timer);
 		if (hdw->flag_decoder_missed) return 0;
-		if (pvr2_decoder_enable(hdw,!0) < 0) return 0;
+                if (hdw->decoder_client_id != PVR2_CLIENT_ID_CX25840) {
+		    if (pvr2_decoder_enable(hdw,!0) < 0) return 0;
+                    msleep(300);
+                }
 		hdw->state_decoder_quiescent = 0;
 		hdw->state_decoder_run = !0;
 	}

It works fine with a HVR 1900, but should be tested with a PVRUSB2 model 
24xxx.

Greets,

Martin
