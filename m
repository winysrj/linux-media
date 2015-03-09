Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36561 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbbCILTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 07:19:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Carlos =?ISO-8859-1?Q?Sanmart=EDn?= Bustos <carsanbu@gmail.com>
Cc: Linux Media <linux-media@vger.kernel.org>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH] v4l: mt9v032: Add OF support
Date: Mon, 09 Mar 2015 13:19:10 +0200
Message-ID: <2182472.9lHHsiQgiX@avalon>
In-Reply-To: <CAPW4HR1WJPWg64GwitxCPK2jop0CntS1UtsOu_0VjCz0BEke6A@mail.gmail.com>
References: <1425822349-19218-1-git-send-email-laurent.pinchart@ideasonboard.com> <CAPW4HR1WJPWg64GwitxCPK2jop0CntS1UtsOu_0VjCz0BEke6A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Carlos,

Thank you for the review.

On Monday 09 March 2015 10:45:31 Carlos Sanmartín Bustos wrote:
> Hi Laurent,
> 
> Looks good. One question, why not deprecate the platform data? I can't
> see any device using the mt9v032 pdata, I was making a similar patch
> but deprecating pdata.

The sensor could be used on non-DT platforms. As keeping platform data support 
doesn't really make the code more complex and doesn't prevent cleanups or 
other refactoring, I don't see much harm in keeping it for now.

For DT-based platforms, of course, DT should be used.

> Some more comment:
> 
> 2015-03-08 14:45 GMT+01:00 Laurent Pinchart:
> > Parse DT properties into a platform data structure when a DT node is
> > available.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  .../devicetree/bindings/media/i2c/mt9v032.txt      | 41 ++++++++++++++
> >  MAINTAINERS                                        |  1 +
> >  drivers/media/i2c/mt9v032.c                        | 66 ++++++++++++++++-
> >  3 files changed, 107 insertions(+), 1 deletion(-)
> >  create mode 100644
> >  Documentation/devicetree/bindings/media/i2c/mt9v032.txt

[snip]

> > diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> > index 3267c18..a6ea091 100644
> > --- a/drivers/media/i2c/mt9v032.c
> > +++ b/drivers/media/i2c/mt9v032.c

[snip]

> > +static struct mt9v032_platform_data *
> > +mt9v032_get_pdata(struct i2c_client *client)
> > +{
> > +       struct mt9v032_platform_data *pdata;
> > +       struct v4l2_of_endpoint endpoint;
> > +       struct device_node *np;
> > +       struct property *prop;
> > +
> > +       if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
> > +               return client->dev.platform_data;
> > +
> > +       np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> > +       if (!np)
> > +               return NULL;
> > +
> > +       if (v4l2_of_parse_endpoint(np, &endpoint) < 0)
> > +               goto done;
> 
> Here I have one little testing:
> 
> if (endpoint.bus_type != V4L2_MBUS_PARALLEL) {
>         dev_err(dev, "invalid bus type, must be parallel\n");
>         goto done;
> }

Good question, should drivers check DT properties that they don't use, in 
order to catch errors in DT ? This would slightly increase the kernel size in 
order to prevent people from connecting a parallel sensor to a CSI-2 bus, 
which is obviously impossible in hardware :-)

> > +
> > +       pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> > +       if (!pdata)
> > +               goto done;
> > +
> > +       prop = of_find_property(np, "link-freqs", NULL);
> > +       if (prop) {
> > +               size_t size = prop->length / 8;
> > +               u64 *link_freqs;
> > +
> > +               link_freqs = devm_kzalloc(&client->dev,
> > +                                         size * sizeof(*link_freqs),
> > +                                         GFP_KERNEL);
> > +               if (!link_freqs)
> > +                       goto done;
> > +
> > +               if (of_property_read_u64_array(np, "link-frequencies",
> > +                                              link_freqs, size) < 0)
> > +                       goto done;
> > +
> > +               pdata->link_freqs = link_freqs;
> > +               pdata->link_def_freq = link_freqs[0];
> > +       }
> > +
> > +       pdata->clk_pol = !!(endpoint.bus.parallel.flags &
> > +                           V4L2_MBUS_PCLK_SAMPLE_RISING);
> > +
> > +done:
> > +       of_node_put(np);
> > +       return pdata;
> > +}

[snip]

> > @@ -1034,9 +1086,21 @@ static const struct i2c_device_id mt9v032_id[] = {
> >  };
> >  MODULE_DEVICE_TABLE(i2c, mt9v032_id);
> > 
> > +#if IS_ENABLED(CONFIG_OF)
> > +static const struct of_device_id mt9v032_of_match[] = {
> > +       { .compatible = "mt9v032" },
> > +       { .compatible = "mt9v032m" },
> > +       { .compatible = "mt9v034" },
> > +       { .compatible = "mt9v034m" },
> > +       { /* Sentinel */ }
> > +};
> > +MODULE_DEVICE_TABLE(of, mt9v032_of_match);
> > +#endif
> 
> I have this:
> #if IS_ENABLED(CONFIG_OF)
> static const struct of_device_id mt9v032_of_match[] = {
>     { .compatible = "aptina,mt9v022", },
>     { .compatible = "aptina,mt9v022m", },
>     { .compatible = "aptina,mt9v024", },
>     { .compatible = "aptina,mt9v024m", },
>     { .compatible = "aptina,mt9v032", },
>     { .compatible = "aptina,mt9v032m", },
>     { .compatible = "aptina,mt9v034", },
>     { .compatible = "aptina,mt9v034m", },

Looks like I forgot to update my patch for mt9v02* support. Sorry about that, 
I'll fix it. And the "aptina," prefix of course belongs there.

>     { /* sentinel */ },
> };
> 
> MODULE_DEVICE_TABLE(of, mt9v032_of_match);
> #endi


-- 
Regards,

Laurent Pinchart

