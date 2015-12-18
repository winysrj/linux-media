Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:57135 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbbLRMLE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 07:11:04 -0500
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
From: Mason <slash.tmp@free.fr>
Message-ID: <5673F7CF.9090605@free.fr>
Date: Fri, 18 Dec 2015 13:10:55 +0100
MIME-Version: 1.0
In-Reply-To: <20151218092225.387cea22@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/12/2015 12:22, Mauro Carvalho Chehab wrote:

> Patch applied.

Great! Thanks.

Using the latest media_build master + my writel_relaxed work-around,
compilation proceeds much further, then dies on device tree stuff:
(same error with vanilla and custom kernel)

Will look into it. Any idea? :-(

By the way, if I was not clear, I'm cross-compiling for an ARM platform.

  CC [M]  /tmp/sandbox/media_build/v4l/v4l2-of.o
/tmp/sandbox/media_build/v4l/v4l2-of.c: In function 'v4l2_of_parse_csi_bus':
/tmp/sandbox/media_build/v4l/v4l2-of.c:38:4: error: implicit declaration of function 'of_prop_next_u32' [-Werror=implicit-function-declaration]
    lane = of_prop_next_u32(prop, lane, &v);
    ^
/tmp/sandbox/media_build/v4l/v4l2-of.c:38:9: warning: assignment makes pointer from integer without a cast
    lane = of_prop_next_u32(prop, lane, &v);
         ^
/tmp/sandbox/media_build/v4l/v4l2-of.c:52:13: warning: assignment makes pointer from integer without a cast
    polarity = of_prop_next_u32(prop, polarity, &v);
             ^
/tmp/sandbox/media_build/v4l/v4l2-of.c: In function 'v4l2_of_parse_link':
/tmp/sandbox/media_build/v4l/v4l2-of.c:287:24: warning: passing argument 1 of 'of_parse_phandle' discards 'const' qualifier from pointer target type
  np = of_parse_phandle(node, "remote-endpoint", 0);
                        ^
In file included from include/linux/i2c.h:36:0,
                 from /tmp/sandbox/media_build/v4l/compat.h:977,
                 from <command-line>:0:
include/linux/of.h:237:28: note: expected 'struct device_node *' but argument is of type 'const struct device_node *'
 extern struct device_node *of_parse_phandle(struct device_node *np,
                            ^
cc1: some warnings being treated as errors
make[3]: *** [/tmp/sandbox/media_build/v4l/v4l2-of.o] Error 1
make[2]: *** [_module_/tmp/sandbox/media_build/v4l] Error 2
make[2]: Leaving directory `/tmp/sandbox/linux-3.4.39'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/tmp/sandbox/media_build/v4l'
make: *** [all] Error 2

