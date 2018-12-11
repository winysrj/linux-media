Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A63C07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 10:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E82442082F
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 10:00:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JzF91cqQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E82442082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbeLKKAh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 05:00:37 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40621 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbeLKKAh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 05:00:37 -0500
Received: by mail-ed1-f67.google.com with SMTP id d3so11986605edx.7;
        Tue, 11 Dec 2018 02:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y6/qDhGfvT5lMP37+/X+xfSmpgUWiJ+iYZ49yOxDzvM=;
        b=JzF91cqQ8WnCsZ5HpVnWrIoMHLucCz8xvISNb0SPA49irJFarPIQC0AA0Ex9DPZcH8
         sIbruF3POr0ThoiyKHbbcvvkVINdoAlsn3QExIomf1p7VSwno/WMqHMksDBH6yyaq7be
         2kVf6NvUjl+4qmzaJ+vOaOTJhkvTEDunGEbVLZogJorQlwx4P5L/kr4BUqADPMEQqI7x
         fENkcv6E5o6KXclJEpQbdN53v1S03nNdSpoOaCtaN1Tbsjbv3lZDkNVYfj5DLsvEivhQ
         ktZzkcU4BciW7PnscfPgJcxBLqEj4cp9afXNkHgCYBm/JKvUtm1exO6SI+DANc8lAUvA
         ETOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y6/qDhGfvT5lMP37+/X+xfSmpgUWiJ+iYZ49yOxDzvM=;
        b=D0QFUAhJg2yKYSk4dgr+euBWV8uu4f++3V868/G9oj0cAmEqA/llfLm+lHE7gF1aJu
         b+1A62jMWfV5XB3AyXjbxCn39GW435gIL1dxv3JAlx8f5Y5XWvU2cshef0/uw62wbpQc
         3qqFpMBNdWjOd6Of1aAwBQctM45GK1er2osQksHIj8ZERH7y+KP3hr9X7zWqRXGftY/D
         IGXK8t29B2VLkhGqyMV+PhPG9YGBcKHxnaggriL6KW5uRq6lbQV1Crgeylr0PFAuOUeL
         INsxhNp3KtvAdSyC6Zo3VMl9iOpgj1NvyakE8G/toQ6+eBo7rB37KciKU5V5rdkph0Jd
         YhTg==
X-Gm-Message-State: AA+aEWb3IcTVpwUMaTADQf4vVMtZR3xs/aKoUVIk4qZLzRqAZqjw/VV8
        tBABmPWO2RUwDJHtMtYLwhI=
X-Google-Smtp-Source: AFSGD/XwK00nk3KlFEq6mGMdVbMGmDLm+Cu2T+h8UKMzCEqWYtu+Jkwa9OTo+sdEK3yX3LQdYbNiCA==
X-Received: by 2002:a17:906:6b99:: with SMTP id l25-v6mr11808650ejr.154.1544522434460;
        Tue, 11 Dec 2018 02:00:34 -0800 (PST)
Received: from localhost (pD9E51040.dip0.t-ipconnect.de. [217.229.16.64])
        by smtp.gmail.com with ESMTPSA id c38sm3914634edb.15.2018.12.11.02.00.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Dec 2018 02:00:33 -0800 (PST)
Date:   Tue, 11 Dec 2018 11:00:32 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] media: tegra-cec: Support Tegra186 and Tegra194
Message-ID: <20181211100032.GC14426@ulmo>
References: <20181210160038.16122-1-thierry.reding@gmail.com>
 <643e8da6-a8ed-145a-604d-f028e501add9@xs4all.nl>
 <20181210205945.GB325@mithrandir>
 <96df2b5f-e388-b933-8823-c718290bd5e3@xs4all.nl>
 <20181211093807.GA14426@ulmo>
 <26035940-2364-1fa0-68ab-8b9327705eb4@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ctP54qlpMx3WjD+/"
Content-Disposition: inline
In-Reply-To: <26035940-2364-1fa0-68ab-8b9327705eb4@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--ctP54qlpMx3WjD+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 11, 2018 at 10:40:55AM +0100, Hans Verkuil wrote:
> (Resend, this time with a proper reply)
>=20
> On 12/11/18 10:38 AM, Thierry Reding wrote:
> > On Tue, Dec 11, 2018 at 10:19:48AM +0100, Hans Verkuil wrote:
> >> On 12/10/18 9:59 PM, Thierry Reding wrote:
> >>> On Mon, Dec 10, 2018 at 06:07:10PM +0100, Hans Verkuil wrote:
> >>>> Hi Thierry,
> >>>>
> >>>> On 12/10/18 5:00 PM, Thierry Reding wrote:
> >>>>> From: Thierry Reding <treding@nvidia.com>
> >>>>>
> >>>>> The CEC controller found on Tegra186 and Tegra194 is the same as on
> >>>>> earlier generations.
> >>>>
> >>>> Well... at least for the Tegra186 there is a problem that needs to b=
e addressed first.
> >>>> No idea if this was solved for the Tegra194, it might be present the=
re as well.
> >>>>
> >>>> The Tegra186 hardware connected the CEC lines of both HDMI outputs t=
ogether. This is
> >>>> a HW bug, and it means that only one of the two HDMI outputs can use=
 the CEC block.
