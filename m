Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CD8C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 13:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A15C12083D
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 13:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553002324;
	bh=00f92TBP02CkJzEsfgi5CmTWd49OFGx2hMC1U15IiTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=kNmtY6SJsdhHLKNEhDsdmc4OUBrEMwGYjxMITzliVaVMzkeNObBL5rYA+fmThvzfE
	 oPQ7QiEOy7moe0vWzKCmkEsCpua/4TCSxsBcSbQaIqpU/O+jlnpe55gklSjvIxYeXZ
	 6kq3M/LwTToThdSnyaA+G0JwyzqfmelbwptkG8Ts=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbfCSNb7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 09:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726876AbfCSNb7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 09:31:59 -0400
Received: from earth.universe (dyndsl-091-096-044-185.ewe-ip-backbone.de [91.96.44.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1DBA2083D;
        Tue, 19 Mar 2019 13:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553002318;
        bh=00f92TBP02CkJzEsfgi5CmTWd49OFGx2hMC1U15IiTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SdgWxAl7L8PFrQWFiGgsNPDR9mgXfa/e0TZoL0BrKgmXyn0TK6ulCNE6H33vhy+eF
         yoJn5d41cVXLVj645syk1UtAQaOkRhxggnjq7AOYnTmZTbpELpdN2cHDF/GrHEEmcY
         +OVt7jBkCnrkUcQ8vmc6JKYz7pPoav+BmJPE0D2A=
Received: by earth.universe (Postfix, from userid 1000)
        id 16D5C3C086A; Tue, 19 Mar 2019 14:31:55 +0100 (CET)
Date:   Tue, 19 Mar 2019 14:31:55 +0100
From:   Sebastian Reichel <sre@kernel.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, linux-bluetooth@vger.kernel.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] Add support for FM radio in hcill and kill TI_ST
Message-ID: <20190319133154.7tbfafy7pguzw2tk@earth.universe>
References: <20181221011752.25627-1-sre@kernel.org>
 <4f47f7f2-3abb-856c-4db5-675caf8057c7@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="62zbunq3ffyszqqd"
Content-Disposition: inline
In-Reply-To: <4f47f7f2-3abb-856c-4db5-675caf8057c7@xs4all.nl>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--62zbunq3ffyszqqd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On Thu, Mar 14, 2019 at 09:20:10AM +0100, Hans Verkuil wrote:
> On 12/21/18 2:17 AM, Sebastian Reichel wrote:
> > This moves all remaining users of the legacy TI_ST driver to hcill (pat=
ches
> > 1-3). Then patches 4-7 convert wl128x-radio driver to a standard platfo=
rm
> > device driver with support for multiple instances. Patch 7 will result =
in
> > (userless) TI_ST driver no longer supporting radio at runtime. Patch 8-=
11 do
> > some cleanups in the wl128x-radio driver. Finally patch 12 removes the =
TI_ST
> > specific parts from wl128x-radio and adds the required infrastructure t=
o use it
> > with the serdev hcill driver instead. The remaining patches 13 and 14 r=
emove
> > the old TI_ST code.
> >=20
> > The new code has been tested on the Motorola Droid 4. For testing the a=
udio
> > should be configured to route Ext to Speaker or Headphone. Then you nee=
d to
> > plug headphone, since its cable is used as antenna. For testing there i=
s a
> > 'radio' utility packages in Debian. When you start the utility you need=
 to
> > specify a frequency, since initial get_frequency returns an error:
>=20
> What is the status of this series?
>
> Based on some of the replies (from Adam Ford in particular) it appears th=
at
> this isn't ready to be merged, so is a v2 planned?

Yes, a v2 is planned, but I'm super busy at the moment. I don't
expect to send something for this merge window. Neither LogicPD
nor IGEP use FM radio, so I can just remove FM support from the
TI_ST framework. Converting those platforms to hci_ll can be done
in a different patchset.

If that was the only issue there would be a v2 already. But Marcel
Holtmann suggested to pass the custom packet data through the BT
subsystem, which is non-trivial (at least for me) :)

-- Sebastian

--62zbunq3ffyszqqd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlyQ70QACgkQ2O7X88g7
+prWdA//Vy7zc3RwtOPcf8fnZpZi5XJmJWA/+h15XD1lwsVp6xBaiIgxbY9/VLjy
7k4qGuFaGVP73+QBEVgPSZKXKAqIAu4ZKTnjbrpOQIO7TPcffKWHjz9Hjy9Uh48T
w6Q+wckAzamw93W2Uq6MITl7yIdUTLvk698fWZe/iD96jL7SORvbyLpWwpQztH/J
z1iYvIzafWUr+VkjmqaSteTwl0gC+L7prdyk4DQHWLtn4Ty5AwgsYkvfqaXju0vm
gW73gYoFvtFJN1uOf349P20mNYbkCi25llV9tbx1FmfKbwHVLWLGWy35+yVG9sUt
/NjzFQDJrFjvuGtVkAIQJH7yX3WlMjl6tce4xqiuKcuXp12AJMOrt9nrku8sxc8I
wuU7F+R9l8yb7jHdWkYYQZcyU31szc9XfmcEyEBPgI2o++i0K4/BDB6rw2dtq9N4
aM9omX45PZirFKW91zAy85soHpBINWI/pYbS3d2tNeRUnxpzOqnbSmgZvYmgj1T1
Qy5zWEK4Db4gy27znrGfGlC6D+bPA1SJ063ZBfugv49Il5NpBRBV7bnan0rDO5+Z
mZURZio8SIX3CY1YnIK694LqOG1adtZns6ioUuA5tPK+T8NkiWHyRA4uHQ4IRFbA
HVxGiuwsqS5eWwuSJEP8A5mTqT2co8Ez4Y6mBtC2Pdzwt6V5RE0=
=iW+w
-----END PGP SIGNATURE-----

--62zbunq3ffyszqqd--
