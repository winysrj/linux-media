Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60303 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbbH0KdZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2015 06:33:25 -0400
Date: Thu, 27 Aug 2015 07:33:19 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Junghak Sung <jh1009.sung@samsung.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v3 3/5] media: videobuf2: Modify all device drivers
Message-ID: <20150827073319.6e66a678@recife.lan>
In-Reply-To: <1440590372-2377-4-git-send-email-jh1009.sung@samsung.com>
References: <1440590372-2377-1-git-send-email-jh1009.sung@samsung.com>
	<1440590372-2377-4-git-send-email-jh1009.sung@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 26 Aug 2015 20:59:30 +0900
Junghak Sung <jh1009.sung@samsung.com> escreveu:

> Modify all device drivers related with previous change that restructures
> vb2_buffer for common use.
> Actually, not all device drivers, yet. So, it required to modifiy more file
> to complete this patch.

I was expecting to be able to compile everything after applying both
patches 2 and 3, but compilation failed:

In file included from drivers/media/platform/am437x/am437x-vpfe.c:41:0:
drivers/media/platform/am437x/am437x-vpfe.h:107:25: error: field 'vb' has incomplete type
  struct vb2_v4l2_buffer vb;
                         ^
drivers/media/platform/am437x/am437x-vpfe.c: In function 'to_vpfe_buffer':
drivers/media/platform/am437x/am437x-vpfe.c:312:72: warning: initialization from incompatible pointer type [-Wincompatible-pointer-types]
drivers/media/platform/am437x/am437x-vpfe.c: In function 'vpfe_buffer_prepare':
drivers/media/platform/am437x/am437x-vpfe.c:1952:4: error: 'struct vb2_buffer' has no member named 'v4l2_buf'
  vb->v4l2_buf.field = vpfe->fmt.fmt.pix.field;
    ^
drivers/media/platform/am437x/am437x-vpfe.c: In function 'to_vpfe_buffer':
drivers/media/platform/am437x/am437x-vpfe.c:313:1: warning: control reaches end of non-void function [-Wreturn-type]
 }
 ^
scripts/Makefile.build:258: recipe for target 'drivers/media/platform/am437x/am437x-vpfe.o' failed
make[3]: *** [drivers/media/platform/am437x/am437x-vpfe.o] Error 1
scripts/Makefile.build:403: recipe for target 'drivers/media/platform/am437x' failed
make[2]: *** [drivers/media/platform/am437x] Error 2
scripts/Makefile.build:403: recipe for target 'drivers/media/platform' failed
make[1]: *** [drivers/media/platform] Error 2
make[1]: *** Waiting for unfinished jobs....
In file included from drivers/media/pci/cobalt/cobalt-driver.c:30:0:
drivers/media/pci/cobalt/cobalt-driver.h:209:25: error: field 'vb' has incomplete type
  struct vb2_v4l2_buffer vb;
                         ^
drivers/media/pci/cobalt/cobalt-driver.h: In function 'to_cobalt_buffer':
drivers/media/pci/cobalt/cobalt-driver.h:215:70: warning: initialization from incompatible pointer type [-Wincompatible-pointer-types]
scripts/Makefile.build:258: recipe for target 'drivers/media/pci/cobalt/cobalt-driver.o' failed
make[3]: *** [drivers/media/pci/cobalt/cobalt-driver.o] Error 1
scripts/Makefile.build:403: recipe for target 'drivers/media/pci/cobalt' failed
make[2]: *** [drivers/media/pci/cobalt] Error 2
scripts/Makefile.build:403: recipe for target 'drivers/media/pci' failed
make[1]: *** [drivers/media/pci] Error 2
drivers/media/dvb-frontends/rtl2832_sdr.c:110:25: error: field 'vb' has incomplete type
  struct vb2_v4l2_buffer vb;   /* common v4l buffer stuff -- must be first */
                         ^
drivers/media/dvb-frontends/rtl2832_sdr.c: In function 'rtl2832_sdr_buf_queue':
drivers/media/dvb-frontends/rtl2832_sdr.c:523:73: warning: initialization from incompatible pointer type [-Wincompatible-pointer-types]
drivers/media/dvb-frontends/rtl2832_sdr.c:523:73: note: (near initialization for 'buf')
scripts/Makefile.build:258: recipe for target 'drivers/media/dvb-frontends/rtl2832_sdr.o' failed
make[2]: *** [drivers/media/dvb-frontends/rtl2832_sdr.o] Error 1
scripts/Makefile.build:403: recipe for target 'drivers/media/dvb-frontends' failed
make[1]: *** [drivers/media/dvb-frontends] Error 2
Makefile:1380: recipe for target '_module_drivers/media' failed
make: *** [_module_drivers/media] Error 2


So, obviously there's something wrong there. Please fix.

I'll skip this patch from my review.

Thanks!
Mauro
