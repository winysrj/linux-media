Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47126 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752633AbZLaRPp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2009 12:15:45 -0500
To: Andy Walls <awalls@radix.net>
Subject: Re: [ivtv-devel] PVR150 Tinny/fuzzy audio w/ patch?
Cc: linux-media@vger.kernel.org,
	Argus <pthorn-ivtvd@styx2002.no-ip.org>,
	Chris Kennedy <ivtv@groovy.org>,
	Moasat <ivtv@moasat.dyndns.org>, Mike Isely <isely@isely.net>,
	isely@pobox.com, Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>, pthorn-ivtvd@styx2002.no-ip.org
From: Martin Dauskardt <martin.dauskardt@gmx.de>
Date: Thu, 31 Dec 2009 18:15:38 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912311815.38865.martin.dauskardt@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

first test results from me:

As expected, the double "ivtv_msleep_timeout(300, 1);" in ivtv-streams.c 
increases the time for stopping/starting a stream. I removed the first call 
and it still works fine.

@ Mike:
Previously I suggested to add a msleep(300)  in state_eval_decoder_run 
(pvrusb2-hdw.c), after calling pvr2_decoder_enable(hdw,!0).

With the change from Andy I now have again sporadic black screens with my 
saa7115-based PVRUSB2.  So I moved the sleep directly into "static int 
pvr2_decoder_enable":

--- v4l-dvb-bugfix-7753cdcebd28-orig/v4l-dvb-
bugfix-7753cdcebd28/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	2009-12-24 
17:06:08.000000000 +0100
+++ v4l-dvb-bugfix-7753cdcebd28-patched/v4l-dvb-
bugfix-7753cdcebd28/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	2009-12-31 
17:19:22.836251706 +0100
@@ -1716,6 +1716,7 @@
 		   (enablefl ? "on" : "off"));
 	v4l2_device_call_all(&hdw->v4l2_dev, 0, video, s_stream, enablefl);
 	v4l2_device_call_all(&hdw->v4l2_dev, 0, audio, s_stream, enablefl);
+	if (enablefl != 0) msleep(300);
 	if (hdw->decoder_client_id) {
 		/* We get here if the encoder has been noticed.  Otherwise
 		   we'll issue a warning to the user (which should

Funny- this seems to work, no more black screens appeared.


The remaining questions are in my opinion:

1.)
What is Hans opinion about the changes, especially the move of the 300ms sleep 
from "after disabling the digitizer"  to "after enabling it" ?

2.)
Do we want to keep disabling the digitizer during the 
CX2341X_ENC_INITIALIZE_INPUT call in case the digitizer is a cx25840x ?
It seems to be necessary only for the saa7115. 
Note: The cx88-blackbird-driver does also no disabling/enabling of the 
digitizer (cx2388x) when doing this firmware call. 

3.)
Does Andys Patch solve the tinny audio problem for Argus (who originally 
posted the problem and a different solution in the ivtv-devel list). I add him 
in cc.

Greets and Happy New Year 

Martin

PS:
Readers on the ivtv-devel ML list will miss previous postings (the list was 
down a few days). Please have a look in 
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/14151
and
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/14155
