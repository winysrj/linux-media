Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:65218 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbZKWDEC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2009 22:04:02 -0500
Received: by fxm5 with SMTP id 5so4238419fxm.28
        for <linux-media@vger.kernel.org>; Sun, 22 Nov 2009 19:04:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257913905.28958.32.camel@palomino.walls.org>
References: <1257913905.28958.32.camel@palomino.walls.org>
Date: Sun, 22 Nov 2009 22:04:06 -0500
Message-ID: <829197380911221904uedc18e5qbc9a37cfcee23b5d@mail.gmail.com>
Subject: Re: cx18: Reprise of YUV frame alignment improvements
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 10, 2009 at 11:31 PM, Andy Walls <awalls@radix.net> wrote:
> OK, here's my second attempt at getting rid of cx18 YUV frame alignment
> and tearing issues.
>
>        http://linuxtv.org/hg/~awalls/cx18-yuv2

Hi Andy,

I did some testing of your tree, using the following command

mplayer /dev/video32 -demuxer rawvideo -rawvideo w=720:h=480:format=hm12:ntsc

and then in parallel run a series of make commands of the v4l-dvb tree

make -j2 && make unload && make -j2 && make unload && make -j2 && make
unload && make -j2 && make unload

I was definitely seeing the corruption by doing this test before your
patches (both frame alignment and colorspace problems as PCI frames
were being dropped).  After your change, I no longer see those
problems.  The picture never became misaligned.  However, it would
appear that some sort of regression may have been introduced with the
buffer handling.

I was seeing a continuous reporting of the following in dmesg, even
*after* I stopped generating the load by running the make commands.

[ 5175.703811] cx18-0: Could not find MDL 106 for stream encoder YUV
[ 5175.737380] cx18-0: Could not find MDL 111 for stream encoder YUV
[ 5175.804317] cx18-0: Skipped encoder YUV, MDL 96, 3 times - it must
have dropped out of rotation
[ 5175.804324] cx18-0: Skipped encoder YUV, MDL 101, 3 times - it must
have dropped out of rotation
[ 5175.904500] cx18-0: Skipped encoder YUV, MDL 96, 2 times - it must
have dropped out of rotation
[ 5176.204507] cx18-0: Skipped encoder YUV, MDL 101, 1 times - it must
have dropped out of rotation
[ 5176.204513] cx18-0: Skipped encoder YUV, MDL 96, 1 times - it must
have dropped out of rotation
[ 5176.204518] cx18-0: Could not find MDL 111 for stream encoder YUV

I would expect to see frame drops while the system was under high
load, but I would expect that the errors would stop once the load fell
back to something reasonable.  However, they continue to accumulate
even after the make commands stop and the only thing running on the
system is mplayer (with a CPU load of around 10%).

I think this tree is definitely on the right track, but it looks like
some edge case has been missed.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
