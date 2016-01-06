Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:35456 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbcAFTVY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2016 14:21:24 -0500
Received: by mail-qk0-f175.google.com with SMTP id n135so158514177qka.2
        for <linux-media@vger.kernel.org>; Wed, 06 Jan 2016 11:21:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <D98DB3C2FD3AF74BBBFA4EB47841381511C140B9@NDJSMBX104.ndc.nasa.gov>
References: <D98DB3C2FD3AF74BBBFA4EB47841381511C140B9@NDJSMBX104.ndc.nasa.gov>
Date: Wed, 6 Jan 2016 14:21:23 -0500
Message-ID: <CAGoCfiyo369O2K_kEC+xnD5AFT7saqc3iMLuZMJtTMTOCmT-Vw@mail.gmail.com>
Subject: Re: em28xx driver for StarTech SVID2USB2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Schubert, Matthew R. (LARC-D319)[TEAMS2]"
	<matthew.r.schubert@nasa.gov>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
