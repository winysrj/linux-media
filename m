Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:36243 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbeJCXDN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2018 19:03:13 -0400
Date: Wed, 3 Oct 2018 18:14:01 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: ektor5 <ek5.chimenti@gmail.com>
Cc: hverkuil@xs4all.nl, luca.pisani@udoo.org, jose.abreu@synopsys.com,
        sean@mess.org, sakari.ailus@linux.intel.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] media: add SECO cec driver
Message-ID: <20181003161401.GG20786@w540>
References: <cover.1538474121.git.ek5.chimenti@gmail.com>
 <c212cb1142a412f980176b9c86fa7f6c96092cb1.1538474121.git.ek5.chimenti@gmail.com>
 <20181003093532.GF20786@w540>
 <20181003153204.ou3zup3jeoa34vvc@Ettosoft-T55>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IuhbYIxU28t+Kd57"
Content-Disposition: inline
In-Reply-To: <20181003153204.ou3zup3jeoa34vvc@Ettosoft-T55>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--IuhbYIxU28t+Kd57
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello,

On Wed, Oct 03, 2018 at 05:50:04PM +0200, ektor5 wrote:
> Hi Jacopo,
> Thanks for the quick reply, I will respond inline,
>
> On Wed, Oct 03, 2018 at 11:35:32AM +0200, jacopo mondi wrote:
> > Hi Ettore,
> >     thanks for the patch.
> >
> > A few comments below, please have a look...
> >
> > On Tue, Oct 02, 2018 at 06:59:55PM +0200, ektor5 wrote:
> > > From: Ettore Chimenti <ek5.chimenti@gmail.com>
> > > +/* ----------------------------------------------------------------------- */

[snip]

> > > +
> > > +#ifdef CONFIG_PM_SLEEP
> >
> > I see CONFIG_PM_SLEEP is only selected if support for
> > 'suspend'/'hibernate' is enabled. Is this what you want, or you should
> > check for CONFIG_PM?
>
> I was just inspired by the implementation of cros-ec-cec, but I think
> this is right, because the device actually has suspend/hibernate states.
>

Your device maybe does... I feel like CONFIG_PM is the right choice, but
I let others to comment further.

