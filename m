Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:29452 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932174AbbLQRDY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 12:03:24 -0500
Subject: Re: Automatic device driver back-porting with media_build
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <5672A6F0.6070003@free.fr> <20151217105543.13599560@recife.lan>
 <5672BE15.9070006@free.fr> <20151217120830.0fc27f01@recife.lan>
 <5672C713.6090101@free.fr> <20151217125505.0abc4b40@recife.lan>
 <5672D5A6.8090505@free.fr> <20151217140943.7048811b@recife.lan>
From: Mason <slash.tmp@free.fr>
Message-ID: <5672EAD6.2000706@free.fr>
Date: Thu, 17 Dec 2015 18:03:18 +0100
MIME-Version: 1.0
In-Reply-To: <20151217140943.7048811b@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/12/2015 17:09, Mauro Carvalho Chehab wrote:

> As I said before, heavily patched Kernel. It seems that the network stack
> was updated to some newer version. The media_build backport considers
> only the upstream Kernels. In the specific case of 3.4, it is known
> to build fine with Kernel linux-3.4.27. See:
> 	http://hverkuil.home.xs4all.nl/logs/Wednesday.log

I don't think the network stack is different from vanilla...

I had a different idea:

The media_build process prints:

"Preparing to compile for kernel version 3.4.3913"

In fact, the custom kernel's Makefile contains:

VERSION = 3
PATCHLEVEL = 4
SUBLEVEL = 39
EXTRAVERSION = 13
NAME = Saber-toothed Squirrel

Is it possible that the build process gets confused by the EXTRAVERSION field?

Regards.

