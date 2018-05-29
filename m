Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44018 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754903AbeE2Ocu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 10:32:50 -0400
Date: Tue, 29 May 2018 11:32:44 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v5 03/14] media: ov772x: allow i2c controllers without
 I2C_FUNC_PROTOCOL_MANGLING
Message-ID: <20180529113226.720e61fc@vento.lan>
In-Reply-To: <20180529132929.zthorwdp2axxogvd@ninjato>
References: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
        <1525616369-8843-4-git-send-email-akinobu.mita@gmail.com>
        <20180529095657.675a6f54@vento.lan>
        <20180529132929.zthorwdp2axxogvd@ninjato>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 29 May 2018 15:29:29 +0200
Wolfram Sang <wsa@the-dreams.de> escreveu:

> > It is a very bad idea to replace an i2c xfer by a pair of i2c
> > send()/recv(), as, if are there any other device at the bus managed
> > by an independent driver, you may end by mangling i2c transfers and
> > eventually cause device malfunctions.  
> 
> For I2C, this is true and a very important detail. Yet, we are talking
> not I2C but SCCB here and SCCB demands a STOP between messages. So,
> technically, to avoid what you describe one shouldn't mix I2C and SCCB
> devices. I am quite aware the reality is very different, but still...
> 
> My preference would be to stop acting as SCCB was I2C but give it its
> own set of functions so it becomes clear for everyone what protocol is
> used for what device.
> 
> > So, IMO, the best is to push the patch you proposed that adds a
> > new I2C flag:
> > 
> > 	https://patchwork.linuxtv.org/patch/49396/  
> 
> Sorry, but I don't like it. This makes the I2C core code very
> unreadable. This is why I think SCCB should be exported to its own
> realm. Which may live in i2c-core-sccb.c, no need for a seperate
> subsystem.

We actually have the same issue with pure I2C devices on media.
There are several I2C devices that don't accept repeat start.

The solution given there was hackish and varies from driver to driver.
The most common solution were to patch the I2C xfer callback 
function of the I2C master code in order to prevent them to do
I2C repeated start ops, usually checking for some specific I2C
addresses where repeated start is known to not working.

So, IMHO, a flag like that would be an improvement not only for
SCCB but also for other I2C devices. Probably there would be
other ways to do it without making the I2C core code harder to
read.

Thanks,
Mauro
