Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:46707 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965664AbeEXJaJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 05:30:09 -0400
Date: Thu, 24 May 2018 11:30:06 +0200
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        alsa-devel@alsa-project.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2 05/13] mtd: rawnand: marvell: remove the dmaengine
 compat need
Message-ID: <20180524113006.3d5f393e@xps13>
In-Reply-To: <20180524070703.11901-6-robert.jarzmik@free.fr>
References: <20180524070703.11901-1-robert.jarzmik@free.fr>
        <20180524070703.11901-6-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Thu, 24 May 2018 09:06:55 +0200, Robert Jarzmik
<robert.jarzmik@free.fr> wrote:

> As the pxa architecture switched towards the dmaengine slave map, the
> old compatibility mechanism to acquire the dma requestor line number and
> priority are not needed anymore.
> 
> This patch simplifies the dma resource acquisition, using the more
> generic function dma_request_slave_channel().
> 
> Signed-off-by: Signed-off-by: Daniel Mack <daniel@zonque.org>
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/mtd/nand/raw/marvell_nand.c | 17 +----------------
>  1 file changed, 1 insertion(+), 16 deletions(-)
> 

Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>

Thanks,
Miquèl
