Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:11086 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaEZQDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 12:03:18 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N66000QLV9HD480@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 26 May 2014 12:03:17 -0400 (EDT)
Date: Mon, 26 May 2014 13:03:11 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
Cc: Christian Ruppert <chrisr@abilis.com>,
	Ole Ernst <olebowle@gmx.com>, linux-media@vger.kernel.org
Subject: Re: Linux DVB frontend issue
Message-id: <20140526130311.3aa335e9.m.chehab@samsung.com>
In-reply-to: <1586019348.6279.1401113868322.JavaMail.root@abilis.com>
References: <832879218.6141.1401112530064.JavaMail.root@abilis.com>
 <1586019348.6279.1401113868322.JavaMail.root@abilis.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Romain,

Em Mon, 26 May 2014 16:17:48 +0200 (CEST)
Romain Baeriswyl <Romain.Baeriswyl@abilis.com> escreveu:

> Dear Mauro,
> 
> We are using the Linux DVB frontend module on our platform and 
> we are facing an issue when having concurrent calls with FE_SET_FRONTEND
> and FE_GET_FRONTEND ioctl.
> 
> Issue is that both ioctls are using the same dtv_property_cache buffer.
> If a FE_SET_FRONTEND ioctl is interrupted by a FE_GET_FRONTEND then the 
> dtv_property_cache is overwritten with the result of the FE_GET_FRONTEND. 
> When the FE_SET_FRONTEND operation resumes, the dtv_property_cache may
> not be accurate anymore.
> 
> Did you already face this issue?

No. Never tried to do it in practice, but I don't think it is even
possible to have two concurrent ioctl calls ATM, because there is a
semaphore at dvb_frontend_ioctl() preventing it.

> Up to now I tried, without success, to think on a fix that does not impact
> too much the existing code.
> 
> One solution could be to have one cache for reading properties and one other 
> cache for writing properties, but this will impact all the drivers below 
> the DVB frontend.
> 
> Do you see another less impacting solution?

Are you sure that the corruption you're seeing is not at userspace
sharing the same buffer for both ioctl's?

> 
> Best regards,
> 
> Romain Baeriswyl
> 
> Abilis Systems 
> 3, chemin Pré Fleuri
> CH-1228 Plan-Les-Ouates
> Geneva
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
