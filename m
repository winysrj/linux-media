Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D5EC5CFFE
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 20:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFDD72086D
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 20:59:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pv8aGKQo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFDD72086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbeLJU7v (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 15:59:51 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]:35505 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727538AbeLJU7u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 15:59:50 -0500
Received: by mail-wm1-f42.google.com with SMTP id c126so89431wmh.0;
        Mon, 10 Dec 2018 12:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a6NqEYig4WPA9rpHhhnygfYhMLCkGfqCnnSuBwpTs/U=;
        b=Pv8aGKQofnP0GNnA3hO3ioHWwL6Zf4r0qH+9AUivELeDKMklJ2FWIJ7HuqFk2sg2Fa
         82it/Ywwl3NPs9+dJLuvLMQ8rQo2nvWkzr3l+5mnA4eY/Qo1jq3DyE1V2n2QkaP8TUJ7
         pz5dYGxYVKfDm0Z027ZRxZgDFmStvq0ZaCfEorT1MTyjM0sZe9voDmd+G0ZOcATUlPRU
         ejI+3AsEN8E7+k0v2rzlfwwek+4Uu09lCAIurBXcXlJkfhBgSU3QjQXjRZGEbTide50B
         euf9qfWc5lV51GDyb6stxxDW2yYLxrv3+isBT2sZ1/UTTb8Ozppao7gjBfVztkdisMJ4
         enww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=a6NqEYig4WPA9rpHhhnygfYhMLCkGfqCnnSuBwpTs/U=;
        b=RKXFQFoRzYW+aFgibqxfLoxbjIt3iqxmvrxUNjdV8cKB8KnP7EHzrWk/hHUZlbHylW
         YD0BdR0jqcFj5uKEfoaYrUXWWhmIAiDOVSW0CqvrxnWy3y6WWZESTdUeDv47zbqvwk+M
         PsEK7PYHrJ1ArSZ3/2tk1SGrhXwm5SMZWlQXzb9jokUht5oII+O12SBs+7nX0R+fsu+n
         Tyaoq6B+pMtp+k98gD4m7gKLXJ1+9BQhjFrHTDbLEVhF7z6CrII7sxzX2i7ArJwcJRD/
         i31d84JRh1fQwJjL6ERmlzBUr69wYSGJ9Yw3g2iOEtJ98YpOztpb2ApMjiWX6QIgObN2
         d33Q==
X-Gm-Message-State: AA+aEWYnWAqWS1d7j1xUg/HtbY0kjsXwLmzjUGLIBeILE8wWhn7sgkgo
        Sr3UzPb7ZQBtIVQIICZ19/8=
X-Google-Smtp-Source: AFSGD/WXXxaoevL6LRKmJq0PxDsgwRGFe9OG8zhC4jP3ei9sYrOY1evVW6UgW9YlhUq4HD3yG4gBzA==
X-Received: by 2002:a1c:1688:: with SMTP id 130mr11427667wmw.86.1544475588023;
        Mon, 10 Dec 2018 12:59:48 -0800 (PST)
Received: from localhost (p200300E41F128C00021F3CFFFE37B91B.dip0.t-ipconnect.de. [2003:e4:1f12:8c00:21f:3cff:fe37:b91b])
        by smtp.gmail.com with ESMTPSA id n6sm105206wmk.9.2018.12.10.12.59.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Dec 2018 12:59:47 -0800 (PST)
Date:   Mon, 10 Dec 2018 21:59:46 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] media: tegra-cec: Support Tegra186 and Tegra194
Message-ID: <20181210205945.GB325@mithrandir>
References: <20181210160038.16122-1-thierry.reding@gmail.com>
 <643e8da6-a8ed-145a-604d-f028e501add9@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Content-Disposition: inline
In-Reply-To: <643e8da6-a8ed-145a-604d-f028e501add9@xs4all.nl>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 10, 2018 at 06:07:10PM +0100, Hans Verkuil wrote:
> Hi Thierry,
>=20
> On 12/10/18 5:00 PM, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > The CEC controller found on Tegra186 and Tegra194 is the same as on
> > earlier generations.
>=20
> Well... at least for the Tegra186 there is a problem that needs to be add=
ressed first.
> No idea if this was solved for the Tegra194, it might be present there as=
 well.