> >>>
> >>> I don't know where you got that information from, but I can't find any
> >>> indication of that in the documentation. My understanding is that the=
re
> >>> is a single CEC block that is completely independent and it is merely=
 a
> >>> decision of the board designer where to connect it. I'm not aware of =
any
> >>> boards that expose more than a single CEC.
> >>
> >> Sorry, my memory was not completely correct.
> >>
> >> The problem is that the 186 can be configured with two HDMI outputs, b=
ut it has
> >> only one CEC block. So CEC can be used for only one of the two. I chec=
ked the TRM
> >> for the Tegra194 and that has up to four HDMI outputs, but still only =
one CEC
> >> block.
> >>
> >> And yes, it is the responsibility for the board designer to hook up th=
e CEC pin
> >> to only one of the outputs, but the TRM never explicitly mentions this=
 and given
> >> the general lack of knowledge about CEC it wouldn't surprise me at all=
 if there
> >> will be wrong board designs.
> >>
> >> But be that as it may, the core problem remains: you cannot allow mult=
iple
> >> HDMI outputs to be connected to the same CEC device.
> >>
> >> However, I now realize that your patches will actually work fine since=
 each
> >> HDMI connector tries to get a cec notifier for its own HDMI device, bu=
t the
> >> tegra-cec driver will only register a notifier for the HDMI device poi=
nted
> >> to by the hdmi-phandle property. So only one of the HDMI devices will =
actually
> >> get a working CEC.
> >>
> >> Although if board designers mess this up and connect multiple CEC line=
s to
> >> the same CEC pin, this would still break, but there is nothing that ca=
n be
> >> done about that. I still believe the TRM should have made this clear s=
ince
> >> it is not obvious. Even better would be to have the same number of CEC=
 blocks
> >> as there are configurable HDMI outputs. Typically, if you support CEC =
on one
> >> HDMI output, you want to support it for all. And today that's not poss=
ible
> >> without adding external CEC devices (as we - Cisco - do).
> >=20
> > I wasn't aware that anyone was using a Tegra with support for multiple
> > HDMI outputs. Do you have a contact that you can forward this kind of
> > request to? It certainly sounds like something that would be useful to
> > add in future chips if there's a customer need.
>=20
> We have contacts, and we did report it, but nothing happened with it
> AFAIK. It was likely too late for changes to the Tegra194 design in any
> case.

Okay. I'll follow up internally, see if I can find out what the story
is.

Thanks,
Thierry

--ctP54qlpMx3WjD+/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlwPir0ACgkQ3SOs138+
s6Eb/g//fin1xx2r38D362b4TPSI26oMg8jSfOlgz/Cz7sk+LPKcrBFjNkyZ5ziR
oq/SC2Qee5SRbJSzQvvFxG+jx0BNSXRqE/GxOhMP4XVY8xAEgL8/1M31ux92XvgZ
ds6VCe+2/0IfpFpZuNFjfzGnRHCLOHYoohwLqd/ZbA9EZhzEO+HuzR0JH7mr9ZX6
VmGVPINUfIzKt+F++bMi4SmXc7O0uWvGFYQl7HTI3D92VI0mLWU97kiJ4dVFMXJQ
HtcvdW36/VQfCTUCdHTkhXPtUiTsfDpC5AB7hP+8Obu2E7zUacUCXurSkvayjoyI
jW9OM3Ql1KarUhlY9JEITSS7jzcg8PF0tVftYGghoDFBZYpPlzq78G3Q5TC93pp/
jDOkRK68iCGUXkygn1iiyiJ2QwN8uq4gbYc5AM8BvA+OwugoJgn3CdZxI6c6sXhq
Oj4PCPbWY9o1oqVyPbYGrlBQLHelQmRfYq3O/MBKZBZMZvsr+LylbhwgwEQhLp7U
IqVisp+L+vrgvMQAB4aR8dfODay1Wt5lkiLmGPozRG0NJUg/XHJmOJVW9OMzznU9
HMlyTg0wBpUDVjRHKtjGq1xOiGiSHOhxlhLcNghXENc34YHvAgHbzxQBNbsyjpAt
6STCCxqCUDw6nI7lMhB6VMsoexFbBEuq1JthxljHp12viJMi5Y4=
=5z4r
-----END PGP SIGNATURE-----

--ctP54qlpMx3WjD+/--
