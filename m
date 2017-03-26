Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:60484
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751491AbdCZSYa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Mar 2017 14:24:30 -0400
Date: Sun, 26 Mar 2017 15:24:22 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Arushi Singhal <arushisinghal19971997@gmail.com>,
        outreachy-kernel@googlegroups.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: media: omap4iss: Replace a bit shift by a
 use of BIT.
Message-ID: <20170326152422.66e23ea2@vento.lan>
In-Reply-To: <6872312.k89i7RhcDr@avalon>
References: <20170324160145.GA13421@arushi-HP-Pavilion-Notebook>
        <6872312.k89i7RhcDr@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 26 Mar 2017 20:57:02 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Arushi,
> 
> Thank you for the patch.
> 
> On Friday 24 Mar 2017 21:31:45 Arushi Singhal wrote:
> > This patch replaces bit shifting on 1 with the BIT(x) macro.
> > This was done with coccinelle:
> > @@
> > constant c;
> > @@
> > 
> > -1 << c
> > +BIT(c)
> > 
> > Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>  
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Greg, as this is a staging driver, do you want to merge the patch through your 
> tree ?

As this is at staging/media, better to merge via my tree.

Regards,
Mauro

> 
> > ---
> > changes in v2
> >  -Remove unnecessary parenthesis
> > 
> >  drivers/staging/media/omap4iss/iss_csi2.c    | 2 +-
> >  drivers/staging/media/omap4iss/iss_ipipe.c   | 2 +-
> >  drivers/staging/media/omap4iss/iss_ipipeif.c | 2 +-
> >  drivers/staging/media/omap4iss/iss_resizer.c | 2 +-
> >  4 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/staging/media/omap4iss/iss_csi2.c
> > b/drivers/staging/media/omap4iss/iss_csi2.c index
> > f71d5f2f179f..f6acc541e8a2 100644
> > --- a/drivers/staging/media/omap4iss/iss_csi2.c
> > +++ b/drivers/staging/media/omap4iss/iss_csi2.c
> > @@ -1268,7 +1268,7 @@ static int csi2_init_entities(struct iss_csi2_device
> > *csi2, const char *subname) snprintf(name, sizeof(name), "CSI2%s",
> > subname);
> >  	snprintf(sd->name, sizeof(sd->name), "OMAP4 ISS %s", name);
> > 
> > -	sd->grp_id = 1 << 16;	/* group ID for iss subdevs */
> > +	sd->grp_id = BIT(16);	/* group ID for iss subdevs */
> >  	v4l2_set_subdevdata(sd, csi2);
> >  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > 
> > diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c
> > b/drivers/staging/media/omap4iss/iss_ipipe.c index
> > d38782e8e84c..d86ef8a031f2 100644
> > --- a/drivers/staging/media/omap4iss/iss_ipipe.c
> > +++ b/drivers/staging/media/omap4iss/iss_ipipe.c
> > @@ -508,7 +508,7 @@ static int ipipe_init_entities(struct iss_ipipe_device
> > *ipipe) v4l2_subdev_init(sd, &ipipe_v4l2_ops);
> >  	sd->internal_ops = &ipipe_v4l2_internal_ops;
> >  	strlcpy(sd->name, "OMAP4 ISS ISP IPIPE", sizeof(sd->name));
> > -	sd->grp_id = 1 << 16;	/* group ID for iss subdevs */
> > +	sd->grp_id = BIT(16);	/* group ID for iss subdevs */
> >  	v4l2_set_subdevdata(sd, ipipe);
> >  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > 
> > diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c
> > b/drivers/staging/media/omap4iss/iss_ipipeif.c index
> > 23de8330731d..cb88b2bd0d82 100644
> > --- a/drivers/staging/media/omap4iss/iss_ipipeif.c
> > +++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
> > @@ -739,7 +739,7 @@ static int ipipeif_init_entities(struct
> > iss_ipipeif_device *ipipeif) v4l2_subdev_init(sd, &ipipeif_v4l2_ops);
> >  	sd->internal_ops = &ipipeif_v4l2_internal_ops;
> >  	strlcpy(sd->name, "OMAP4 ISS ISP IPIPEIF", sizeof(sd->name));
> > -	sd->grp_id = 1 << 16;	/* group ID for iss subdevs */
> > +	sd->grp_id = BIT(16);	/* group ID for iss subdevs */
> >  	v4l2_set_subdevdata(sd, ipipeif);
> >  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > 
> > diff --git a/drivers/staging/media/omap4iss/iss_resizer.c
> > b/drivers/staging/media/omap4iss/iss_resizer.c index
> > f1d352c711d5..4bbfa20b3c38 100644
> > --- a/drivers/staging/media/omap4iss/iss_resizer.c
> > +++ b/drivers/staging/media/omap4iss/iss_resizer.c
> > @@ -782,7 +782,7 @@ static int resizer_init_entities(struct
> > iss_resizer_device *resizer) v4l2_subdev_init(sd, &resizer_v4l2_ops);
> >  	sd->internal_ops = &resizer_v4l2_internal_ops;
> >  	strlcpy(sd->name, "OMAP4 ISS ISP resizer", sizeof(sd->name));
> > -	sd->grp_id = 1 << 16;	/* group ID for iss subdevs */
> > +	sd->grp_id = BIT(16);	/* group ID for iss subdevs */
> >  	v4l2_set_subdevdata(sd, resizer);
> >  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;  
> 



Thanks,
Mauro
