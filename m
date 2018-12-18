Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D65C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 21:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02FED218A2
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 21:33:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M5jopNzI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbeLRVdB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 16:33:01 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51886 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbeLRVdB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 16:33:01 -0500
Received: by mail-wm1-f67.google.com with SMTP id b11so4040143wmj.1;
        Tue, 18 Dec 2018 13:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r/WxdEtA0ibJmaswU4jbcvWJX86nWcFi0qw8PFD4Q+Q=;
        b=M5jopNzIcgqJKe5VflXDLRWxTNY7S9JCwFdR8VIhn6zzyMJgacJc2MrlsKw7eSfKQL
         TymtSisiumgoZASoljdFAhN3yD7jgnr58TxgT75v19JkH1wbmAzoXhCFZ2no6Chbkk50
         2m5F3UxJvH+65ObzrfzdibQN6He6EopWqQXxA3rceyI/YO8wKAdQBKYf+YtZCYiRlBaE
         lrO6hZTGdw/FIfQiUciPS6aYC+0WslbkS5C1xolQGaU66cpFAcoDNp9BTjTW7jGTvApJ
         j8UmXtqQc3w+ytNLH3pWU5ljNFokADpYx41kSRVmWOzIAS62yOn1wO2O1f4GDlceCCa1
         KvRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=r/WxdEtA0ibJmaswU4jbcvWJX86nWcFi0qw8PFD4Q+Q=;
        b=shWyUqQ0lMHYTvQM43RwcpWpadJPxVrxaBpuAR3k/99MfLbMjoddRej6h+gvqKyAW2
         v+HaMN0clqoXOrwQn8pjlH+SOwvtEdaxjwBPNM/W4jcoykcT5QxCev4deXt26cyz3vhU
         aL8TDVgMvzCBoMi+WksAkxlarZNy0tUz8epzAUS97vYluCnfcpNKFYMxNYXAfV4jVBx8
         w3ZQyvTxnqMyudrvZ8B6w3MvtKGmfbSPEAWu6ozv61Brs4EyJPd1Woczws4pkYfA41Yp
         g2rCWSDpCXlVOLlvQBfDwan4RCs3IlFI5s34NSeq5ilGRdQ7MJXBvStc7eluB4Vy/hyD
         VpdA==
X-Gm-Message-State: AA+aEWaJQ75zKDjxqiaLe5zNrskmuVhx7ymtlYgt3fS9nZrOrNalDq84
        dThx7dMdv/Ejv+vDLZeuKWp4d7gM
X-Google-Smtp-Source: AFSGD/VUuANjNswzwFIsBz1HCL0gt1VXOw2L8ogL3JUbfbt7FBOgbAlYxlHXjIrKsLSExbgIEa5dPw==
X-Received: by 2002:a1c:cf82:: with SMTP id f124mr4811426wmg.95.1545168778109;
        Tue, 18 Dec 2018 13:32:58 -0800 (PST)
Received: from localhost (p200300E41F128C00021F3CFFFE37B91B.dip0.t-ipconnect.de. [2003:e4:1f12:8c00:21f:3cff:fe37:b91b])
        by smtp.gmail.com with ESMTPSA id l37sm6613459wre.69.2018.12.18.13.32.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Dec 2018 13:32:57 -0800 (PST)
Date:   Tue, 18 Dec 2018 22:32:56 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 1/3] dt-bindings: media: tegra-cec: Document Tegra186
 and Tegra194
Message-ID: <20181218213255.GA4227@mithrandir>
References: <20181211094841.16027-1-thierry.reding@gmail.com>
 <20181218164230.GA18480@bogus>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20181218164230.GA18480@bogus>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 18, 2018 at 10:42:30AM -0600, Rob Herring wrote:
> On Tue, Dec 11, 2018 at 10:48:39AM +0100, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > The Tegra186 and Tegra194 contain a CEC controller that is identical to
> > that found in earlier generations. Document the compatible strings for
> > these newer chips.
>=20
> If identical, why don't you have a fallback compatible?

That's a good point. I think it would be fine to always fall back to the
nvidia,tegra20-cec compatible.

Thierry

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlwZZ4QACgkQ3SOs138+
s6Gwdg/+MrBxsR3iE+f5eAzdUfDoEeBN5qmqJwFTVfGbgcixVe7rNbD+DtjTeKl3
72ocbucBfPpGNg9LNjJu1Oz0MODUzg6kq8/zUeub0T67xHkEUzh62Qu4WIDEo0YT
gaDUCleglmcACskmIEbjfO1lFqT3XfgDWriaPRsbE/ZfkX19hrZQvOEnMdaBRJ89
1WfIcZ0/0iTDjdeOfTqkIz905p6yC3wFbzXLZlRgI9O+7mjp3W3S9ZWrP5nGb2Z+
aFQ10Dm4S2wJ27TeFN+Wr3Lcz/QO7O2iZtwG5abHH62c8fyF0soJDjWnM3cwN0Gy
xlMqdLPn2cZfsQW9EGrnTtlnsjo6v+jOeophcC4QSZcGHWHA3KaNLEul654fYT8e
4dkhA062CEsJ7vu6HbkVMbzhdxBwDXgAHxqGZWW0jHAmfAF0zaKNpYkp5eDePHyh
wQA/SgzRNzR8D/V2lb8PkJG+FsDA41SbSf2Vtad62Qb5VzAHD+nfo0M2ObAn8M1c
KyHCGC+AvS8zOjafA/Ky8RYtAa69CqjpC2vt68UItxQIJg54+kYUXNNrDkLF3Rgh
rKsu4IbxXp1YOkKYFHYjjiH5pGhyT5smnjDdcxBBK5XVMMVVhbo4I2i2gHEtBpjM
lVOcMLXils+iO+aNg50I38IFGSl7GXQBrZDh2EYg6nKfIJu7pQc=
=KsX4
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
