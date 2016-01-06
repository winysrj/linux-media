Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu004-omc4s19.hotmail.com ([65.55.111.158]:51540 "EHLO
	BLU004-OMC4S19.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752562AbcAFVIt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jan 2016 16:08:49 -0500
From: =?iso-8859-1?Q?Alexandre-Xavier_Labont=E9-Lamoureux?=
	<alexandrexavier@live.ca>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: em28xx driver for StarTech SVID2USB2
Date: Wed, 6 Jan 2016 21:03:47 +0000
Message-ID: <BY2PR20MB016853D2E3B3501FE70CCC3FBDF40@BY2PR20MB0168.namprd20.prod.outlook.com>
References: <D98DB3C2FD3AF74BBBFA4EB47841381511C140B9@NDJSMBX104.ndc.nasa.gov>,<CAGoCfiyo369O2K_kEC+xnD5AFT7saqc3iMLuZMJtTMTOCmT-Vw@mail.gmail.com>
In-Reply-To: <CAGoCfiyo369O2K_kEC+xnD5AFT7saqc3iMLuZMJtTMTOCmT-Vw@mail.gmail.com>
Content-Language: en-CA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, 

I had the exact same problem. 
Here's a question I asked on the Ubuntu but got no answer: http://askubuntu.com/questions/686779/video-recording-device-detected-but-cant-use-it

Now I bought another device, an Ion Video 2 PC MKII, it uses the same chip and it won't work with Linux. 

Here's a video were a guy compiles his own kernel and makes it work (the Ion Video 2 PC, not the StarTech Device)
https://www.youtube.com/watch?v=30e-N5z51vU

I tried the same thing (recompiling a new kernel) following his instructions without success. The sound didn't work and the only thing I got was a still image on VLC. Programs like guvcview and cheese didn't detect the  StarTech SVID2USB2. I firmly believe they use the same chip because they both use eb1a:5051 to identify themselves. 

Many thanks if you guys can fix it. 
Alexandre-Xavier 


________________________________________
From: linux-media-owner@vger.kernel.org <linux-media-owner@vger.kernel.org> on behalf of Devin Heitmueller <dheitmueller@kernellabs.com>
Sent: January 6, 2016 2:21 PM
To: Schubert, Matthew R. (LARC-D319)[TEAMS2]
Cc: linux-media@vger.kernel.org
Subject: Re: em28xx driver for StarTech SVID2USB2

On Wed, Jan 6, 2016 at 1:27 PM, Schubert, Matthew R.
(LARC-D319)[TEAMS2] <matthew.r.schubert@nasa.gov> wrote:
> Hello,
>
> We are attempting to use a StarTech Video Capture cable (Part# SVID2USB2) with our CentOS 6.7 machine with no success. The em28xx driver seems to load but cannot properly ID the capture cable. Below are the outputs from "dmesg" and "lsusb -v" run after plugging in the device. Any advice is appreciated.

Try adding "card=9" to the modprobe option.  If that doesn't work than
try "card=29".  Most of those really cheap devices either have an
saa7113 or tvp5150 video decoder, and one of those two board profiles
should work.

Devin

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
