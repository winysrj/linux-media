Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60594 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753385AbeC1OfG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 10:35:06 -0400
Date: Wed, 28 Mar 2018 11:34:56 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Avraham Shukron <avraham.shukron@gmail.com>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 12/18] media: staging: atomisp: avoid a warning if 32
 bits build
Message-ID: <20180328113448.51421aac@vento.lan>
In-Reply-To: <20180328141329.6nhx5qcaigqwz25d@mwanda>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
        <313cb7db7e3fc7c7c14d2e82e249ccebcbd51ff8.1522098456.git.mchehab@s-opensource.com>
        <20180328141329.6nhx5qcaigqwz25d@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 28 Mar 2018 17:13:29 +0300
Dan Carpenter <dan.carpenter@oracle.com> escreveu:

> On Mon, Mar 26, 2018 at 05:10:45PM -0400, Mauro Carvalho Chehab wrote:
> > Checking if a size_t value is bigger than ULONG_INT only makes
> > sense if building on 64 bits, as warned by:
> > 	drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c:697 gmin_get_config_var() warn: impossible condition '(*out_len > (~0)) => (0-u32max > u32max)'
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  .../staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c    | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
> > index be0c5e11e86b..3283c1b05d6a 100644
> > --- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
> > +++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
> > @@ -693,9 +693,11 @@ static int gmin_get_config_var(struct device *dev, const char *var,
> >  	for (i = 0; i < sizeof(var8) && var8[i]; i++)
> >  		var16[i] = var8[i];
> >  
> > +#ifdef CONFIG_64BIT
> >  	/* To avoid owerflows when calling the efivar API */
> >  	if (*out_len > ULONG_MAX)
> >  		return -EINVAL;
> > +#endif  
> 
> I should just silence this particular warning in Smatch.  I feel like
> this is a pretty common thing and the ifdefs aren't very pretty.  :(

Smatch actually warned about a real thing here: atomisp is
doing a check in 32bits that it is always true. So, IMO,
something is needed to prevent 32bits extra useless code somehow,
perhaps via some EFI-var specific function that would do nothing
on 32 bits.

That's the first time I noticed this code on media (although I might
have missed something), so I guess this kind of checking is actually
not that common.

Regards,
Mauro