> >
> > > +static int secocec_suspend(struct device *dev)
> > > +{
> > > +	u16 val;
> > > +	int status;
> > > +
> > > +	dev_dbg(dev, "Device going to suspend, disabling");
> > > +
> > > +	/* Clear the status register */
> > > +	status = smb_rd16(SECOCEC_STATUS_REG_1, &val);
> > > +	if (status)
> > > +		goto err;
> > > +
> > > +	status = smb_wr16(SECOCEC_STATUS_REG_1, val);
> > > +	if (status)
> > > +		goto err;
> > > +
> > > +	/* Disable the interrupts */
> > > +	status = smb_rd16(SECOCEC_ENABLE_REG_1, &val);
> > > +	if (status)
> > > +		goto err;
> > > +
> > > +	status = smb_wr16(SECOCEC_ENABLE_REG_1, val &
> > > +			  ~SECOCEC_ENABLE_REG_1_CEC & ~SECOCEC_ENABLE_REG_1_IR);
> > > +	if (status)
> > > +		goto err;
> > > +
> > > +	return 0;
> > > +
> > > +err:
> > > +	dev_err(dev, "Suspend failed (err: %d)", status);
> > > +	return status;
> > > +}
> > > +
> > > +static int secocec_resume(struct device *dev)
> > > +{
> > > +	u16 val;
> > > +	int status;
> > > +
> > > +	dev_dbg(dev, "Resuming device from suspend");
> > > +
> > > +	/* Clear the status register */
> > > +	status = smb_rd16(SECOCEC_STATUS_REG_1, &val);
> > > +	if (status)
> > > +		goto err;
> > > +
> > > +	status = smb_wr16(SECOCEC_STATUS_REG_1, val);
> > > +	if (status)
> > > +		goto err;
> > > +
> > > +	/* Enable the interrupts */
> > > +	status = smb_rd16(SECOCEC_ENABLE_REG_1, &val);
> > > +	if (status)
> > > +		goto err;
> > > +
> > > +	status = smb_wr16(SECOCEC_ENABLE_REG_1, val | SECOCEC_ENABLE_REG_1_CEC);
> > > +	if (status)
> > > +		goto err;
> > > +
> > > +	dev_dbg(dev, "Device resumed from suspend");
> > > +
> > > +	return 0;
> > > +
> > > +err:
> > > +	dev_err(dev, "Resume failed (err: %d)", status);
> > > +	return status;
> > > +}
> > > +
> > > +static SIMPLE_DEV_PM_OPS(secocec_pm_ops, secocec_suspend, secocec_resume);
> > > +#define SECOCEC_PM_OPS (&secocec_pm_ops)
> > > +#else
> > > +#define SECOCEC_PM_OPS NULL
> > > +#endif
> > > +
> > > +#ifdef CONFIG_ACPI
> > > +static const struct acpi_device_id secocec_acpi_match[] = {
> > > +	{"CEC00001", 0},
> > > +	{},
> > > +};
> > > +
> > > +MODULE_DEVICE_TABLE(acpi, secocec_acpi_match);
> > > +#endif
> > > +
> > > +static struct platform_driver secocec_driver = {
> > > +	.driver = {
> > > +		   .name = SECOCEC_DEV_NAME,
> > > +		   .acpi_match_table = ACPI_PTR(secocec_acpi_match),
> > > +		   .pm = SECOCEC_PM_OPS,
> > > +	},
> > > +	.probe = secocec_probe,
> > > +	.remove = secocec_remove,
> > > +};
> >
> > As you can see most of my comments are nits or trivial things. I would
> > wait for more feedbacks on the CEC and x86/SMbus part from others before
> > sending v2 if I were you :)
> >
> > Thanks
> >    j
> >
>
> Many thanks, this is my first patch, so I need plenty of comments. :)
>

I wish my first patches were as good as this one!

Thanks for sharing
    j

--IuhbYIxU28t+Kd57
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbtOrIAAoJEHI0Bo8WoVY8EnAQALOc1HFJBvUw1vTBqkXrLrCr
UpIPttl6tg5m1cDTgwqZuQbn9WfghAyZC2J4uv7y0kBKDIvwzyJBqnws4pE+/Ion
yeyNtBtBBPHVcZpArbGtHDazYygjPR7cWtQo80CIIc6VW8t6xlw2sf7c3xGyPcRf
ADkzZta8mFx0supTVPD+x8GxQWcc8RdzMbCSN5IVXiHrZ0TG3lgXqolldTOJANjB
B2KxvnMXyR3vTcuky+bRl53gYzol6rbpiSLN6UjVZLEiC3KpSU/3l1ejvgCRdozn
6M3S8vDgZUG2b5tVpunHqZzdRWfrD7tsXYPgVo5kuAduBp8VUgRHPWECPRAZgjF7
bOjxWjSxFnsh6wBgnS9+7CLcsiWLMh9kl2d9T8ZnysVJo0F+akSJ3fdqypcHMUni
JUSjS3QDIiePDWKldjRj49n7ATQ/axbYrNAsIn2T2FXIMj5n6ic+HR0h0ub56wer
UEVLqshkzMyXrwEUm0IUnjQNe2PdhxMQuRm5285Y1XRNhxgVZlEoRRZ6Mr9cjGDG
AvPdrooqNeU6fK3tPNb3GipozYEqMJaLpbK/EAINw5aZy1YW+N8GQ//IuqzmBCOp
l27typ3W3znKo4izmZHfj5DJDHsBZu3QGejlJxGl4lTaiov985LEBj9KJwOiDitc
f426eZd3u0O89DGIGXRK
=D8Pj
-----END PGP SIGNATURE-----

--IuhbYIxU28t+Kd57--
