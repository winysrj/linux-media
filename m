Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940DFC10F03
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 10:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C4BF20675
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 10:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfCGKen (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 05:34:43 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:49413 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfCGKen (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 05:34:43 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id A6DE0E000A;
        Thu,  7 Mar 2019 10:34:38 +0000 (UTC)
Date:   Thu, 7 Mar 2019 11:35:11 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: adv748x: Don't disable CSI-2 on link_setup
Message-ID: <20190307103511.wtx2c7jecyx4nmms@uno.localdomain>
References: <20190306112659.8310-1-jacopo+renesas@jmondi.org>
 <20190306191521.GE4791@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dbljmjvrm663efkh"
Content-Disposition: inline
In-Reply-To: <20190306191521.GE4791@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--dbljmjvrm663efkh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Laurent,

On Wed, Mar 06, 2019 at 09:15:21PM +0200, Laurent Pinchart wrote:
> Hi Jacopo,
>
> On Wed, Mar 06, 2019 at 12:26:59PM +0100, Jacopo Mondi wrote:
> > When both the media links between AFE and HDMI and the two TX CSI-2 outputs
> > gets disabled, the routing register ADV748X_IO_10 gets zeroed causing both
> > TXA and TXB output to get disabled.
> >
> > This causes some HDMI transmitters to stop working after both AFE and
> > HDMI links are disabled.
>
> Could you elaborate on why this would be the case ? By HDMI transmitter,
> I assume you mean the device connected to the HDMI input of the ADV748x.
> Why makes it fail (and how ?) when the TXA and TXB are both disabled ?
>

I know, it's weird, the HDMI transmitter is connected to the HDMI
input of adv748x and should not be bothered by CSI-2 outputs
enablement/disablement.

BUT, when I developed the initial adv748x AFE->TXA patches I was
testing HDMI capture using a laptop, and things were smooth.

I recently started using a chrome cast device I found in some drawer
to test HDMI, as with it I don't need to go through xrandr as I had to
do when using a laptop for testing, but it seems the two behaves differently.

Failures are of different types: from detecting a non-realisting
resolution from the HDMI subdevice, and then messing up the pipeline
configuration, to capture operations apparently completing properly
but resulting in mangled images.

Do not deactivate the CSI-2 ouputs seems to fix the issue for the
Chromecast, and still work when capturing from laptop. There might be
something I am missing about HDMI maybe, but the patch not just fixes
the issue for me, but it might make sense on its own as disabling the
TXes might trigger some internal power saving state, or simply mess up
the HDMI link.

As disabling both TXes usually happens at media link reset time, just
before enabling one of them (or both), going through a full disable
makes little sense, even more if it triggers any sort of malfunctioning.

Does this make sense to you?

Thanks
  j

> > Fix this by preventing writing 0 to
> > ADV748X_IO_10 register, which gets only updated when links are enabled
> > again.
> >
> > Fixes: 9423ca350df7 ("media: adv748x: Implement TX link_setup callback")
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> > The issue presents itself only on some HDMI transmitters, and went unnoticed
> > during the development of:
> > "[PATCH v3 0/6] media: adv748x: Implement dynamic routing support"
> >
> > Patch intended to be applied on top of latest media-master, where the
> > "[PATCH v3 0/6] media: adv748x: Implement dynamic routing support"
> > series is applied.
> >
> > The patch reports a "Fixes" tag, but should actually be merged with the above
> > mentioned series.
> >
> > ---
> >  drivers/media/i2c/adv748x/adv748x-core.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> > index f57cd77a32fa..0e5a75eb6d75 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > @@ -354,6 +354,9 @@ static int adv748x_link_setup(struct media_entity *entity,
> >
> >  	tx->src = enable ? rsd : NULL;
> >
> > +	if (!enable)
> > +		return 0;
> > +
> >  	if (state->afe.tx) {
> >  		/* AFE Requires TXA enabled, even when output to TXB */
> >  		io10 |= ADV748X_IO_10_CSI4_EN;
>
> --
> Regards,
>
> Laurent Pinchart

--dbljmjvrm663efkh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyA898ACgkQcjQGjxah
VjzeTw/9F8ERIavl+o/0zosz415qglosimgNaaLyMIr/lP9gtKCEcL+BmqC4E+qU
z1d17ml03BJe9DiSDagt1d6fxwRYg1invqSvHOvW1wXQ2zrfZL2TrtRP9TH4n8Zw
PH2TrLENyfMzEMODHqQW0IlllR3j2/5bnMNMdoPnVpMGRM5C/AU4lwqVBVLQ8Vxw
buOCClXxg9icdoLWAvSFl1f9fGs4EN6PsZF63xXE8fn66lwTQ6ytsn5urkCt1qSd
PncNCX6CdLgP3zKKC8uaN2BNKAfWb4PLlptLzIKEMYw7imRYPXJ3aCH6lTsfapEJ
7GEG0ncUHC/ibeiqy9NxaW/xS2hV+tm9hNfd4zbBH+W4MWYKjXcO+i8lmnl2qJ1c
OjKrYvf/qlfiSiI/LMwZpocxUV+VFlTKGMvBvftzBD4+t7Bb8wcsHdj2OzpDGRJr
pubtbgEJ2Vo8Pr9+i6xdj+GIFmBbVIM2mIKYyHyk4rOvK+vLc8dOZ0XldAWIoWqk
wKpt1tKJVXooMes5aDnkpYyRb8JtUMhqc+zGXwLTsFCvp3Ln9syTD8xtyiNzIWig
hYq3R+wRnWnECGSqaP9uw8MSycQu7xSKpGLEI2SH9D4oc/XdtBt0dim4SxqM549d
pRCQ3BiHz76bAYoshFfwX3ZYppg66xYz8XvsVBTVjlHx2/8dS4M=
=maI+
-----END PGP SIGNATURE-----

--dbljmjvrm663efkh--
