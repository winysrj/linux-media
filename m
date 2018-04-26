Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49542 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755468AbeDZMEg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 08:04:36 -0400
Date: Thu, 26 Apr 2018 15:04:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] media: Add a driver for the ov7251 camera sensor
Message-ID: <20180426120434.2k6kkwpchm5pnksz@valkosipuli.retiisi.org.uk>
References: <1524673246-14175-1-git-send-email-todor.tomov@linaro.org>
 <1524673246-14175-3-git-send-email-todor.tomov@linaro.org>
 <20180426065010.a67iqsaicpgu7m5b@valkosipuli.retiisi.org.uk>
 <c065854a-084d-8bc8-a76e-2988be8c3788@linaro.org>
 <20180426071656.wuq5f7prg6kig6oy@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180426071656.wuq5f7prg6kig6oy@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 26, 2018 at 10:16:56AM +0300, Sakari Ailus wrote:
> On Thu, Apr 26, 2018 at 10:04:25AM +0300, Todor Tomov wrote:
> > Hi Sakari,
> > 
> > On 26.04.2018 09:50, Sakari Ailus wrote:
> > > Hi Todor,
> > > 
> > > On Wed, Apr 25, 2018 at 07:20:46PM +0300, Todor Tomov wrote:
> > > ...
> > >> +static int ov7251_write_reg(struct ov7251 *ov7251, u16 reg, u8 val)
> > >> +{
> > >> +	u8 regbuf[3];
> > >> +	int ret;
> > >> +
> > >> +	regbuf[0] = reg >> 8;
> > >> +	regbuf[1] = reg & 0xff;
> > >> +	regbuf[2] = val;
> > >> +
> > >> +	ret = i2c_master_send(ov7251->i2c_client, regbuf, 3);
> > >> +	if (ret < 0) {
> > >> +		dev_err(ov7251->dev, "%s: write reg error %d: reg=%x, val=%x\n",
> > >> +			__func__, ret, reg, val);
> > >> +		return ret;
> > >> +	}
> > >> +
> > >> +	return 0;
> > > 
> > > How about:
> > > 
> > > 	return ov7251_write_seq_regs(ov7251, reg, &val, 1);
> > > 
> > > And put the function below ov2751_write_seq_regs().
> > 
> > I'm not sure... It will calculate message length each time and then check
> > that it is not greater than 5, which it is. Seems redundant.
> > 
> > > 
> > >> +}
> > >> +
> > >> +static int ov7251_write_seq_regs(struct ov7251 *ov7251, u16 reg, u8 *val,
> > >> +				 u8 num)
> > >> +{
> > >> +	const u8 maxregbuf = 5;
> > >> +	u8 regbuf[maxregbuf];

Apparently this leads to bad positive sparse warning. I'd fix it by:

diff --git a/drivers/media/i2c/ov7251.c b/drivers/media/i2c/ov7251.c
index 3e2c0c03dfa9..d3ebb7529fca 100644
--- a/drivers/media/i2c/ov7251.c
+++ b/drivers/media/i2c/ov7251.c
@@ -643,12 +643,11 @@ static int ov7251_write_reg(struct ov7251 *ov7251, u16 reg, u8 val)
 static int ov7251_write_seq_regs(struct ov7251 *ov7251, u16 reg, u8 *val,
                                 u8 num)
 {
-       const u8 maxregbuf = 5;
-       u8 regbuf[maxregbuf];
+       u8 regbuf[5];
        u8 nregbuf = sizeof(reg) + num * sizeof(*val);
        int ret = 0;
 
-       if (nregbuf > maxregbuf)
+       if (nregbuf > sizeof(regbuf))
                return -EINVAL;
 
        regbuf[0] = reg >> 8;

Let me know if you're happy with that; I can merge it to the original
patch.

> > >> +	u8 nregbuf = sizeof(reg) + num * sizeof(*val);
> > >> +	int ret = 0;
> > >> +
> > >> +	if (nregbuf > maxregbuf)
> > >> +		return -EINVAL;
> > >> +
> > >> +	regbuf[0] = reg >> 8;
> > >> +	regbuf[1] = reg & 0xff;
> > >> +
> > >> +	memcpy(regbuf + 2, val, num);
> > >> +
> > >> +	ret = i2c_master_send(ov7251->i2c_client, regbuf, nregbuf);
> > >> +	if (ret < 0) {
> > >> +		dev_err(ov7251->dev, "%s: write seq regs error %d: first reg=%x\n",
> > > 
> > > This line is over 80... 
> > 
> > Yes indeed. Somehow checkpatch does not report this line, I don't know why.
> > 
> > > 
> > > If you're happy with these, I can make the changes, too; they're trivial.
> > 
> > Only the second one? Thanks :)
> 
> Works for me. I'd still think the overhead of managing the buffer is
> irrelevant where to having an extra function to do essentially the same
> thing is a source of maintenance and review work. Note that we're even now
> spending time to discuss it. ;-)
> 
> -- 
> Kind regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
