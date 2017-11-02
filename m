Return-path: <linux-media-owner@vger.kernel.org>
Received: from 178.115.242.59.static.drei.at ([178.115.242.59]:56717 "EHLO
        mail.osadl.at" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1755215AbdKBKW4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 06:22:56 -0400
Date: Thu, 2 Nov 2017 10:22:50 +0000
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Nicholas Mc Guire <hofrat@osadl.org>
Subject: Re: [PATCH v2 19/26] media: ov9650: fix bogus warnings
Message-ID: <20171102102250.GA7932@osadl.at>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
 <a4092bf193d3a1c9ccd0dae4a735a1cbf5261ecd.1509569763.git.mchehab@s-opensource.com>
 <20171102100606.GC2552@osadl.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102100606.GC2552@osadl.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 02, 2017 at 10:06:06AM +0000, Nicholas Mc Guire wrote:
> On Wed, Nov 01, 2017 at 05:05:56PM -0400, Mauro Carvalho Chehab wrote:
> > The smatch logic gets confused with the syntax used to check if the
> > ov9650x_read() reads succedded:
> > 	drivers/media/i2c/ov9650.c:895 __g_volatile_ctrl() error: uninitialized symbol 'reg2'.
> > 	drivers/media/i2c/ov9650.c:895 __g_volatile_ctrl() error: uninitialized symbol 'reg1'.
> > 
> > There's nothing wrong with the original logic, except that
> > it is a little more harder to review.
> 
> Maybe I do not understand the original logic correctly but
> ov965x_read(...) is passing on the return value from 
> i2c_transfer() -> __i2c_transfer() and thus if one of those
> calls would have been a negativ error status it would have simply
> executed the next call to ov965x_read() and if that 
> call would have suceeded it would eventually reach the
> line " exposure = ((reg2 & 0x3f) << 10) | (reg1 << 2) |..."
> with the potential to operate on uninitialized registers reg0/1/2
> the current code sems only to handle error conditions in the last
> call to ov965x_read() correctly.

sorry - sent that out too fast - the logic is equivalent the negative
returns are treated correctly because only the success case is 
being returned explicidly as 0 in ov965x_read() return statement
by checking for the expecte return of 1 from i2c_transfer() wrapping
it to 0.

sorry for the noise.

thx!
hofrat

> 
> I think this is actually not an equivalent transform but a bug-fix
> of  case V4L2_CID_EXPOSURE_AUTO: (aside from being a code inconsistency)
> So should this not carry a 
>  Fixes: 84a15ded76ec ("[media] V4L: Add driver for OV9650/52 image sensors")
> tag ?
> 
> thx!
> hofrat
> 
> > 
> > So, let's stick with the syntax that won't cause read
> > issues.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> Reviewed-by: Nicholas Mc Guire <hofrat@osadl.org>
> 
> > ---
> >  drivers/media/i2c/ov9650.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
> > index 69433e1e2533..e519f278d5f9 100644
> > --- a/drivers/media/i2c/ov9650.c
> > +++ b/drivers/media/i2c/ov9650.c
> > @@ -886,10 +886,12 @@ static int __g_volatile_ctrl(struct ov965x *ov965x, struct v4l2_ctrl *ctrl)
> >  		if (ctrl->val == V4L2_EXPOSURE_MANUAL)
> >  			return 0;
> >  		ret = ov965x_read(client, REG_COM1, &reg0);
> > -		if (!ret)
> > -			ret = ov965x_read(client, REG_AECH, &reg1);
> > -		if (!ret)
> > -			ret = ov965x_read(client, REG_AECHM, &reg2);
> > +		if (ret < 0)
> > +			return ret;
> > +		ret = ov965x_read(client, REG_AECH, &reg1);
> > +		if (ret < 0)
> > +			return ret;
> > +		ret = ov965x_read(client, REG_AECHM, &reg2);
> >  		if (ret < 0)
> >  			return ret;
> >  		exposure = ((reg2 & 0x3f) << 10) | (reg1 << 2) |
> > -- 
> > 2.13.6
> > 
