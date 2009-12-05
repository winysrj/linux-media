Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42048 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZLEFyX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2009 00:54:23 -0500
Received: by fxm5 with SMTP id 5so3205999fxm.28
        for <linux-media@vger.kernel.org>; Fri, 04 Dec 2009 21:54:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B0E6CC0.9030207@waechter.wiz.at>
References: <4B0E6CC0.9030207@waechter.wiz.at>
Date: Sat, 5 Dec 2009 09:54:27 +0400
Message-ID: <1a297b360912042154q619caa3dkf3818793f46c2c50@mail.gmail.com>
Subject: =?windows-1252?Q?Re=3A_Mantis_=96_anyone=3F?=
From: Manu Abraham <abraham.manu@gmail.com>
To: =?ISO-8859-1?Q?Matthias_W=E4chter?= <matthias@waechter.wiz.at>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/11/26 Matthias Wächter <matthias@waechter.wiz.at>:
> I am now playing around with the available code for quite some time now
> with mixed success, but no solution comes near the term “stable”.
>
> • kernel: nothing in there. Well, reasonable.
> • v4l-dvb: nothing in there.
> • s2-liplianin: mantis available, but obviously not under
> development/bugfixing. IR seems to work, CI handling looks quite broken,
> hangups/lockups are the rule, additional problems with more than one of
> these cards in the system.
> • mantis-v4l: does not compile out of the box for recent kernels. When
> hand-knitting the files into a kernel source directory (2.6.31), works
> quite unstable, module reloading frequently segfaults. IR does not work
> (at least for VDR), CI handling looks better than s2-liplianin.
>
> Conclusion: Stability is way below a level for reasonable usage while
> bug fixing.
>
> [1] gives an overview of the current state of (non-)development. Does
> this still apply?
>
> My questions are:
>
> • Is there someone feeling responsible for that baby?
> • What is the main part of the mantis stuff not working – mantis itself,
> the frontend, or adaptions from multiproto to s2api?
> • What can someone owning some of these cards (one Terratec, two
> Technisat) do to help the (former) authors to continue their work?
> • Is there some documentation available which would enable ‘the
> community’ to work on that further?

Please try http://jusst.de/hg/v4l-dvb
and report the issues

Regards,
Manu
