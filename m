Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39147 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753516AbdGUQMN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 12:12:13 -0400
Subject: Re: linux-next: Tree for Jul 21 (drivers/media: use of __WARN())
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-media <linux-media@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <20170721141019.5776e9a0@canb.auug.org.au>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <33fa1f04-8262-e18e-9f86-89d3e254554c@infradead.org>
Date: Fri, 21 Jul 2017 09:12:12 -0700
MIME-Version: 1.0
In-Reply-To: <20170721141019.5776e9a0@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/20/2017 09:10 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20170720:
> 

on x86_64:
when CONFIG_BUG is not enabled:

../drivers/media/platform/pxa_camera.c:642:3: error: implicit declaration of function ‘__WARN’ [-Werror=implicit-function-declaration]
../drivers/media/platform/soc_camera/soc_mediabus.c:512:3: error: implicit declaration of function ‘__WARN’ [-Werror=implicit-function-declaration]


-- 
~Randy
