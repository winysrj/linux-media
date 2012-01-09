Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway03.websitewelcome.com ([69.93.236.28]:41559 "EHLO
	gateway03.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933081Ab2AITwE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jan 2012 14:52:04 -0500
Received: from ham01.websitewelcome.com (ham.websitewelcome.com [173.192.111.52])
	by gateway03.websitewelcome.com (Postfix) with ESMTP id EEFCB4B6F9F4A
	for <linux-media@vger.kernel.org>; Mon,  9 Jan 2012 12:52:27 -0600 (CST)
Received: from gator886.hostgator.com (gator886.hostgator.com [174.120.40.226])
	by ham01.websitewelcome.com (Postfix) with ESMTP id 1F23A49E791A
	for <linux-media@vger.kernel.org>; Mon,  9 Jan 2012 12:52:26 -0600 (CST)
From: "Charlie X. Liu" <charlie@sensoray.com>
To: "'Christopher Peters'" <cpeters@ucmo.edu>,
	<linux-media@vger.kernel.org>
References: <CAPc4S2YPRWHhTJY0C5gMYtFgULHibfaqGuPOeU-fFxm9XfxYjg@mail.gmail.com>
In-Reply-To: <CAPc4S2YPRWHhTJY0C5gMYtFgULHibfaqGuPOeU-fFxm9XfxYjg@mail.gmail.com>
Subject: RE: No video on generic SAA7134 card
Date: Mon, 9 Jan 2012 10:52:41 -0800
Message-ID: <002e01ccceff$de2c4f90$9a84eeb0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You may use "XawTV" first, as it's easier to use and config. For installing
"XawTV", if you use an installed/LiveCD Ubuntu, run "sudo apt-get install
xawtv" to get the "XawTV" app installed. Then,

$ xawtv -c /dev/video0 &		(for channel-1)
$ xawtv -c /dev/video1 & 		(for channel-2)
$ xawtv -c /dev/video2 &		(for channel-3)
$ xawtv -c /dev/video3 &		(for channel-4)

If card=default doesn't work, you may try run "modprobe -r saa7134_alsa",
"modprobe -r saa7134", and "modprobe saa7134 card=73,73,73,73" or
card=others to reload the saa7134 driver. Then, run "XawTV" and till find a
proper card number for your card.

Cood luck!


Charlie X. Liu @ Sensoray Co. <http://www.sensoray.com/>


-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Christopher Peters
Sent: Monday, January 09, 2012 9:08 AM
To: linux-media@vger.kernel.org
Subject: No video on generic SAA7134 card

I have one of these cards: http://tinyurl.com/7kupvw7 and I'd like to
make it work on my Linux box.  It is seen by the kernel and detected
as a generic SAA7134-based card.  However, when I hook up video to the
card and attempt to view it in VLC, I don't see the video.  Instead I
see a number of alternating dark grey and white lines, and the image
flickers.  There's no change in the image if I disconnect the video
source from one of the inputs and connect it to another (there are
four in total) input).

Suggestions?  Should I expect to get video if the card is detected as
"generic", rather than a specific manufacturer / model?

KP

-- 
-
Kit Peters (W0KEH), Engineer II
KMOS TV Channel 6 / KTBG 90.9 FM
University of Central Missouri
http://kmos.org/ | http://ktbg.fm/
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

