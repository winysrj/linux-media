Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36290 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbcEXJJl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 05:09:41 -0400
Received: by mail-wm0-f68.google.com with SMTP id q62so4078467wmg.3
        for <linux-media@vger.kernel.org>; Tue, 24 May 2016 02:09:41 -0700 (PDT)
Date: Tue, 24 May 2016 11:09:38 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sre@kernel.org,
	pavel@ucw.cz, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 04/24] smiapp-pll: Take existing divisor into account
 in minimum divisor check
Message-ID: <20160524090938.GL29844@pali>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1461532104-24032-5-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160501104524.GD26360@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160501104524.GD26360@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 01 May 2016 13:45:24 Sakari Ailus wrote:
> Hi Ivaylo,
> 
> On Mon, Apr 25, 2016 at 12:08:04AM +0300, Ivaylo Dimitrov wrote:
> > From: Sakari Ailus <sakari.ailus@iki.fi>
> > 
> > Required added multiplier (and divisor) calculation did not take into
> > account the existing divisor when checking the values against the minimum
> > divisor. Do just that.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/i2c/smiapp-pll.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
> > index e3348db..5ad1edb 100644
> > --- a/drivers/media/i2c/smiapp-pll.c
> > +++ b/drivers/media/i2c/smiapp-pll.c
> > @@ -227,7 +227,8 @@ static int __smiapp_pll_calculate(
> >  
> >  	more_mul_factor = lcm(div, pll->pre_pll_clk_div) / div;
> >  	dev_dbg(dev, "more_mul_factor: %u\n", more_mul_factor);
> > -	more_mul_factor = lcm(more_mul_factor, op_limits->min_sys_clk_div);
> > +	more_mul_factor = lcm(more_mul_factor,
> > +			      DIV_ROUND_UP(op_limits->min_sys_clk_div, div));
> >  	dev_dbg(dev, "more_mul_factor: min_op_sys_clk_div: %d\n",
> >  		more_mul_factor);
> >  	i = roundup(more_mul_min, more_mul_factor);
> 
> I remember writing the patch, but I don't remember what for, or whether it
> was really needed. Does the secondary sensor work without this one?

Hi! You sent me this patch more then 3 years ago. Look at our private
email discussion, e.g. email with Message-Id <201303281524.10538@pali>
and subject "Re: Nokia N900 - smiapp driver" which was sent years ago
Thu, 28 Mar 2013 15:24:10 +0100.

-- 
Pali Rohár
pali.rohar@gmail.com
