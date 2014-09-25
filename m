Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40084 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaIYKlF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 06:41:05 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Message-id: <5423F131.50300@samsung.com>
Date: Thu, 25 Sep 2014 12:40:49 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 17/18] [media] s3c-camif: fix dma_addr_t printks
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
 <4749fc9fe2ece4e42627b27b01d6939c536fbcea.1411597610.git.mchehab@osg.samsung.com>
In-reply-to: <4749fc9fe2ece4e42627b27b01d6939c536fbcea.1411597610.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/09/14 00:27, Mauro Carvalho Chehab wrote:
> drivers/media//platform/s3c-camif/camif-capture.c: In function ‘camif_prepare_addr’:
> include/linux/dynamic_debug.h:64:16: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 5 has type ‘dma_addr_t’ [-Wformat=]
>   static struct _ddebug  __aligned(8)   \
[...]
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Thanks,

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
