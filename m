Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48052 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbeIMWYn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 18:24:43 -0400
Subject: Re: linux-next: Tree for Sep 13 (drivers/media/platform/imx-pxp)
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
References: <20180913152753.60866288@canb.auug.org.au>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <d0604bdf-b8a5-a828-f28e-023e05c767be@infradead.org>
Date: Thu, 13 Sep 2018 10:14:16 -0700
MIME-Version: 1.0
In-Reply-To: <20180913152753.60866288@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9/12/18 10:27 PM, Stephen Rothwell wrote:
> Hi all,
> 
> News: there will be no linux-next releases on Friday or Monday.
> 
> Changes since 20180912:
> 

on i386 or x86_64:

../drivers/media/platform/imx-pxp.c:988:1: error: unknown type name 'irqreturn_t'
 static irqreturn_t pxp_irq_handler(int irq, void *dev_id)
 ^
../drivers/media/platform/imx-pxp.c: In function 'pxp_irq_handler':
../drivers/media/platform/imx-pxp.c:1012:9: error: 'IRQ_HANDLED' undeclared (first use in this function)
  return IRQ_HANDLED;
         ^
../drivers/media/platform/imx-pxp.c:1012:9: note: each undeclared identifier is reported only once for each function it appears in
../drivers/media/platform/imx-pxp.c: In function 'pxp_probe':
../drivers/media/platform/imx-pxp.c:1660:2: error: implicit declaration of function 'devm_request_threaded_irq' [-Werror=implicit-function-declaration]
  ret = devm_request_threaded_irq(&pdev->dev, irq, NULL, pxp_irq_handler,
  ^
../drivers/media/platform/imx-pxp.c:1661:4: error: 'IRQF_ONESHOT' undeclared (first use in this function)
    IRQF_ONESHOT, dev_name(&pdev->dev), dev);
    ^


Reported-by: Randy Dunlap <rdunlap@infradead.org>

-- 
~Randy
