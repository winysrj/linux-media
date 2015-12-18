Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:41173 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbbLRPNM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 10:13:12 -0500
Subject: Re: Automatic device driver back-porting with media_build
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <5672A6F0.6070003@free.fr> <20151217105543.13599560@recife.lan>
 <5672BE15.9070006@free.fr> <20151217120830.0fc27f01@recife.lan>
 <5672C713.6090101@free.fr> <20151217125505.0abc4b40@recife.lan>
 <5672D5A6.8090505@free.fr> <20151217140943.7048811b@recife.lan>
 <5672EAD6.2000706@free.fr> <5673E393.8050309@free.fr>
 <20151218090345.623cef4c@recife.lan> <20151218092225.387cea22@recife.lan>
 <5673F7CF.9090605@free.fr> <56740343.4000904@free.fr>
 <56740CBA.1060903@free.fr>
From: Mason <slash.tmp@free.fr>
Message-ID: <56742283.1010909@free.fr>
Date: Fri, 18 Dec 2015 16:13:07 +0100
MIME-Version: 1.0
In-Reply-To: <56740CBA.1060903@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/12/2015 14:40, Mason wrote:

> I will try building a kernel with CONFIG_OF=n

Build works much better with CONFIG_OF=n
I suppose OF support with ancient kernels is untested.
(My setup didn't need it anyway.)

The remaining issue is:

WARNING: "nsecs_to_jiffies" [/tmp/sandbox/media_build/v4l/gpio-ir-recv.ko] undefined!

$ git describe --contains d560fed6abe0f
v3.17-rc1~109^2~40

The actual call site was added recently by commit 3fb136f3392d
(Hasn't even it linux-stable yet, I only see it in next-20151123)

I think a patch is needed for kernels < 3.17 right?

Regards.

