Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:21126 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaCLK6F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 06:58:05 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2B004G7L4SS790@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Mar 2014 06:58:04 -0400 (EDT)
Date: Wed, 12 Mar 2014 07:57:59 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v4 10/10] rc: img-ir: add Sanyo decoder module
Message-id: <20140312075759.71eceec7@samsung.com>
In-reply-to: <1393630140-31765-11-git-send-email-james.hogan@imgtec.com>
References: <1393630140-31765-1-git-send-email-james.hogan@imgtec.com>
 <1393630140-31765-11-git-send-email-james.hogan@imgtec.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James,

Em Fri, 28 Feb 2014 23:29:00 +0000
James Hogan <james.hogan@imgtec.com> escreveu:

> Add an img-ir module for decoding the Sanyo infrared protocol.

After applying this series, some new warnings are popping up,
when compiled with W=1:

drivers/media/rc/img-ir/img-ir-hw.c: In function 'img_ir_free_timing':
drivers/media/rc/img-ir/img-ir-hw.c:228:23: warning: variable 'maxlen' set but not used [-Wunused-but-set-variable]
  unsigned int minlen, maxlen, ft_min;
                       ^
drivers/media/rc/img-ir/img-ir-hw.c:228:15: warning: variable 'minlen' set but not used [-Wunused-but-set-variable]
  unsigned int minlen, maxlen, ft_min;
               ^
drivers/media/rc/img-ir/img-ir-jvc.c:76:3: warning: initialized field overwritten [-Woverride-init]
   },
   ^
drivers/media/rc/img-ir/img-ir-jvc.c:76:3: warning: (near initialization for 'img_ir_jvc.timings.s00') [-Woverride-init]
drivers/media/rc/img-ir/img-ir-jvc.c:81:3: warning: initialized field overwritten [-Woverride-init]
   },
   ^
drivers/media/rc/img-ir/img-ir-jvc.c:81:3: warning: (near initialization for 'img_ir_jvc.timings.s01') [-Woverride-init]

Please fix.

Regards,
Mauro
