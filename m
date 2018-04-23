Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:40322 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752086AbeDWUVS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 16:21:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v3 02/11] media: ov772x: allow i2c controllers without I2C_FUNC_PROTOCOL_MANGLING
Date: Mon, 23 Apr 2018 23:21:30 +0300
Message-ID: <6809346.dy34v3ukH6@avalon>
In-Reply-To: <20180423201121.cgcg6isobtku7swy@ninjato>
References: <1524412577-14419-1-git-send-email-akinobu.mita@gmail.com> <3172940.h9isB0x1K9@avalon> <20180423201121.cgcg6isobtku7swy@ninjato>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wolfram,

On Monday, 23 April 2018 23:11:21 EEST Wolfram Sang wrote:
> > How about i2c_smbus_xfer_emulated() ? The tricky part will be to handle
> > the I2C adapters that implement .smbus_xfer(), as those won't go through
> > i2c_smbus_xfer_emulated(). i2c_smbus_xfer_emulated() relies on
> > i2c_transfer(), which itself relies on the I2C adapter's .master_xfer()
> > operation. We're thus only concerned about the drivers that implement
> > both .smbus_xfer() and master_xfer(), and there's only 4 of them
> > (i2c-opal, i2c-pasemi, i2c-powermac and i2c-zx2967). Maybe the simplest
> > solution would be to force the emulation path if I2C_CLIENT_SCCB &&
> > !I2C_FUNC_PROTOCOL_MANGLING && ->master_xfer != NULL ?
> > 
> > Wolfram, what do you think ?
> 
> I think it is a mess :)
> 
> Further: I don't think we will ever see an SMBus controller which allows
> mangling. SMBus is way more precisely defined than I2C, so HW can then
> do much more things automatically. They will always do a REP_START, so I
> don't think you can connect SCCB devices to SMBus.
> 
> As a result, we shouldn't do SMBus calls for SCCB. Maybe we should
> introduce sccb_byte_read? SCCB didn't specify much more than byte read
> IIRC, or? The implementation here with two seperate messages makes much
> sense to me then.
> 
> I could argue that the sccb_* helpers should live in drivers/media since
> it is probably only Omnivision trying to work around I2C licensing here?
> 
> But if it is not too heavy, maybe we could take it into i2c as well.
> 
> Makes sense or did I miss something?

SCCB helpers would work too. It would be easy to just move the functions 
defined in this patch to helpers and be done with it. However, there are I2C 
adapters that have native SCCB support, so to take advantage of that feature 
we need to forward native SCCB calls all the way down the stack in that case. 
That's why I thought an implementation in the I2C subsystem would be better. 
Furthermore, as SCCB is really a slightly mangled version of I2C, I think the 
I2C subsystem would be a natural location for the implementation. It shouldn't 
be too much work, it's just a matter of deciding what the call stacks should 
be for the native vs. emulated cases.

-- 
Regards,

Laurent Pinchart
