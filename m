Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:62162 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756517AbeDXKEW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 06:04:22 -0400
Date: Tue, 24 Apr 2018 13:04:19 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v3 02/11] media: ov772x: allow i2c controllers without
 I2C_FUNC_PROTOCOL_MANGLING
Message-ID: <20180424100419.5yhk22sezhuaw2qt@paasikivi.fi.intel.com>
References: <1524412577-14419-1-git-send-email-akinobu.mita@gmail.com>
 <6809346.dy34v3ukH6@avalon>
 <20180423203615.2ntymbibkgw2aiks@ninjato>
 <2216127.6rtmsKdYAn@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2216127.6rtmsKdYAn@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

On Mon, Apr 23, 2018 at 11:51:30PM +0300, Laurent Pinchart wrote:
> Hi Wolfram,
> 
> On Monday, 23 April 2018 23:36:16 EEST Wolfram Sang wrote:
> > > SCCB helpers would work too. It would be easy to just move the functions
> > > defined in this patch to helpers and be done with it. However, there are
> > > I2C adapters that have native SCCB support, so to take advantage of that
> > > feature
> > 
> > Ah, didn't notice that so far. Can't find it in drivers/i2c/busses.
> > Where are those?
> 
> IIRC the OMAP I2C adapter supports SCCB natively. I'm not sure the driver 
> implements that though.
> 
> > > we need to forward native SCCB calls all the way down the stack in that
> > > case.
> > 
> > And how is it done currently?
> 
> Currently we go down to .master_xfer(), and adapters can then decide to use 
> the hardware SCCB support. Again, it might not be implemented :-)
> 
> > > That's why I thought an implementation in the I2C subsystem would be
> > > better. Furthermore, as SCCB is really a slightly mangled version of I2C,
> > > I think the I2C subsystem would be a natural location for the
> > > implementation. It shouldn't
> > 
> > Can be argued. But it can also be argues that it sits on top of I2C and
> > doesn't need to live in i2c-folders itself (like PMBus). The
> > implementation given in this patch looks a bit like the latter. However,
> > this is not the main question currently.
> > 
> > > be too much work, it's just a matter of deciding what the call stacks
> > > should be for the native vs. emulated cases.
> > 
> > I don't like it. We shouldn't use SMBus calls for SCCB because SMBus
> > will very likely never support it. Or do you know of such a case? I
> > think I really want sccb helpers. So, people immediately see that SCCB
> > is used and not SMBus or I2C. And there, we can handle native support
> > vs. I2C-SCCB-emulation. And maybe SMBus-SCCB emulation but I doubt we
> > will ever need it.
> 
> I'm fine with SCCB helpers. Please note, however, that SCCB differs from SMBus 
> in two ways: NACKs shall be ignored by the master (even though most SCCB 
> devices generate an ack, so we could likely ignore this), and write-read 
> sequences shouldn't use a repeated start. Apart from that register reads and 
> register writes are identical to SMBus, which prompted the reuse (or abuse) of 
> the SMBus API. If we end up implementing SCCB helpers, they will likely look 
> very, very similar to the SMBus implementation, including the SMBus emulated 
> transfer helper.

Sounds like that there would be a bit of work to do here but AFAIU the
patchset should be fine to go in (with the other comments addressed) and
this could be addressed separately. Let me know if you have concerns.

Thanks.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
