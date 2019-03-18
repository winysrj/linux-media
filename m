Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9BC1C4360F
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 15:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3C392087E
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 15:48:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=raspberrypi.org header.i=@raspberrypi.org header.b="DDYJZUTH";
	dkim=pass (2048-bit key) header.d=raspberrypi.org header.i=@raspberrypi.org header.b="hrWW+iWG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfCRPsJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 11:48:09 -0400
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:25292 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727188AbfCRPsI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 11:48:08 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2IFSLBV027051
        for <linux-media@vger.kernel.org>; Mon, 18 Mar 2019 15:30:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raspberrypi.org; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type; s=pp; bh=z7NWYAIrtguEca6mZj553+8zIDuhYXmnx+eMKRlC0Vw=;
 b=DDYJZUTHhrrcBP6bUQnI3hHllUUCwDKiKNoeNXYhJj3HM5/aE7nAvhoJRKD1m+fvddDX
 jUY0cTLdvDE94+HkodITycnusIthR7C1L7TY2YFolKiMJnOWWBnutWVA5VwyRjUanArl
 GG57Xn7IG7okga4Njfih3VdZljZSBzhGB7mtt2l4uGW7agohPKcyqL/q1kw9qxVphIH0
 xXefa2RJ6WZRailaU4P6SRPLmckQBkV6Cuf1/IbA6ONG9IM0DWmOut8+gwF6ExifT4eT
 SflU0p2r0mrpXEfNmCN/uuPS+Ru7FrSCyLZtQJ5r1KYWbhOpm+gXIjC2YqB9Oh2WcDyq +g== 
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
        by mx07-00252a01.pphosted.com with ESMTP id 2r8qe6h1dx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Mon, 18 Mar 2019 15:30:10 +0000
Received: by mail-pf1-f199.google.com with SMTP id 134so19418469pfx.21
        for <linux-media@vger.kernel.org>; Mon, 18 Mar 2019 08:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z7NWYAIrtguEca6mZj553+8zIDuhYXmnx+eMKRlC0Vw=;
        b=hrWW+iWGPpGxZQVmNEAcHK7+5rx5oV5wNaYXNR6fbIyjnHaEV4JeSPVOGhHpFmb8uT
         TD75v9p96SGgsOE0jlygEP1AcMGtAboVhbUia6ArlyRnX63vX9w5mAwbonsQw9Iyxy+U
         YtjyMfWZPPbcIoICP67/mz2mMwjU7k+NDAG5KVASjfZzVK4U5Dwrz4IanZr8lwjAvJh4
         OSYADlZH8R/VMMxxQvYWM4CBIxXVGw4tD2Up+TpbqfAU8S8H+xAC+IpaGc0y/XrlPg7X
         ic8gYSCux4vgvmyGThJa6U2VRMXqey9av+Rva+l572s4/iOLg1GyoJrECJHUIivUFnBj
         cPNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z7NWYAIrtguEca6mZj553+8zIDuhYXmnx+eMKRlC0Vw=;
        b=EAcJrVLoGuJ+tkzyTtlsUJpMtvWjekICsq/NDAaqZYrLwn0yoOQ6AgpArM36SUpbu6
         V9o5bY5vz1d5e7eEI+istvL55roQwQVCrKd3VPeZq+jqx/3KdEx6CO++IOhdWT41qjcv
         9OFRXOIh6TGjNt58OWjQeFm4ZpQf1qk4kDq8xzMCnY7Wc8nv4eO+/WqmV+NJwaj1ZiHN
         II1V/Pae3clWNzjENcnxXrXEqHZgHAwLqBcRdgoSlblz3S/vwOBvX1UH7NqoGCRvFHAB
         M/GUlhy/MqOqJvJaWxfGHYp5NlxkDDpjSriW9gvoSXlaqOH7iGq8KhHTVpNzf3juL5qq
         DEMA==
X-Gm-Message-State: APjAAAVobEtb8aRU/UBocObP98rII+WWFmirj00TPWyXrTRAK1/iUDgl
        MtxULKe79CjTfPWitVxteNwavosiQRXE/cX5+wraXukVoKZsGBNnAIRvdJgIb2PQ0wmyVcdJxfJ
        lo5R60SfTiYbozOuF8v31GNBgvLdhgFGDDGB/Uw==
X-Received: by 2002:a17:902:6b47:: with SMTP id g7mr20860987plt.100.1552923008193;
        Mon, 18 Mar 2019 08:30:08 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwZ0yVtnrXT8Ue7BKzqf789k3XUTSFww+0w/eZh7NnyaSPkq5D8AHDNEL8HgjAM6Q61XKiwDeb/GlVGP6NOZVs=
