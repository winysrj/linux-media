Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:33917 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753790AbdHUUV5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 16:21:57 -0400
Date: Mon, 21 Aug 2017 22:21:45 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benoit Parrot <bparrot@ti.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/3] media: V3s: Add support for Allwinner CSI.
Message-ID: <20170821202145.kmxancepyq55v3o2@flea.lan>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
 <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
 <20170728160233.xooevio4hoqkgfaq@flea.lan>
 <20170730060801.bkc2kvm72ktixy74@tarshish>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="phq7ixndptki6bzi"
Content-Disposition: inline
In-Reply-To: <20170730060801.bkc2kvm72ktixy74@tarshish>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--phq7ixndptki6bzi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Baruch,

On Sun, Jul 30, 2017 at 09:08:01AM +0300, Baruch Siach wrote:
> On Fri, Jul 28, 2017 at 06:02:33PM +0200, Maxime Ripard wrote:
> > Hi,=20
> >=20
> > Thanks for the second iteration!
> >=20
> > On Thu, Jul 27, 2017 at 01:01:35PM +0800, Yong Deng wrote:
> > > Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
> > > and CSI1 is used for parallel interface. This is not documented in
> > > datasheet but by testing and guess.
> > >=20
> > > This patch implement a v4l2 framework driver for it.
> > >=20
> > > Currently, the driver only support the parallel interface. MIPI-CSI2,
> > > ISP's support are not included in this patch.
> > >=20
> > > Signed-off-by: Yong Deng <yong.deng@magewell.com>
>=20
> [...]
>=20
> > > +#ifdef DEBUG
> > > +static void sun6i_csi_dump_regs(struct sun6i_csi_dev *sdev)
> > > +{
> > > +	struct regmap *regmap =3D sdev->regmap;
> > > +	u32 val;
> > > +
> > > +	regmap_read(regmap, CSI_EN_REG, &val);
> > > +	printk("CSI_EN_REG=3D0x%x\n",		val);
> > > +	regmap_read(regmap, CSI_IF_CFG_REG, &val);
> > > +	printk("CSI_IF_CFG_REG=3D0x%x\n",		val);
> > > +	regmap_read(regmap, CSI_CAP_REG, &val);
> > > +	printk("CSI_CAP_REG=3D0x%x\n",		val);
> > > +	regmap_read(regmap, CSI_SYNC_CNT_REG, &val);
> > > +	printk("CSI_SYNC_CNT_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_FIFO_THRS_REG, &val);
> > > +	printk("CSI_FIFO_THRS_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_PTN_LEN_REG, &val);
> > > +	printk("CSI_PTN_LEN_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_PTN_ADDR_REG, &val);
> > > +	printk("CSI_PTN_ADDR_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_VER_REG, &val);
> > > +	printk("CSI_VER_REG=3D0x%x\n",		val);
> > > +	regmap_read(regmap, CSI_CH_CFG_REG, &val);
> > > +	printk("CSI_CH_CFG_REG=3D0x%x\n",		val);
> > > +	regmap_read(regmap, CSI_CH_SCALE_REG, &val);
> > > +	printk("CSI_CH_SCALE_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_CH_F0_BUFA_REG, &val);
> > > +	printk("CSI_CH_F0_BUFA_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_CH_F1_BUFA_REG, &val);
> > > +	printk("CSI_CH_F1_BUFA_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_CH_F2_BUFA_REG, &val);
> > > +	printk("CSI_CH_F2_BUFA_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_CH_STA_REG, &val);
> > > +	printk("CSI_CH_STA_REG=3D0x%x\n",		val);
> > > +	regmap_read(regmap, CSI_CH_INT_EN_REG, &val);
> > > +	printk("CSI_CH_INT_EN_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_CH_INT_STA_REG, &val);
> > > +	printk("CSI_CH_INT_STA_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_CH_FLD1_VSIZE_REG, &val);
> > > +	printk("CSI_CH_FLD1_VSIZE_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_CH_HSIZE_REG, &val);
> > > +	printk("CSI_CH_HSIZE_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_CH_VSIZE_REG, &val);
> > > +	printk("CSI_CH_VSIZE_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_CH_BUF_LEN_REG, &val);
> > > +	printk("CSI_CH_BUF_LEN_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_CH_FLIP_SIZE_REG, &val);
> > > +	printk("CSI_CH_FLIP_SIZE_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_CH_FRM_CLK_CNT_REG, &val);
> > > +	printk("CSI_CH_FRM_CLK_CNT_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_CH_ACC_ITNL_CLK_CNT_REG, &val);
> > > +	printk("CSI_CH_ACC_ITNL_CLK_CNT_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_CH_FIFO_STAT_REG, &val);
> > > +	printk("CSI_CH_FIFO_STAT_REG=3D0x%x\n",	val);
> > > +	regmap_read(regmap, CSI_CH_PCLK_STAT_REG, &val);
> > > +	printk("CSI_CH_PCLK_STAT_REG=3D0x%x\n",	val);
> > > +}
> > > +#endif
> >=20
> > You can already dump a regmap through debugfs, that's redundant.
>=20
> The advantage of in-code registers dump routine is the ability to
> synchronize the snapshot with the driver code execution. This is
> particularly important for the capture statistics registers. I have
> found it useful here.

You also have the option to use the traces to do that, but if that's
useful, this should be added to regmap itself. It can benefit others
too.

> > > +static irqreturn_t sun6i_csi_isr(int irq, void *dev_id)
> > > +{
> > > +	struct sun6i_csi_dev *sdev =3D (struct sun6i_csi_dev *)dev_id;
> > > +	struct regmap *regmap =3D sdev->regmap;
> > > +	u32 status;
> > > +
> > > +	regmap_read(regmap, CSI_CH_INT_STA_REG, &status);
> > > +
> > > +	if ((status & CSI_CH_INT_STA_FIFO0_OF_PD) ||
> > > +	    (status & CSI_CH_INT_STA_FIFO1_OF_PD) ||
> > > +	    (status & CSI_CH_INT_STA_FIFO2_OF_PD) ||
> > > +	    (status & CSI_CH_INT_STA_HB_OF_PD)) {
> > > +		regmap_write(regmap, CSI_CH_INT_STA_REG, status);
> > > +		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, 0);
> > > +		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN,
> > > +				   CSI_EN_CSI_EN);
> >=20
> > You need to enable / disable it at every frame? How do you deal with
> > double buffering? (or did you choose to ignore it for now?)
>=20
> These *_OF_PD status bits indicate an overflow error condition.

Shouldn't we return an error code then? The names of these flags could
be better too.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--phq7ixndptki6bzi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZm0DZAAoJEBx+YmzsjxAgsgMP/2bJxqGAdDFwrFr/OR3D+lo3
ZPNzjXY0g5vYTxAlm0p1i1DeyASWAMMMtaKFgbfl+t4e1xbrGa7vMpTcndm3UKuu
1Xmi01AxOA5xRRm6AQqu53TgqsgvTQlUcFYFklQZ/hA3BcT0SUuizl1ghxQ1IQSl
NZ0ELWufgHDrBsBUyuNkeI3HwTApbketqhAJ3H1lXwyXRvkEkEliZTRS0nJZD5MO
B5kNJgcvpSZY73isRcu2XHPcTWcAPzeuuH2/NMWaZSB70/GaEqQpKQcVfeR92wjp
SUFQu9j3ftINNrnrv3LHWZrHeOyEfSKjRltocEPq0+oW51Epu5G3rDJDRkApbxrB
rQ2gOKFgjGJNaZ9HLjbyve3jBZIVzL/CK7YpBEDTO68WqR4si1SfKryh51k/cvKU
PiC+CYP5ZHUtqHodUGlsw2NaHsDR2RcdeLnK9OS8N9zxppxnxspIgOT2N/JMHKUI
Nf7N7vjRnZOBz9U7RA++8MFtEe/V3dmZMDTkTwRJC/EAd94X7Pq5v0n/oQ8Lan8M
fCaCSWS1lZ+IRchQxOl8CNaS5JzobxPpP0VkkEF75sR1wSkjK2dyj7epUntbvm64
NgUipCetdCWAWKMLK0BpMdxOLCDHux01eEUagYj5Ghfa6siGL7Wwx4R5XTCRULfd
Fz2+hKJhmNYt8fU0aJjb
=azN1
-----END PGP SIGNATURE-----

--phq7ixndptki6bzi--
