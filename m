Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:38723 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbbLRNkQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 08:40:16 -0500
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
From: Mason <slash.tmp@free.fr>
Message-ID: <56740CBA.1060903@free.fr>
Date: Fri, 18 Dec 2015 14:40:10 +0100
MIME-Version: 1.0
In-Reply-To: <56740343.4000904@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/12/2015 13:59, Mason wrote: [snip previous work-arounds]

Compilation completes.

make -C /tmp/sandbox/custom-linux-3.4 SUBDIRS=/tmp/sandbox/media_build/v4l  modules
make[2]: Entering directory `/tmp/sandbox/custom-linux-3.4'
  Building modules, stage 2.
  MODPOST 209 modules
WARNING: "of_graph_parse_endpoint" [/tmp/sandbox/media_build/v4l/videodev.ko] undefined!
WARNING: "of_get_next_parent" [/tmp/sandbox/media_build/v4l/videodev.ko] undefined!
WARNING: "nsecs_to_jiffies" [/tmp/sandbox/media_build/v4l/gpio-ir-recv.ko] undefined!
make[2]: Leaving directory `/tmp/sandbox/custom-linux-3.4'
./scripts/rmmod.pl check
found 209 modules
make[1]: Leaving directory `/tmp/sandbox/media_build/v4l'


A few link problems, two from device tree:

of_graph_parse_endpoint() commit fd9fdb78a9bf8

of_get_next_parent() was not exported until commit 6695be6863b75

nsecs_to_jiffies() was not exported until commit d560fed6abe0f

How would you fix those?

I will try building a kernel with CONFIG_OF=n

Regards.