>=20
> The Tegra186 hardware connected the CEC lines of both HDMI outputs togeth=
er. This is
> a HW bug, and it means that only one of the two HDMI outputs can use the =
CEC block.

I don't know where you got that information from, but I can't find any
indication of that in the documentation. My understanding is that there
is a single CEC block that is completely independent and it is merely a
decision of the board designer where to connect it. I'm not aware of any
boards that expose more than a single CEC.

You may already have access to the schematics, if not you can download
them here:

	https://developer.nvidia.com/embedded/dlc/jetson-tx1-tx2-developer-kit-car=
rier-board-c02-design-files

It's slightly annoying because it requires registration. But in those
schematics you'll see that the HDMI_CEC pin is just routed directly from
the processor module to the connector on the carrier board via the
connector.

> HDMI inputs CAN share the CEC line, but never outputs. There should have =
been two
> CEC blocks, one for each HDMI output.

Like I said, I don't think these are shared. The board design will have
to choose which connector gets the SOR and CEC pins for HDMI. Typically
the other SOR will be used for DisplayPort, not HDMI, though that would
technically be possible. I think in case where there really were two
HDMI connectors on a design, a decision would have to be made as to
which one gets the CEC pin.

> It should not be possible to use the same CEC block for both HDMI
> outputs on the 186. Ideally it should be a required dts property that
> determines this. I'm not sure where that should happen. One option
> might be to use the cec_notifier_get_conn() function so you can
> register the CEC adapter for a specific connector only. For older
> tegra versions the connector name would be NULL (i.e. don't care), for
> the 186 (and perhaps 194) it would be a required property that tells
> the CEC driver which connector it is associated with.
>=20
> Just a suggestion, there might be other ways to implement this as well.

Given the documentation that I have, I don't think we need to take any
additional precautions. We just to hook up the CEC controller to the
correct HDMI connector via the hdmi-phandle property.

> So before I can merge this I need to know first how you plan to handle
> this HW bug.

I don't think this is an actual bug. It's more of a restriction of the
SoC that allows only a single HDMI connector with CEC support.

Thierry

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlwO07wACgkQ3SOs138+
s6GCyxAApgW3GaBqWu8jHX+Nx7T2s8A8WHg9mbcoqBUxIe3wLDwPt8glFbOR6xQ3
3T5J75EquiXvjkNg7rsaHqrZKEo5kIth1cVrhPbJgOkP5OIwQreZleJ1YKjciY7Z
dfcmfdf30VJDkIZfqrJsdZ0qRqe9EmVq3sC21sw6chaZiFMZiHT2uS19FE59TAJ3
9zo3TnVMJMjzeIvpIZL5bf3QF87dSWB3iucL2kjBVNX7RWKj5X6cigzO/kxXbpMv
5b0kkARI5oP2OsQI9m+YHLWjvvWG8MpUdw0CDnj+s3wFW/P4JfR1nfyCcqrx4WXb
L2GY/R9QskhGQnDlwVZU/KKINPK8+0XKTUcUBJtweUGIdAjQINE4k0/njAax8T11
jhDTnkAv9+/nodPUA1YYvn8SCWDJ2mQLTIh52hzb4twyKUWIV5+6908WyHlyEU57
kT/ncKQR3bBjD2fWjczhfmR8AxBJtqaG3ecARmeKiAN8oy3OXNZBcG7SxW2mEFrS
8R3YvWFvowRsgKsHJxw/fQu+dUKMJaxFbIp/63QPBWyweZuGzQFfuvyFEr9Jk/eI
KMT2J9mv0QGKeeFKvgR4ZlPs3hJtFu0oULaHsu6NNBjYgEPTEu1vyt5RObdShqBF
0ZUNkvPZ3Nhr6aY1CcYe1hw/+Obv++G9v3kgV9p23EEpxaBAk6c=
=l39o
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
