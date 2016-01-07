Return-path: <linux-media-owner@vger.kernel.org>
Received: from NDJSVNPF104.ndc.nasa.gov ([198.117.1.154]:37439 "EHLO
	ndjsvnpf104.ndc.nasa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbcAGSx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jan 2016 13:53:26 -0500
From: "Schubert, Matthew R. (LARC-D319)[TEAMS2]"
	<matthew.r.schubert@nasa.gov>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: em28xx driver for StarTech SVID2USB2
Date: Thu, 7 Jan 2016 18:53:04 +0000
Message-ID: <D98DB3C2FD3AF74BBBFA4EB47841381511C141ED@NDJSMBX104.ndc.nasa.gov>
References: <D98DB3C2FD3AF74BBBFA4EB47841381511C140B9@NDJSMBX104.ndc.nasa.gov>,<CAGoCfiyo369O2K_kEC+xnD5AFT7saqc3iMLuZMJtTMTOCmT-Vw@mail.gmail.com>
In-Reply-To: <CAGoCfiyo369O2K_kEC+xnD5AFT7saqc3iMLuZMJtTMTOCmT-Vw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Setting card=9 appears to be working properly. Thanks!

Matt R. Schubert
Programmer | Analyst
Analytical Mechanics Associates
NASA Langley Computational Vision Lab

________________________________________
From: Devin Heitmueller [dheitmueller@kernellabs.com]
Sent: Wednesday, January 06, 2016 2:21 PM
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
