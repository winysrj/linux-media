Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:43974 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755739AbdCLPAu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 11:00:50 -0400
Date: Sun, 12 Mar 2017 16:00:23 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: walter harms <wharms@bfs.de>
cc: Colin King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: atomisp: clean up return logic, remove redunant
 code
In-Reply-To: <58C561B5.8080102@bfs.de>
Message-ID: <alpine.DEB.2.20.1703121559470.2174@hadrien>
References: <20170311193205.6410-1-colin.king@canonical.com> <58C561B5.8080102@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 12 Mar 2017, walter harms wrote:

>
>
> Am 11.03.2017 20:32, schrieb Colin King:
> > From: Colin Ian King <colin.king@canonical.com>
> >
> > There is no need to check if ret is non-zero, remove this
> > redundant check and just return the error status from the call
> > to mt9m114_write_reg_array.
> >
> > Detected by CoverityScan, CID#1416577 ("Identical code for
> > different branches")
> >
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  drivers/staging/media/atomisp/i2c/mt9m114.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> >
> > diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
> > index 8762124..a555aec 100644
> > --- a/drivers/staging/media/atomisp/i2c/mt9m114.c
> > +++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
> > @@ -444,12 +444,8 @@ static int mt9m114_set_suspend(struct v4l2_subdev *sd)
> >  static int mt9m114_init_common(struct v4l2_subdev *sd)
> >  {
> >  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > -	int ret;
> >
> > -	ret = mt9m114_write_reg_array(client, mt9m114_common, PRE_POLLING);
> > -	if (ret)
> > -		return ret;
> > -	return ret;
> > +	return mt9m114_write_reg_array(client, mt9m114_common, PRE_POLLING);
> >  }
>
>
> any use for "client" ?

I guess the code would be on two lines in any case.  It looks like a nice
decomposition as is.

julia
