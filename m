Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:48675 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751133AbeDNJqz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Apr 2018 05:46:55 -0400
Date: Sat, 14 Apr 2018 06:46:48 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Jasmin J." <jasmin@anw.at>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        LMML <linux-media@vger.kernel.org>
Subject: Re: Smatch and sparse errors
Message-ID: <20180414064648.0ad264fa@vento.lan>
In-Reply-To: <fc6e68a3-817b-8caf-ba4f-dd2ed76d2a52@anw.at>
References: <20180411122728.52e6fa9a@vento.lan>
        <fc6e68a3-817b-8caf-ba4f-dd2ed76d2a52@anw.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 14 Apr 2018 03:18:20 +0200
"Jasmin J." <jasmin@anw.at> escreveu:

> Hello Mauro/Hans!
> 
> > There is already an upstream patch for hidding it:  
> The patch from https://patchwork.kernel.org/patch/10334353 will not
> apply at the smatch tree.
> 
> Attached is an updated version for smatch.

Then you're probably not using the right version (or Dan applied some
other stuff yesterday).

Yesterday, I added both trees I'm using here at:

	https://git.linuxtv.org/mchehab/sparse.git/
	https://git.linuxtv.org/mchehab/smatch.git/

My sparse tree has just one extra patch over upstream.
That's needed after a change at max()/min() macros upstream.

At smatch, my tree has 4 extra patches:
	https://git.linuxtv.org/mchehab/smatch.git/

They basically do:
	1) rise the execution time/memory usage of sparse;
	2) mask errors like "missing break", as gcc checks it already;
	3) the same patch for sparse is needed on smatch;
	4) disable this warning:
			drivers/media/platform/sti/bdisp/bdisp-debug.c:594 bdisp_dbg_perf() debug: sval_binop_signed: invalid divide LLONG_MIN/-1
	   with is produced every time do_div64() & friends are called.

IMHO, all 4 patches are disabling false-positive only warnings,
although the 4th patch might have something useful, if fixed to
properly handle the 64-bit compat macros.

Thanks,
Mauro
