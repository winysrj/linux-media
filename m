Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F53C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 09:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EB8E20859
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 09:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403799AbfAPJKo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 04:10:44 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:37285 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403797AbfAPJKo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 04:10:44 -0500
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id EA8DB100011;
        Wed, 16 Jan 2019 09:10:40 +0000 (UTC)
Date:   Wed, 16 Jan 2019 10:10:49 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v3 3/6] media: adv748x: csi2: Link AFE with TXA and TXB
Message-ID: <20190116091049.v2y4nbvyio5jskgr@uno.localdomain>
References: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
 <20190110140213.5198-4-jacopo+renesas@jmondi.org>
 <20190114145533.GK30160@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f3kepikkxvnokd5s"
Content-Disposition: inline
In-Reply-To: <20190114145533.GK30160@bigcity.dyn.berto.se>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--f3kepikkxvnokd5s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Mon, Jan 14, 2019 at 03:55:33PM +0100, Niklas S=C3=B6derlund wrote:

[snip]

> > +	/* Register link to HDMI for TXA only. */
> > +	if (is_txb(tx) || !is_hdmi_enabled(state))
>
> Small nit, I would s/is_txb(tx)/!is_txa(tx)/ here as to me it becomes
> easier to read. With or without this change,
>
> Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>
>

Would you want me to resend for this or can this series be collected?

Thanks
  j

> > +		return 0;
> > +
> > +	return adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->hdmi.sd,
> > +					  ADV748X_HDMI_SOURCE, true);
> >  }
> >
> >  static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_ops=
 =3D {
> > --
> > 2.20.1
> >
>
> --
> Regards,
> Niklas S=C3=B6derlund

--f3kepikkxvnokd5s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlw+9RkACgkQcjQGjxah
Vjwr6xAAhrXvPUAzLwGQpML3SEMcCSyYKWsztgueOPvOQ4hxpIhQZl6mrAFJ2U8k
ueMblbUVqdLZFfYuihTLHqxTDSQQrrgw6RfVJr4a/33lZa05bqg9QMnHBG0jIhj0
uvpKu1U4RUObCjEroGTptxKrWYV/O6Mx1wmXP4mk33S+Ea0no+5fZKSq/BEcd0a6
Twrnt6+Qo4zTwu/HoR8kG5UMIW/51t7VSn9FnJFuna05Wd1LCVfVD5tfCgKcx7QM
VNI/KDZy2diVsgQugcry3gLDJi8x0Vv09q1tw9N8poBfHdSPTGuyQX4TB1tYOEYD
bVnH29kWmcbWABgHtJNHu2peGwE6D1GT72J18RRhcmb0in+h4Ed64hoJg/nxPcN8
iWtMUIJan6Yji9P/BKIu82pNc/Izgepb3yoGvjjjLDCwyTjg5ukKq300XZgo41Ow
Mbk3RGz7SU3FFvuWe20MpgP2VEh9RbDmFsk/q/9PrwEG9vozyntt9UUdgLOTX1II
rXwlUbfUadoKBPSDdFb3EdquVYIEbNErtRw7gxmQWwEX6i2RnqHxfiVWzeck6Etx
AJm+q5lWcD3jnDjEYefMyrgMiUcDe9zp7mF4nAju6pmTP+6a1bG8bY1T763VuxX2
aoAZDQ6ohqRJun2rO/og0oB/BWxWGTYhrrp4Jk9YnCdq/58UkyE=
=of2L
-----END PGP SIGNATURE-----

--f3kepikkxvnokd5s--
