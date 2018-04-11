Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54808 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752804AbeDKP1e (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 11:27:34 -0400
Date: Wed, 11 Apr 2018 12:27:28 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, Jasmin Jessich <jasmin@anw.at>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Smatch and sparse errors
Message-ID: <20180411122728.52e6fa9a@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans/Jasmin,

There is a regression with sparse and upstream Kernels, with also affect
smatch. Due to that, both will produce hundreds of new errors on all places
that directly or indirectly use min() or max().

Those were caused by those upstream patches:

	3c8ba0d61d04 ("kernel.h: Retain constant expression output for max()/min()")
 	e9092d0d9796 ("Fix subtle macro variable shadowing in min_not_zero()")

There is already an upstream patch for hidding it:
	https://patchwork.kernel.org/patch/10334353/

While upstream doesn't fix it (either by applying this patch or with some
other fixup patch), it should be applied on both sparse and smatch trees, 
in order to get rid of those false positives.

I suggest applying it to the logic with does daily compilations,
in order to avoid generating useless reports for smatch/sparse.

Thanks,
Mauro
