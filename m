Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7632C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 18:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DA4B20684
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 18:18:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p9XPWlsv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730824AbfCFSR4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 13:17:56 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46936 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729135AbfCFSRz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 13:17:55 -0500
Received: by mail-wr1-f66.google.com with SMTP id i16so14495789wrs.13;
        Wed, 06 Mar 2019 10:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wMQHOx5Tu599mHUnjV4tEuswavEFPqn/cXTik92HE4k=;
        b=p9XPWlsvIa+5EmvSSnmswTT3WGpur1NIlZsowQpwY7Hlxb60j7eMa10Q7B2mCD5OPR
         kBAUfPon35Ae/CWRnRg2ZUaw2L8UramjhW9sX2B9qhdcZ9WORq7a9GZMLVMTycqlAmk3
         zBOAqzOrKjID+8Gfw2EQ7DHNkD6s9mjdYE170owKReQYexTafSai4ZxlhU6YsTbFy7Tx
         SFf1v4hehntlvEy5ezI3vUdNMKWhtKZMfoHCQtr6UGujiswOBK58y/Gic29hSsUTKCw1
         PfzRs4rqcnxMHMMBVmmAJcR+j4dzuduGqRRVWzvn+NKQCwkWQ4FR9ypUz1CTq9VA57+A
         EkyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wMQHOx5Tu599mHUnjV4tEuswavEFPqn/cXTik92HE4k=;
        b=jtXGBDXO1Z7bBiwz20Hb2rXMTWr5MFses6yvGhQyV05fgXzr0nndMXXKIAQrrcZ+w4
         FEjZdFil+nQgT2U5Ox1Nojy8TEjEvxxdZPprArL1Djj+XD6wB98LXXjvQdNoGZTxbJAb
         vxc2pwsVLrCCOmwOIQVOvFO41PMbfa3U5VOBMl/YSfEL/XCSUsOJjwvCVftUeVyHO7fu
         dDnxXmDU6Ey8tDBYxPTEygPsXckzO4ysbmcv2PggKlku1oDOsrxQhVh5iKV1xZasgOaM
         6t2w3QAJXa9t4vcyEiovf3yHAdcP8xq+qcrPujo0bRWlXnEBwAk+DFtB0ww+x0/MwFFg
         0qdg==
X-Gm-Message-State: APjAAAXGAUlGeHEjYWz32DyQMw2/mJ2jfhaHvFNfRnRGbg8510/K/WN8
        a651xluDr/VrKEajH3ouSxg=
X-Google-Smtp-Source: APXvYqziMlLO3WwZYEgcuUjlizM4HQjhq7JVTfZsuFqUZO3Km18BltNoRz/UVe5cbbLuIY4NiM8mvg==
X-Received: by 2002:adf:9dc7:: with SMTP id q7mr3721490wre.316.1551896273067;
        Wed, 06 Mar 2019 10:17:53 -0800 (PST)
Received: from jernej-laptop.localnet (cpe-86-58-52-202.static.triera.net. [86.58.52.202])
        by smtp.gmail.com with ESMTPSA id f1sm3004172wmh.44.2019.03.06.10.17.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Mar 2019 10:17:51 -0800 (PST)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        jonas@kwiboo.se, ezequiel@collabora.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v4 2/2] media: cedrus: Add H264 decoding support
