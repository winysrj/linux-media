Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:42553 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbZLaT3j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2009 14:29:39 -0500
Subject: Re: [ivtv-devel] PVR150 Tinny/fuzzy audio w/ patch?
From: Andy Walls <awalls@radix.net>
To: Martin Dauskardt <martin.dauskardt@gmx.de>
Cc: linux-media@vger.kernel.org,
	Argus <pthorn-ivtvd@styx2002.no-ip.org>,
	Chris Kennedy <ivtv@groovy.org>,
	Moasat <ivtv@moasat.dyndns.org>, Mike Isely <isely@isely.net>,
	isely@pobox.com, Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>
In-Reply-To: <200912311815.38865.martin.dauskardt@gmx.de>
References: <200912311815.38865.martin.dauskardt@gmx.de>
Content-Type: text/plain
Date: Thu, 31 Dec 2009 14:26:47 -0500
Message-Id: <1262287607.3055.115.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-12-31 at 18:15 +0100, Martin Dauskardt wrote:
> Hi everybody,
> 
> first test results from me:
> 
> As expected, the double "ivtv_msleep_timeout(300, 1);" in ivtv-streams.c 
> increases the time for stopping/starting a stream. I removed the first call 
> and it still works fine.

Yes, I knew the initial 300 ms delay before the call to
CX2341X_ENC_INITIALIZE_INPUT was lame, but it should always be safe.  I
really want to avoid a video signal from the saa7115 causing the
CX2341[56] to hang the PCI bus.

I was hoping you could find a small number empirically that was safe.  I
was thinking at *most* 10 ms for lines to settle: time for audio clocks
to come up to avoid tinny audio and time for video clocks to stop to
avoid PCI bus hangs.  It sounds like you determined 0 ms is OK.  I
suspect then, that the time to set up and send the
CX2341X_ENC_INITIALIZE_INPUT command to the encoder provides enough
delay.


> @ Mike:
> Previously I suggested to add a msleep(300)  in state_eval_decoder_run 
> (pvrusb2-hdw.c), after calling pvr2_decoder_enable(hdw,!0).
> 
> With the change from Andy I now have again sporadic black screens with my 
> saa7115-based PVRUSB2.

Hmmm.  That's odd.  All I did was separate out video and audio clock
enable/disable into two seperate steps for CX2584x units, or add a small
delay for SAA7115 units. 

>   So I moved the sleep directly into "static int 
> pvr2_decoder_enable":
> 
> --- v4l-dvb-bugfix-7753cdcebd28-orig/v4l-dvb-
> bugfix-7753cdcebd28/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	2009-12-24 
> 17:06:08.000000000 +0100
> +++ v4l-dvb-bugfix-7753cdcebd28-patched/v4l-dvb-
> bugfix-7753cdcebd28/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	2009-12-31 
> 17:19:22.836251706 +0100
> @@ -1716,6 +1716,7 @@
>  		   (enablefl ? "on" : "off"));
>  	v4l2_device_call_all(&hdw->v4l2_dev, 0, video, s_stream, enablefl);
>  	v4l2_device_call_all(&hdw->v4l2_dev, 0, audio, s_stream, enablefl);
> +	if (enablefl != 0) msleep(300);
>  	if (hdw->decoder_client_id) {
>  		/* We get here if the encoder has been noticed.  Otherwise
>  		   we'll issue a warning to the user (which should
> 
> Funny- this seems to work, no more black screens appeared.
> 
> 
> The remaining questions are in my opinion:
> 
> 1.)
> What is Hans opinion about the changes, especially the move of the 300ms sleep 
> from "after disabling the digitizer"  to "after enabling it" ?

My opinion is to use as short a delay as needed before the call to
CX2341X_ENC_INITIALIZE_INPUT, to avoid tinny audio and avoid PCI bus
hangs.

If you found 0 ms delay was fine, then perhaps I'll just remove that
delay or use something like 1 ms, OK?


For the delay after the CX2341X_ENC_INITIALIZE_INPUT, I think it is
good, as there are probably a few things going on:

a. The digitizer clock lines stabilizing as mentioned earlier

b. The CX2341X_ENC_INITIALIZE_INPUT call may still be executing on the
CX23416, when the ivtv_vapi() returns (I haven't disassembeld the
firmware to check if that is the actually case and how long it might
take).

c. before the call to CX2341X_ENC_START_CAPTURE to start the *first*
capture, the CX2341[56] may need a few valid rasters from the digitizer
stored in its memory.

So the delay after enabling the digitzer makes sure at least a few
rasters are available for the CX2341[56] to operate on.  A 300 ms delay
is 15 fields for PAL and 18 fields for NTSC.  A wait of 100 ms would be
5 fields for PAL and 6 fields for NTSC, and probably enough.

I think this hypothesis is consistent with the pvrusb2 and ivtv hardware
behavior you noticed.


> 2.)
> Do we want to keep disabling the digitizer during the 
> CX2341X_ENC_INITIALIZE_INPUT call in case the digitizer is a cx25840x ?
> It seems to be necessary only for the saa7115. 
> Note: The cx88-blackbird-driver does also no disabling/enabling of the 
> digitizer (cx2388x) when doing this firmware call. 

I would want to do so.

It is my understanding that, notwithstanding any firmware bugs, the
machines in the CX2341[56] chips have some hardware bugs.  I want to
avoid tripping over those bugs and locking up someone's machine
intermittently.


The CX2388[0123] is a differnent type of machine internally, not subject
to the same of hardware bugs that the CX2341[56] have that may hang the
machine/PCI bus.  The CX2388x should be providing the DMA engines and
the PCI bus connection.  I do not know the full details of the Blackbird
board design, but I assume the CX23416 does not interface directly to
the PCI bus along with the CX2388x (which would require a PCI bridge
chip on the card much like a PVR-500).


However, yes it could be the case the Conexant digitizer (CX2584x and
CX2388x internal) output VIP/BT.656 data in a form that at all times
never causes the CX23416 any problems.  I really just don't know what
conditions cause the CX23416 to intermittently hang a machine, so I'd
prefer want to avoid any potential causes of hangs.


> 3.)
> Does Andys Patch solve the tinny audio problem for Argus (who originally 
> posted the problem and a different solution in the ivtv-devel list). I add him 
> in cc.

Yes, that's a question I had.



My preferences in summary, is that not matter what the digitizer chip:

a. I'd like to keep the audio clocks always up to avoid tinny audio.

b. I'd also like to inhibit the video clock and add the delay after
re-enabling the digitizer to avoid the *potential* for a hung machine.

c. I do not care to much about the delay after disbaling the video
clock, only that it is empirically "long enough".

Thanks for taking the time to test and comment.

Regards,
Andy

> Greets and Happy New Year 
> 
> Martin
> 
> PS:
> Readers on the ivtv-devel ML list will miss previous postings (the list was 
> down a few days). Please have a look in 
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/14151
> and
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/14155