X-Received: by 2002:a17:902:6b47:: with SMTP id g7mr20860938plt.100.1552923007674;
 Mon, 18 Mar 2019 08:30:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
 <20190316154801.20460-2-jacopo+renesas@jmondi.org> <20190316175121.wdek74c7tfpmrhde@kekkonen.localdomain>
 <20190318083113.evrnuibomrsumne3@uno.localdomain>
In-Reply-To: <20190318083113.evrnuibomrsumne3@uno.localdomain>
From:   Dave Stevenson <dave.stevenson@raspberrypi.org>
Date:   Mon, 18 Mar 2019 15:29:55 +0000
Message-ID: <CAAoAYcOL-7PFhbN6zEpheH794-jUPbU1R2c1ERbouhtQODyjYg@mail.gmail.com>
Subject: Re: [RFC 1/5] v4l: subdev: Add MIPI CSI-2 PHY to frame desc
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com,
        LMML <linux-media@vger.kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-18_10:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo.

Sorry, for some reason linux-media messages aren't coming through to
me at the moment.

I'm interested mainly for tc358743 rather than adv748x, but they want
the very similar functionality.
I'll try to create patches for that source as well.

On Mon, 18 Mar 2019 at 08:30, Jacopo Mondi <jacopo@jmondi.org> wrote:
>
> Hi Sakari,
> +Maxime because of it's D-PHY work in the phy framework.
>
> On Sat, Mar 16, 2019 at 07:51:21PM +0200, Sakari Ailus wrote:
> > Hi Jacopo,
> >
> > On Sat, Mar 16, 2019 at 04:47:57PM +0100, Jacopo Mondi wrote:
> > > Add PHY-specific parameters to MIPI CSI-2 frame descriptor.
> > >
> > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > ---
> > >  include/media/v4l2-subdev.h | 42 +++++++++++++++++++++++++++++++------
> > >  1 file changed, 36 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > > index 6311f670de3c..eca9633c83bf 100644
> > > --- a/include/media/v4l2-subdev.h
> > > +++ b/include/media/v4l2-subdev.h
> > > @@ -317,11 +317,33 @@ struct v4l2_subdev_audio_ops {
> > >     int (*s_stream)(struct v4l2_subdev *sd, int enable);
> > >  };
> > >
> > > +#define V4L2_FRAME_DESC_ENTRY_DPHY_DATA_LANES      4
> > > +
> > > +/**
> > > + * struct v4l2_mbus_frame_desc_entry_csi2_dphy - MIPI D-PHY bus configuration
> > > + *
> > > + * @clock_lane:            physical lane index of the clock lane
> > > + * @data_lanes:            an array of physical data lane indexes
> > > + * @num_data_lanes:        number of data lanes
> > > + */
> > > +struct v4l2_mbus_frame_desc_entry_csi2_dphy {
> > > +   u8 clock_lane;
> > > +   u8 data_lanes[V4L2_FRAME_DESC_ENTRY_DPHY_DATA_LANES];
> > > +   u8 num_data_lanes;
> >
> > Do you need more than the number of the data lanes? I'd expect few devices
> > to be able to do more than that. The PHY type comes already from the
> > firmware but I guess it's good to do the separation here as well.
>
> Indeed lane reordering at run time seems like a quite unusual
> operation. I would say I could drop that, but then, a structure and a
> new field in v4l2_mbus_frame_desc for just an u8, isn't it an
> overkill (unless we know it could be expanded, with say, D-PHY timings
> as in Maxime's D-PHY phy support implementation. Again, not sure they
> should be run-time negotiated, but...)

If we're adding extra information, then can I suggest that the
clock-noncontinuous flag is also added?
If you've got muxed CSI2 buses (eg via the FSA642 [1] as a trivial
CSI2 switch), then there is nothing stopping one source wanting
continuous clocks, and one not. Encoding it in the receiver's DT node
therefore doesn't work for one of the sources. Duplication of that
definition between source and receiver has always seemed a likely
source of errors to me, but I'm the relative newcomer here.

Cheers
  Dave

[1] https://www.onsemi.com/PowerSolutions/product.do?id=FSA642
available on a board such as
http://www.ivmech.com/magaza/en/development-modules-c-4/ivport-dual-v2-raspberry-pi-camera-module-v2-multiplexer-p-109

