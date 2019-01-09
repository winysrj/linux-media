Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EBACC43612
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12FBF20859
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547057527;
	bh=B3ZQRE0vzPsu3HpmF9S75jYi6+M3LDQWmmULNmut2nQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=uZZafYZdODq/mjfADOiecZ+SqOAQxQMzdNCT9qsv4pKXKl7bmkNpceI7KEd/xPyuK
	 GQao64fpwI2xoi365iW9YF3rVI8uIlKtLD53yMitEIGfx23YTMmxfidnLf42oKDHuE
	 T5W6/4UXXLwctCTqkgWDVyrgxR4E6CCXq6xHkdMc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfAISMB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:12:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfAISMB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 13:12:01 -0500
Received: from earth.universe (dyndsl-095-033-009-186.ewe-ip-backbone.de [95.33.9.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59C8F20859;
        Wed,  9 Jan 2019 18:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547057519;
        bh=B3ZQRE0vzPsu3HpmF9S75jYi6+M3LDQWmmULNmut2nQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1UEkZ9S2dITcPwpWWZT6yzIDcyWLHt27jtDSSZNck+G42R3CMSbWvCTuBKyGSfktL
         Fh5vcRP//Ejh6w3vudxU86cwe682C1OQLIVMH57wQ7l+QjNzuCqphy7UkijSr+6NK3
         4HeDur1nnzbukhFw5sB40SIeqBQ7YQmK2t0+lCRk=
Received: by earth.universe (Postfix, from userid 1000)
        id CBBE43C08E2; Wed,  9 Jan 2019 19:11:56 +0100 (CET)
Date:   Wed, 9 Jan 2019 19:11:56 +0100
From:   Sebastian Reichel <sre@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, linux-bluetooth@vger.kernel.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/14] media: wl128x-radio: move from TI_ST to hci_ll
 driver
Message-ID: <20190109181156.yamhult6bpwkhx74@earth.universe>
References: <20181221011752.25627-1-sre@kernel.org>
 <20181221011752.25627-13-sre@kernel.org>
 <C85D80C9-2B00-4161-B934-9D70E2B173D0@holtmann.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3p5tmadscirikk3y"
Content-Disposition: inline
In-Reply-To: <C85D80C9-2B00-4161-B934-9D70E2B173D0@holtmann.org>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--3p5tmadscirikk3y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marcel,

First of all thanks for your review.

On Sun, Dec 23, 2018 at 04:56:47PM +0100, Marcel Holtmann wrote:
> Hi Sebastian,

[...]

> > +static int ll_register_fm(struct ll_device *lldev)
> > +{
> > +	struct device *dev =3D &lldev->serdev->dev;
> > +	int err;
> > +
> > +	if (!of_device_is_compatible(dev->of_node, "ti,wl1281-st") &&
> > +	    !of_device_is_compatible(dev->of_node, "ti,wl1283-st") &&
> > +	    !of_device_is_compatible(dev->of_node, "ti,wl1285-st"))
> > +		return -ENODEV;
>=20
> do we really want to hardcode this here? Isn't there some HCI
> vendor command or some better DT description that we can use to
> decide when to register this platform device.

I don't know if there is some way to identify the availability
based on some HCI vendor command. The public documentation from
the WiLink chips is pretty bad.

> > +	lldev->fmdev =3D platform_device_register_data(dev, "wl128x-fm",
> > +		PLATFORM_DEVID_AUTO, NULL, 0);
>=20
> Fix the indentation please to following networking coding style.

Ok.

[...]

> > +static int ll_recv_radio(struct hci_dev *hdev, struct sk_buff *skb)
> > +{
> > +	struct hci_uart *hu =3D hci_get_drvdata(hdev);
> > +	struct serdev_device *serdev =3D hu->serdev;
> > +	struct ll_device *lldev =3D serdev_device_get_drvdata(serdev);
> > +
> > +	if (!lldev->fm_handler) {
> > +		kfree_skb(skb);
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* Prepend skb with frame type */
> > +	memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
> > +
> > +	lldev->fm_handler(lldev->fm_drvdata, skb);
>=20
> So I have no idea why we bother adding the frame type here. What
> is the purpose. I think this is useless and we better fix the
> radio driver if that is what is expected.

That should be possible. I will change this before sending another
revision.

> > +	return 0;
> > +}

[...]

> > +int hci_ti_fm_send(struct device *dev, struct sk_buff *skb)
> > +{
> > +	struct serdev_device *serdev =3D to_serdev_device(dev);
> > +	struct ll_device *lldev =3D serdev_device_get_drvdata(serdev);
> > +	struct hci_uart *hu =3D &lldev->hu;
> > +	int ret;
> > +
> > +	hci_skb_pkt_type(skb) =3D HCILL_FM_RADIO;
> > +	ret =3D ll_enqueue_prefixed(hu, skb);
>=20
> This is the same as above, lets have the radio driver not add this
> H:4 protocol type in the first place. It is really pointless that
> this driver tries to hack around it.

Yes, obviously both paths should follow the same logic.

[...]

> > diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
> > index f2293028ab9d..a9de5654b0cd 100644
> > --- a/include/linux/ti_wilink_st.h
> > +++ b/include/linux/ti_wilink_st.h
> > @@ -86,6 +86,8 @@ struct st_proto_s {
> > extern long st_register(struct st_proto_s *);
> > extern long st_unregister(struct st_proto_s *);
> >=20
> > +void hci_ti_set_fm_handler(struct device *dev, void (*recv_handler) (v=
oid *, struct sk_buff *), void *drvdata);
> > +int hci_ti_fm_send(struct device *dev, struct sk_buff *skb);
>=20
> This really needs to be put somewhere else if we are removing the
> TI Wilink driver. This header file has to be removed as well.

That header is already being used by the hci_ll driver (before this
patch) for some packet structures. I removed all WiLink specific
things in the patch removing the TI WiLink driver and kept it
otherwise.

> I wonder really if we are not better having the Bluetooth HCI core
> provide an abstraction for a vendor channel. So that the HCI
> packets actually can flow through HCI monitor and be recorded via
> btmon. This would also mean that the driver could do something
> like hci_vnd_chan_add() and hci_vnd_chan_del() and use a struct
> hci_vnd_chan for callback handler hci_vnd_chan_send() functions.

Was this question directed to me? I trust your decision how this
should be implemented. I'm missing the big picture from other BT
devices ;)

If I understood you correctly the suggestion is, that the TI BT
driver uses hci_recv_frame() for packet type 0x08 (LL_RECV_FM_RADIO).
Then the FM driver can call hci_vnd_chan_add() in its probe function
and hci_vnd_chan_del() in its remove function to register the receive
hook? Also the dump_tx_skb_data()/dump_rx_skb_data() could be
removed, since btmon can be used to see the packets? Sounds very
nice to me.

> On a side note, what is the protocol the TI FM radio is using
> anyway? Is that anywhere documented except the driver itself? Are
> they using HCI commands as well?

AFAIK there is no public documentation for the TI WiLink chips. At
least my only information source are the existing drivers. The
driver protocol can be seen in drivers/media/radio/wl128x/fmdrv_common.h:

struct fm_cmd_msg_hdr {
	__u8 hdr;		/* Logical Channel-8 */
	__u8 len;		/* Number of bytes follows */
	__u8 op;		/* FM Opcode */
	__u8 rd_wr;		/* Read/Write command */
	__u8 dlen;		/* Length of payload */
} __attribute__ ((packed));

struct fm_event_msg_hdr {
	__u8 header;		/* Logical Channel-8 */
	__u8 len;		/* Number of bytes follows */
	__u8 status;		/* Event status */
	__u8 num_fm_hci_cmds;	/* Number of pkts the host allowed to send */
	__u8 op;		/* FM Opcode */
	__u8 rd_wr;		/* Read/Write command */
	__u8 dlen;		/* Length of payload */
} __attribute__ ((packed));

Apart from the Bluetooth and FM part, the chips also support GPS
(packet type 0x9). The GPS feature is not used on Droid 4 stock
rom and seems to carry some TI specific protocol instead of NMEA.
Here is an old submission for this driver:
http://lkml.iu.edu/hypermail/linux/kernel/1005.0/00918.html

(I don't plan to work on the GPS part, but it provides some more
details about the WiLink chips protocol)

-- Sebastian

--3p5tmadscirikk3y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlw2OWkACgkQ2O7X88g7
+poWpBAAl/CofpIfp0Fv/sEJulTAp4GRc9bhb78UhUJvmMZxKQ0TFD3C6aZyVTnU
/QtNymeNQeXibTnHgd+2R34emUuO4eRksWy+DhG5fgFK9vmdeUhiiN705ZHqftX/
U7uPzgVgNJRHjZ3A8SLp0UyP5kbNSANI4suoqGWRCLcwntxoYEwfY6bS/LmN1squ
hc+9OJzRcIP4PkWsXIa6IDskyVwYA07Sh/1CwcTZooMhx7NRfcQTflyWi0b5t6ok
0q6J/2r7ybPqnx3rq4u/PiWLr6j8ReKqJzwDur4R2vp+5vbr+uDDlE+ARJn+2sxS
s6iUw3O6/TPao1DkDVFjXFl1ff203C/62F6+2c2XFVP+vt0hJboQx8m0hMQBXE6/
g8E1i2pGJYzG5epRVktnMwtkVpITY/+/Ay93XbdCy1yLgktZYO42SS9x5qhqAHu5
NoBcH73Lhiyt2J4Po3Og4J7IlETXmAD9lb1tyYoltuLo/XorZ6Cr5U8I42/0Qafx
0mamyoGLsYFCRJS88tzud4ypVhmNyyL+r+9/gBtlKEhDczrgHgN8pvvvO91gyQ0z
4DDf2Z5L431ghIU5KambjAyVHmGZH17Lap2/86DYMLvUPlxXrcV9r0N32TTwMrQN
K4mYRKbAfVm8qgUtYK2lgx1Fu7OmC6BjKHmcIfgQJDX2lTYEeLo=
=kBKw
-----END PGP SIGNATURE-----

--3p5tmadscirikk3y--
