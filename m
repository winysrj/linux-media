Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:44033 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751326AbeEDQKw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 12:10:52 -0400
Subject: Re: [v3] [media] Use common error handling code in 19 functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andi Shyti <andi.shyti@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Utkin <andrey_utkin@fastmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Brian Johnson <brijohn@gmail.com>,
        =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= <christoph@boehmwalder.at>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        Daniele Nicolodi <daniele@grinta.net>,
        =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        Devendra Sharma <devendra.sharma9091@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Inki Dae <inki.dae@samsung.com>, Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Max Kellermann <max.kellermann@gmail.com>,
        Mike Isely <isely@pobox.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Sean Young <sean@mess.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Shyam Saini <mayhs11saini@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <227d2d7c-5aee-1190-1624-26596a048d9c@users.sourceforge.net>
 <57ef3a56-2578-1d5f-1268-348b49b0c573@users.sourceforge.net>
Message-ID: <9e766f52-b09e-c61e-8d9f-23542d83f6b1@users.sourceforge.net>
Date: Fri, 4 May 2018 18:08:59 +0200
MIME-Version: 1.0
In-Reply-To: <57ef3a56-2578-1d5f-1268-348b49b0c573@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Adjust jump targets so that a bit of exception handling can be better
> reused at the end of these functions.

Why was this update suggestion rejected once more a moment ago?

https://patchwork.linuxtv.org/patch/47827/
lkml.kernel.org/r/<57ef3a56-2578-1d5f-1268-348b49b0c573@users.sourceforge.net>
https://lkml.org/lkml/2018/3/9/823

Would you like to integrate such a source code transformation after any further adjustments?

Regards,
Markus
