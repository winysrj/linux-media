Return-path: <linux-media-owner@vger.kernel.org>
Received: from proxy2.bredband.net ([195.54.101.72]:42194 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZGONLY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jul 2009 09:11:24 -0400
Received: from iph1.telenor.se (195.54.127.132) by proxy2.bredband.net (7.3.140.3)
        id 49F59CBD01926485 for linux-media@vger.kernel.org; Wed, 15 Jul 2009 15:11:23 +0200
Message-ID: <23dacddfe6d6ab5d9060dd34e3dc8439.squirrel@mail.kurelid.se>
In-Reply-To: <e9a4f5af0904090141h462c2909q65dded8cde1632a2@mail.gmail.com>
References: <e9a4f5af0904090141h462c2909q65dded8cde1632a2@mail.gmail.com>
Date: Wed, 15 Jul 2009 15:11:22 +0200
Subject: Re: firedtv and ca-module
From: "Henrik Kurelid" <henke@kurelid.se>
To: "Johannes Tang Kristensen" <linuxmedia@tangkristensen.dk>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Johs,

Please provide a kernel log when you have enabled AVC debugging (cat -1 > /sys/module/firedtv/parameters/debug) and I will take a look at it for
you. Please split the log in two or indicate where you do the second tuning.

Regards,
Henrik

> Hi,
>
> I'm having trouble using the firedtv driver to watch scrambled
> channels using a ca-module. Here's my setup: I have a firedtv c/ci
> tuner with an irdeto cam, and am running Fedora 10 with a 2.6.29.1
> kernel. In general I have no problems with FTA channels, but scrambled
> channels do not always work. I've tested my setup on a macbook in mac
> osx using eyetv, and here I can watch scrambled channels without any
> problems, so I doubt my problems are hardware related.
>
> I have tried to track down the problem using various dvb-apps, and the
> app I've had the best results with is gnutv from dvb-apps. If I try to
> tune to a scrambled channel I get the following:
>
> [root@hp-laptop gnutv]# ./gnutv -channels ./channels.conf -out file
> test.mpg "3+"
> CAM Application type: 01
> CAM Application manufacturer: cafe
> CAM Manufacturer code: babe
> CAM Menu string: Irdeto Access
> CAM supports the following ca system ids:
> Using frontend "FireDTV C/CI", type DVB-C
> status SCVYL | signal ff00 | snr 2525 | ber 000000be | unc 00000000 |
> FE_HAS_LOCK
>
> and then it hangs. But if I kill the process and try again it works and I get:
>
> [root@hp-laptop gnutv]# ./gnutv -channels ./channels.conf -out file
> test.mpg "3+"
> CAM Application type: 01
> CAM Application manufacturer: cafe
> CAM Manufacturer code: babe
> CAM Menu string: Irdeto Access
> CAM supports the following ca system ids:
> Using frontend "FireDTV C/CI", type DVB-C
> status SCVYL | signal ff00 | snr 2525 | ber 00000082 | unc 00000000 |
> FE_HAS_LOCK
> Received new PMT - sending to CAM...
>
> So I need to "tune" the channel twice for it to work. After this first
> time it keeps working even if I stop gnutv and start it again, as long
> as I want to watch the same channel. As soon as try to watch a
> different channel I again need to "tune" it twice before it works.
>
> Well that's not completely true. Because after playing around with
> several different channels it appears there might be a pattern. If I
> have been able to successfully watch a scrambled channel by tuning it
> twice as described above then I can watch all channels in the mux
> without having to tune twice again. The problem only appears again
> when I try to watch a channel in a different mux.
>
> I hope that some of you can make some sense of my problem. Please let
> me know if I can provide any additional information.
>
> /Johs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

