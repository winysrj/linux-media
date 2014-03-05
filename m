Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:48828 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaCER16 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 12:27:58 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N1Z004AF4IKZQ40@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 05 Mar 2014 12:27:56 -0500 (EST)
Date: Wed, 05 Mar 2014 14:27:46 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Federico Simoncelli <fsimonce@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kbuild-all@01.org
Subject: Re: [linuxtv-media:master 499/499]
 drivers/media/usb/usbtv/usbtv-core.c:119:22: sparse: symbol 'usbtv_id_table'
 was not declared. Should it be static?
Message-id: <20140305142746.4ef16bff@samsung.com>
In-reply-to: <52f0ac8a.aIXONk2PY1rBXEn8%fengguang.wu@intel.com>
References: <52f0ac8a.aIXONk2PY1rBXEn8%fengguang.wu@intel.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fengguang,

This patch got obsoleted by another patch in the same series.

Unfortunately, I had to break sending the patch series into a few
pushes, as my mailbomb script has a logic there that prevents it to
send more than 30~50 emails (I never remember the exact setting).

So, I pushed this 80-series into a few pushes. You likely compiled the
tree without waiting for the hole series to be upstreamed.

Regards,
Mauro

Em Tue, 04 Feb 2014 17:02:02 +0800
kbuild test robot <fengguang.wu@intel.com> escreveu:

> tree:   git://linuxtv.org/media_tree.git master
> head:   a3550ea665acd1922df8275379028c1634675629
> commit: a3550ea665acd1922df8275379028c1634675629 [499/499] [media] usbtv: split core and video implementation
> reproduce: make C=1 CF=-D__CHECK_ENDIAN__
> 
> 
> sparse warnings: (new ones prefixed by >>)
> 
> >> drivers/media/usb/usbtv/usbtv-core.c:119:22: sparse: symbol 'usbtv_id_table' was not declared. Should it be static?
> >> drivers/media/usb/usbtv/usbtv-core.c:129:19: sparse: symbol 'usbtv_usb_driver' was not declared. Should it be static?
> --
> >> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
> >> drivers/media/usb/usbtv/usbtv-video.c:565:23: sparse: symbol 'usbtv_ioctl_ops' was not declared. Should it be static?
> >> drivers/media/usb/usbtv/usbtv-video.c:587:29: sparse: symbol 'usbtv_fops' was not declared. Should it be static?
> >> drivers/media/usb/usbtv/usbtv-video.c:648:16: sparse: symbol 'usbtv_vb2_ops' was not declared. Should it be static?
> 
> Please consider folding the attached diff :-)
> 
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation


-- 

Cheers,
Mauro
