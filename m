Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50750 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751758AbdF2JnG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 05:43:06 -0400
Date: Thu, 29 Jun 2017 11:42:59 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND 0/7] Introduce MEDIA_VERSION to end KENREL_VERSION
 abuse in media
Message-ID: <20170629094259.GG3808@linux-x5ow.site>
References: <20170621080812.6817-1-jthumshirn@suse.de>
 <20170624171507.38353b10@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170624171507.38353b10@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 24, 2017 at 05:15:07PM -0300, Mauro Carvalho Chehab wrote:
> Sorry, but I can't see any advantage on it. On the downside, it
> includes the media controller header file (media.h) where it
> is not needed.

My reasoning was the differences in semantics. KERNEL_VERSION() is for
encoding the kernel's version triplet not a API or Hardware or whatever
version. Other subsystems do this as well, for instance in NVMe we have the
NVME_VS() macro which is used to encode the NVMe Spec compliance from a human
readable form to the hardware's u32. Also KERNEL_VERISON() shouldn't have
in-tree users IMHO. Yes there is _one_ other user of it in-tree which is EXT4
and I already talked to Jan Kara about it and we decided to leave it in until
4.20.

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
