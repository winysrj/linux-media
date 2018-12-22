Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF748C43444
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 19:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD7BB21970
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 19:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404272AbeLVTaq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 14:30:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37897 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730700AbeLVTaq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 14:30:46 -0500
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 0E92380A5F; Sat, 22 Dec 2018 20:30:39 +0100 (CET)
Date:   Sat, 22 Dec 2018 20:30:43 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sebastian Reichel <sre@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-bluetooth@vger.kernel.org, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: Re: [PATCH 11/14] media: wl128x-radio: fix skb debug printing
Message-ID: <20181222193043.GB15237@amd>
References: <20181221011752.25627-1-sre@kernel.org>
 <20181221011752.25627-12-sre@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <20181221011752.25627-12-sre@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2018-12-21 02:17:49, Sebastian Reichel wrote:
> From: Sebastian Reichel <sebastian.reichel@collabora.com>
>=20
> This fixes incorrect code in the TX/RX skb debug print
> function and add stubs in receive/transmit packet path.
>=20
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>

Acked-by: Pavel Machek <pavel@ucw.cz>


> @@ -228,7 +228,7 @@ inline void dump_rx_skb_data(struct sk_buff *skb)
> =20
>  	evt_hdr =3D (struct fm_event_msg_hdr *)skb->data;
>  	printk(KERN_INFO ">> hdr:%02x len:%02x sts:%02x numhci:%02x opcode:%02x=
 type:%s dlen:%02x",
> -	       evt_hdr->hdr, evt_hdr->len,
> +	       evt_hdr->header, evt_hdr->len,
>  	       evt_hdr->status, evt_hdr->num_fm_hci_cmds, evt_hdr->op,
>  	       (evt_hdr->rd_wr) ? "RD" : "WR", evt_hdr->dlen);

Would conversion to dev_info() make sense?

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlwekOMACgkQMOfwapXb+vIKIwCgrEkbjy5t+tLiU373RR0newf3
BH0An1W/Dah7XYAutH/TzzwChhwRkz44
=xgD7
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--