> >
> > Could you use V4L2_FWNODE_CSI2_MAX_DATA_LANES? Or we could rename it. But I
> > think it'd be good to stick to a single definition.
> >
>
> I initially moved and renamed that define, then went back and added a
> new one as I was not sure where to put this new global and D-PHY
> specific define. I'll look into unifying them.
>
> Thanks
>   j
>
>
> > > +};
> > > +
> > > +/**
> > > + * struct v4l2_mbus_frame_desc_entry_csi2_cphy - MIPI C-PHY bus configuration
> > > + */
> > > +struct v4l2_mbus_frame_desc_entry_csi2_cphy {
> > > +   /* TODO */
> > > +};
> > > +
> > >  /**
> > >   * struct v4l2_mbus_frame_desc_entry_csi2
> > >   *
> > > - * @channel: CSI-2 virtual channel
> > > - * @data_type: CSI-2 data type ID
> > > + * @channel:       CSI-2 virtual channel
> > > + * @data_type:     CSI-2 data type ID
> > >   */
> > >  struct v4l2_mbus_frame_desc_entry_csi2 {
> > >     u8 channel;
> > > @@ -371,18 +393,26 @@ enum v4l2_mbus_frame_desc_type {
> > >     V4L2_MBUS_FRAME_DESC_TYPE_PLATFORM,
> > >     V4L2_MBUS_FRAME_DESC_TYPE_PARALLEL,
> > >     V4L2_MBUS_FRAME_DESC_TYPE_CCP2,
> > > -   V4L2_MBUS_FRAME_DESC_TYPE_CSI2,
> > > +   V4L2_MBUS_FRAME_DESC_TYPE_CSI2_DPHY,
> > > +   V4L2_MBUS_FRAME_DESC_TYPE_CSI2_CPHY,
> > >  };
> > >
> > >  /**
> > >   * struct v4l2_mbus_frame_desc - media bus data frame description
> > > - * @type: type of the bus (enum v4l2_mbus_frame_desc_type)
> > > - * @entry: frame descriptors array
> > > - * @num_entries: number of entries in @entry array
> > > + * @type:          type of the bus (enum v4l2_mbus_frame_desc_type)
> > > + * @entry:         frame descriptors array
> > > + * @phy:           PHY specific parameters
> > > + * @phy.dphy:              MIPI D-PHY specific bus configurations
> > > + * @phy.cphy:              MIPI C-PHY specific bus configurations
> > > + * @num_entries:   number of entries in @entry array
> > >   */
> > >  struct v4l2_mbus_frame_desc {
> > >     enum v4l2_mbus_frame_desc_type type;
> > >     struct v4l2_mbus_frame_desc_entry entry[V4L2_FRAME_DESC_ENTRY_MAX];
> > > +   union {
> > > +           struct v4l2_mbus_frame_desc_entry_csi2_dphy csi2_dphy;
> > > +           struct v4l2_mbus_frame_desc_entry_csi2_cphy csi2_cphy;
> > > +   } phy;
> > >     unsigned short num_entries;
> > >  };
> > >
> >
> > --
> > Regards,
> >
> > Sakari Ailus
> > sakari.ailus@linux.intel.com
> -----BEGIN PGP SIGNATURE-----
>
> iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyPV1EACgkQcjQGjxah
> VjxkUxAAkdhZTDN90GEkYfaiIIhthYaaz3Hd2ByI51aTqbNR4wq/6+WeqqmCUVJP
> wSB4cD3NQp6ZfJLbw97+XZ1oIZj7n4IRNDD050a3z4MFmVkJiz7dJ/yetBZhaqvA
> eutDDqk+OM6GJc0d2IUTOuiX69JSA9ToUXJrcMbkCp8TjzD5g7Kt7bwbQv4oaG44
> VBzTaMJpgGWzP1Lxv78mnWeOtH+WIuufw4vtjF5UHvRO8EC6f3kdqilem76+Ffn2
> N+n3ajhvbPyHk398wyxmcNhm29DZ6Y8CehqWw3AlzMHVbCeEEeEqsQ2MmRxrBlYx
> +U8R0Nw9JHJ1BqsrjkWWWMVCrTNzoeAGIu4Dbd/81JpxAG+FowNaVDI0Xlm0r9wG
> psLhQr6ZFaEcxE07VU7E8jfoGvjbRfmZkrtdxr34tUoBAE/YXfZ6rVXVCjTqABIf
> dcGNVMtVDV7cMvqjqiJa+9uHx467b0QZEaYn3CwW2V7qoa4D7iLf4WchsW9gvjq4
> mUEnzQFbd63qFuBaTrE4paq9hkYcoSAjrrDtL12l3FHop4wTjJLCJXLSO7khd97w
> qMQOKnWKI8edPrakz3nBx8lexgOWcoe/tMRYDF4dgYJLMm+ZNS0R90Xu9x5DMOvG
> cYBKeQk72lr0znYNTowGdc+xZcuO2BjyU83SnyZuRsmAo6kg3nA=
> =BYda
> -----END PGP SIGNATURE-----
