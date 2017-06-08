Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48060 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbdFHPgr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 11:36:47 -0400
Subject: Re: linux-next: Tree for Jun 8 (drivers/media/i2c/adv7604.c)
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mats Randgaard <mats.randgaard@cisco.com>
References: <20170608175055.6bb6fb21@canb.auug.org.au>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6eaaa02b-7940-bb4b-33c8-ce449ce27bda@infradead.org>
Date: Thu, 8 Jun 2017 08:36:38 -0700
MIME-Version: 1.0
In-Reply-To: <20170608175055.6bb6fb21@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/08/17 00:50, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20170607:
> 

on x86_64: (randconfig)

CONFIG_VIDEO_ADV7604=y
# CONFIG_VIDEO_ADV7604_CEC is not set
CONFIG_COMPILE_TEST=y


drivers/built-in.o: In function `adv76xx_unregistered':
adv7604.c:(.text+0x43ad91): undefined reference to `cec_unregister_adapter'
drivers/built-in.o: In function `adv76xx_registered':
adv7604.c:(.text+0x43adc4): undefined reference to `cec_register_adapter'
adv7604.c:(.text+0x43adef): undefined reference to `cec_delete_adapter'
drivers/built-in.o: In function `adv76xx_set_edid':
adv7604.c:(.text+0x43daab): undefined reference to `cec_get_edid_phys_addr'
adv7604.c:(.text+0x43dabd): undefined reference to `cec_phys_addr_validate'
adv7604.c:(.text+0x43df5d): undefined reference to `cec_s_phys_addr'




-- 
~Randy
