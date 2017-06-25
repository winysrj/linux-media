Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33576 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdFYRxH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 13:53:07 -0400
Received: by mail-wr0-f193.google.com with SMTP id x23so25601169wrb.0
        for <linux-media@vger.kernel.org>; Sun, 25 Jun 2017 10:53:06 -0700 (PDT)
Date: Sun, 25 Jun 2017 19:52:59 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Ralph Metzler <rjkm@metzlerbros.de>, linux-media@vger.kernel.org,
        mchehab@kernel.org, liplianin@netup.ru, crope@iki.fi,
        "Jasmin J." <jasmin@anw.at>,
        "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>,
        "tbird20d@gmail.com" <tbird20d@gmail.com>
Subject: Re: DD support improvements (was: Re: [PATCH v3 00/13]
 stv0367/ddbridge: support CTv6/FlexCT hardware)
Message-ID: <20170625195259.1623ef71@audiostation.wuest.de>
In-Reply-To: <20170624135001.5bcafb64@vento.lan>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
        <20170412212327.5b75be19@macbox>
        <20170507174212.2e45ab71@audiostation.wuest.de>
        <20170528234537.3bed2dde@macbox>
        <20170619221821.022fc473@macbox>
        <20170620093645.6f72fd1a@vento.lan>
        <20170620204121.4cff42d1@macbox>
        <20170620161043.1e6a1364@vento.lan>
        <20170621225712.426d3a17@audiostation.wuest.de>
        <22860.14367.464168.657791@morden.metzler>
        <20170624135001.5bcafb64@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sat, 24 Jun 2017 13:50:01 -0300
schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Em Thu, 22 Jun 2017 23:35:27 +0200
> Ralph Metzler <rjkm@metzlerbros.de> escreveu:
> 
> Would it be possible to change things at the dddvb tree to make
> it to use our coding style (for example, replacing CamelCase by the
> kernel_style), in order to minimize the amount of work to sync from
> your tree?

Note that this mostly (if not only) applies to the demodulator drivers. ddbridge itself is okay in this regard and has only some minors like indent, whitespace and such. There's one bigger thing though I'm not sure of if it needs to be changed: Beginning with the 0.9.9-tarball release, functionality was split from ddbridge-core.c into ddbridge.c, ddbridge-i2c.c, ddbridge-mod.c and ddbridge-ns.c (the two latter being modulator and netstream/octonet related code, which we don't need at this time). The issue is that this wasn't done by updating the build system to build multiple objects, but rather build from ddbridge.c which then does '#include "ddbridge-core.c"', and in that file '#include "ddbridge-i2c.c"'. See [1] for how it actually looks like in the file. Mauro, do you think this is acceptable?

> > Regarding divergence in the tuner/demod drivers I see some concerns. 
> > The TDA18212 driver as they are presently in kernel and Daniel's  github tree still seems to be missing features
> > like calibration and spur avoidance. This problem was already discussed here a few years ago.
> > I would not want to move to these versions if those features are still missing.  
> 
> I don't see any issue on adding the missing features to the existing
> tda18212 driver. Maybe Daniel can help adding the missing features there.
> 
> The best would be to make those new features opt-in, in order to allow 
> drivers to gradually use them (after tests), avoiding regressions.

I already started something when I searched for possible reasons for the stv0367 I2C bus crashes and implemented the tuner calibration (this wasn't the reason in the end, but still), see [2]. Guess a config flag like in [3] will work. But I'd need advice in what parts are required to be ported over if I should do this.

> > - adding SYS_DVBC2 to fe_delivery_system   
> 
> OK, we can do that, when adding a driver needing such feature.

I might volunteer in adding DVB-C2 support to cxd2841er in porting needed bits over from the cxd2843 driver, but someone else need to do testing on a DVB-C2 enabled coax cable.

Best regards,
Daniel Scheller

[1] https://github.com/herrnst/dddvb-linux-kernel/blob/17d60ca45dd0294120882af9abbbdf9e5a130cb5/drivers/media/pci/ddbridge/ddbridge.c#L50
[2] https://github.com/herrnst/dddvb-linux-kernel/commit/0788bd5e05fffdcd2d00d1fa2732c9712c6c759d
[3] https://patchwork.linuxtv.org/patch/40710/
-- 
https://github.com/herrnst