Date:   Wed, 06 Mar 2019 19:17:49 +0100
Message-ID: <3704630.sSNj3ip9hk@jernej-laptop>
In-Reply-To: <20190306105708.kjp7xjom42azhl6y@flea>
References: <cover.1862a43851950ddee041d53669f8979aba863c38.1550672228.git-series.maxime.ripard@bootlin.com> <7218484.YqF67YIo71@jernej-laptop> <20190306105708.kjp7xjom42azhl6y@flea>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Dne sreda, 06. marec 2019 ob 11:57:08 CET je Maxime Ripard napisal(a):
> Hi,
>=20
> On Tue, Mar 05, 2019 at 06:05:08PM +0100, Jernej =C5=A0krabec wrote:
> > Dne torek, 05. marec 2019 ob 11:17:32 CET je Maxime Ripard napisal(a):
> > > Hi Jernej,
> > >=20
> > > On Wed, Feb 20, 2019 at 06:50:54PM +0100, Jernej =C5=A0krabec wrote:
> > > > I really wanted to do another review on previous series but got
> > > > distracted
> > > > by analyzing one particulary troublesome H264 sample. It still does=
n't
> > > > work correctly, so I would ask you if you can test it with your sta=
ck
> > > > (it
> > > > might be userspace issue):
> > > >=20
> > > > http://jernej.libreelec.tv/videos/problematic/test.mkv
> > > >=20
> > > > Please take a look at my comments below.
> > >=20
> > > I'd really prefer to focus on getting this merged at this point, and
> > > then fixing odd videos and / or setups we can find later
> > > on. Especially when new stacks are going to be developped on top of
> > > this, I'm sure we're going to have plenty of bugs to address :)
> >=20
> > I forgot to mention, you can add:
> > Reviewed-by: Jernej Skrabec <jernej.skrabec@siol.net>
> >=20
> > once you fix issues.
>=20
> Great, thanks :)
>=20
> > > > > +	for (i =3D 0; i < ARRAY_SIZE(pred_weight->weight_factors); i++)=
 {
> > > > > +		const struct v4l2_h264_weight_factors *factors =3D
> > > > > +			&pred_weight->weight_factors[i];
> > > > > +
> > > > > +		for (j =3D 0; j < ARRAY_SIZE(factors->luma_weight); j++)
> >=20
> > {
> >=20
> > > > > +			u32 val;
> > > > > +
> > > > > +			val =3D ((factors->luma_offset[j] & 0x1ff) <<
> >=20
> > 16)
> >=20
> > > > > +				(factors->luma_weight[j] &=20
0x1ff);
> > > > > +			cedrus_write(dev, VE_AVC_SRAM_PORT_DATA,
> > > >=20
> > > > val);
> > > >=20
> > > > You should cast offset varible to wider type. Currently some videos
> > > > which
> > > > use prediction weight table don't work for me, unless offset is cas=
ted
> > > > to
> > > > u32 first. Shifting 8 bit variable for 16 places gives you 0 every
> > > > time.
> > >=20
> > > I'll do it.
> > >=20
> > > > Luma offset and weight are defined as s8, so having wider mask does=
n't
> > > > really make sense. However, I think weight should be s16 anyway,
> > > > because
> > > > standard says that it's value could be 2^denominator for default va=
lue
> > > > or
> > > > in range -128..127. Worst case would be 2^7 =3D 128 and -128. To co=
ver
> > > > both
> > > > values you need at least 9 bits.
> > >=20
> > > But if I understood the spec right, in that case you would just have
> > > the denominator set, and not the offset, while the offset is used if
> > > you don't use the default formula (and therefore remains in the -128
> > > 127 range which is covered by the s8), right?
> >=20
> > Yeah, default offset is 0 and s8 is sufficient for that. I'm talking ab=
out
> > weight. Default weight is "1 << denominator", which might be 1 << 7 or
> > 128.
> >=20
> > We could also add a flag, which would signal default table. In that case
> > we
> > could just set a bit to tell VPU to use default values. Even if some VP=
Us
> > need default table to be set explicitly, it's very easy to calculate
> > values as mentioned in previous paragraph.
>=20
> Yeah, sorry, I meant weight. Would that make any difference? Can we
> have situations where both the denominator and the weight would be
> set, with the weight set to 128?

Yes, that's the case when default weight is used and (log2) denominator is =
7.=20
Weight is then "1 << denominator".

>=20
> I've checked in the libva and ffmpeg, and libva uses a short, while
> ffmpeg uses an int, both for the weight and offset. For consistency I
> guess we could change both to shorts just like libva?
>=20
> What do you think?

Yes, that would work for me. Maybe someone else has opinion about this? But=
 I=20
think there is a reason why libva uses shorts.

Best regards,
Jernej


