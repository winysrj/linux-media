Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:48566 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaCEUcC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 15:32:02 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N1Z00AROD1B6T60@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 05 Mar 2014 15:31:59 -0500 (EST)
Date: Wed, 05 Mar 2014 17:31:53 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild test robot <fengguang.wu@intel.com>,
	Federico Simoncelli <fsimonce@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kbuild-all@01.org
Subject: Re: [linuxtv-media:master 499/499]
 drivers/media/usb/usbtv/usbtv-core.c:119:22: sparse: symbol 'usbtv_id_table'
 was not declared. Should it be static?
Message-id: <20140305173153.51fc9274@samsung.com>
In-reply-to: <20140305142746.4ef16bff@samsung.com>
References: <52f0ac8a.aIXONk2PY1rBXEn8%fengguang.wu@intel.com>
 <20140305142746.4ef16bff@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 5 Mar 2014 14:27:46 -0300
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Hi Fengguang,
> 
> This patch got obsoleted by another patch in the same series.
> 
> Unfortunately, I had to break sending the patch series into a few
> pushes, as my mailbomb script has a logic there that prevents it to
> send more than 30~50 emails (I never remember the exact setting).
> 
> So, I pushed this 80-series into a few pushes. You likely compiled the
> tree without waiting for the hole series to be upstreamed.

Sorry, I sent the reply to the wrong patch. The above comments are for
this patch:
	Subject: [PATCH linuxtv-media] drx-j: drxj_default_aud_data_g can be static

That was on the email with this title:
	[linuxtv-media:master 428/499] drivers/media/dvb-frontends/drx39xyj/drxj.c:1039:16: sparse: symbol 'drxj_default_aud_data_g' was not declared. Should

Regards,
Mauro

> 
> Regards,
> Mauro
> 
> Em Tue, 04 Feb 2014 17:02:02 +0800
> kbuild test robot <fengguang.wu@intel.com> escreveu:
> 
> > tree:   git://linuxtv.org/media_tree.git master
> > head:   a3550ea665acd1922df8275379028c1634675629
> > commit: a3550ea665acd1922df8275379028c1634675629 [499/499] [media] usbtv: split core and video implementation
> > reproduce: make C=1 CF=-D__CHECK_ENDIAN__
> > 
> > 
> > sparse warnings: (new ones prefixed by >>)
> > 
> > >> drivers/media/usb/usbtv/usbtv-core.c:119:22: sparse: symbol 'usbtv_id_table' was not declared. Should it be static?
> > >> drivers/media/usb/usbtv/usbtv-core.c:129:19: sparse: symbol 'usbtv_usb_driver' was not declared. Should it be static?
> > --
> > >> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:285:14: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:287:20: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:288:15: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:289:20: sparse: cast to restricted __be32
> > >> drivers/media/usb/usbtv/usbtv-video.c:565:23: sparse: symbol 'usbtv_ioctl_ops' was not declared. Should it be static?
> > >> drivers/media/usb/usbtv/usbtv-video.c:587:29: sparse: symbol 'usbtv_fops' was not declared. Should it be static?
> > >> drivers/media/usb/usbtv/usbtv-video.c:648:16: sparse: symbol 'usbtv_vb2_ops' was not declared. Should it be static?
> > 
> > Please consider folding the attached diff :-)
> > 
> > ---
> > 0-DAY kernel build testing backend              Open Source Technology Center
> > http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> 
> 


-- 

Cheers,
Mauro
