Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57452
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752048AbdCKJe5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 04:34:57 -0500
Received: from localhost (localhost [127.0.0.1])
        by osg.samsung.com (Postfix) with ESMTP id 81DF0A0DE2
        for <linux-media@vger.kernel.org>; Sat, 11 Mar 2017 09:35:18 +0000 (UTC)
Received: from osg.samsung.com ([127.0.0.1])
        by localhost (s-opensource.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aE7nsX550_YY for <linux-media@vger.kernel.org>;
        Sat, 11 Mar 2017 09:35:17 +0000 (UTC)
Received: from vento.lan (177.96.206.203.dynamic.adsl.gvt.net.br [177.96.206.203])
        by osg.samsung.com (Postfix) with ESMTPSA id 3BA7CA0C15
        for <linux-media@vger.kernel.org>; Sat, 11 Mar 2017 09:35:17 +0000 (UTC)
Date: Sat, 11 Mar 2017 06:34:51 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] libv4lconvert: by default, offer the original
 format to the client
Message-ID: <20170311063451.5147f2c1@vento.lan>
In-Reply-To: <3b5962deff0fb5675399f1d9b09a98eb46ac0bd3.1489224099.git.mchehab@s-opensource.com>
References: <db1d17c0eed07c89fae03275bda0fe4d3d5c1776.1489224099.git.mchehab@s-opensource.com>
        <3b5962deff0fb5675399f1d9b09a98eb46ac0bd3.1489224099.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 11 Mar 2017 06:21:40 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> The libv4lconvert part of libv4l was meant to provide a common
> place to handle weird proprietary formats. With time, we also
> added support to other standard formats, in order to help
> V4L2 applications that are not performance sensitive to support
> all V4L2 formats.
> 
> Yet, the hole idea is to let userspace to decide to implement
> their own format conversion code when it needs either more
> performance or more quality than what libv4lconvert provides.
> 
> In other words, applications should have the right to decide
> between using a libv4lconvert emulated format or to implement
> the decoding themselves for non-proprietary formats,
> as this may have significative performance impact.
> 
> At the application side, deciding between them is just a matter
> of looking at the V4L2_FMT_FLAG_EMULATED flag.
> 
> Yet, we don't want to have a myriad of format converters
> everywhere for the proprietary formats, like V4L2_PIX_FMT_KONICA420,
> V4L2_PIX_FMT_SPCA501, etc. So, let's offer only the emulated
> variant for those weird stuff.
> 
> So, this patch changes the libv4lconvert default behavior to
> show emulated formats, except for the explicit ones marked as
> such.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Please ignore this patch. It is wrong. I sent a version 2 of this
series without it.

Regards,
Mauro
