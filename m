Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B088BC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 13:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D58E20656
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 13:39:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t1V0FTDO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbfAONjQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 08:39:16 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:35004 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729294AbfAONjP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 08:39:15 -0500
Received: by mail-wm1-f52.google.com with SMTP id t200so3271744wmt.0
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2019 05:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=i1Dz1DUNwUDcLO+KZY/1Cj05d5UcZeYtD0nxmdaxtlk=;
        b=t1V0FTDOdCjhvx4FwbHndzUvVaLZXUYZmESFx4FvU11lOg93J/t3QPNfB5qLIZDEIc
         Xmr0SI8RRABHFXTM5suCjkOv/U2PdNq9c/v6WBTZrK1uwBXs7czwNOG2qapESnCQCeNh
         +ZLs+VOeTmVCoNLWTHSFWmMXuzPcOW/C8N8JMoC19yk97PQv5JNlUpp96jcPytxkGOyG
         NjbUeL5SS5xQm1nvlLVGuPctCALklFFt2y012yN++9Vic06zGe3Pl89j9uZKSYADdowm
         zj/Xh0SSX6J2sntqHj9AIYo6RedAnwX5VV/whyhvfbNKWSrtwdBw/uUWrbn5ZEYLn5KM
         yRAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i1Dz1DUNwUDcLO+KZY/1Cj05d5UcZeYtD0nxmdaxtlk=;
        b=GM+NWA2IADjEgtH8+W20K14syCW/HfQ3RvlzR4xAw/S84Ck56mt7PlFja6dhbWcC0T
         BVtWN4rzVpPCdJrZQjq36vyzCifPFEL53yovc+RAZYgygXYOfKcajfm8o1tBVTgoL9QL
         nHS30hukgVNYwePOdXwYQ48AMrefiIsd8gKuER1arQqYWcQ2yKlMfT1QayjrYh7ey3fE
         ZuU/UUnZoBHI1l6NWdAbJyxOD8U6L38ecDLvBQrjd3X1rp6GqOQ4jqXyea2p1XMtM/NK
         BcekGDW32LnTFC+lqYMbW/1b0yPtDs0NEhSuZrxhuubY5RZ5URa09y2028s6JIlC3UT8
         G5JA==
X-Gm-Message-State: AJcUukdFTImn26BCdHEtW0t8aC2CerKuT4U97g9lNMS2BTsGIj1kZRLW
        VWrYYgjSAetjSQqhDnujZO54ri5rp6Of10EkuoM=
X-Google-Smtp-Source: ALg8bN5FLDhenXBwVI86/31J+VnJDQcysFRqrYuVjn1ogT9+m1+dSP6DPmkMF2rWE1bTa5eO8e6YgKkSI6Fqmgp0JKg=
X-Received: by 2002:a7b:c04e:: with SMTP id u14mr3502833wmc.113.1547559552855;
 Tue, 15 Jan 2019 05:39:12 -0800 (PST)
MIME-Version: 1.0
References: <CAL8zT=j79yQ2=RfE2zVhM0o4Cck1xKTo9oUG73kiAExDvQkt7w@mail.gmail.com>
 <9e09aea4-79c7-dd6e-3f5b-60a410308280@gmail.com>
In-Reply-To: <9e09aea4-79c7-dd6e-3f5b-60a410308280@gmail.com>
From:   Jean-Michel Hautbois <jhautbois@gmail.com>
Date:   Tue, 15 Jan 2019 14:39:01 +0100
Message-ID: <CAL8zT=h6LLGUhJ391U6L4uSTEz0Ohij4uJP5bQbGAqTLtN3H_g@mail.gmail.com>
Subject: Re: i.MX6 RAW8 format
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>, sakari.ailus@iki.fi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Steve !

Thanks for answering !

Le mar. 15 janv. 2019 =C3=A0 01:54, Steve Longerbeam
<slongerbeam@gmail.com> a =C3=A9crit :
>
> Hi JM,
>
> On 1/14/19 1:52 AM, Jean-Michel Hautbois wrote:
> > Hi,
> >
> > I am currently using an upstream kernel on a i.MX6 Quad board, and I
> > have a strange issue.
> > The device I am using is able to produce RGB888 MIPI data, or RAW8/RAW1=
0.
> > The MIPI data types are respectively 0x24, 0x2A and 0x2B.
> > When I configure the device to produce RGB888 data, everything is
> > fine, but when I configure it to produce RAW8 data, then the pattern
> > is weird.
> >
> > I am sending the following pattern :
> > 0x11 0x22 0x33 0x44 0x55 0x66 0x77 0x88 0x99 0xAA 0xBB 0xCC 0xDD 0xEE
> > 0x11 0x22 0x33 0x44 0x55 0x66...
> > And I get in a raw file :
> > 0x11 0x22 0x33 0x44 0x55 0x66 0x77 0x88 0x33 0x44 0x55 0x66 0x77 0x88 0=
x99 ...
> > The resulting raw file has the correct size (ie. 1280x720 bytes).
> >
> > I could get a logic analyzer able to decode MIPI-CSI2 protocol, and on
> > this side, the pattern is complete, no data is lost, and the Datatype
> > is 0x2A.
> > It really looks like an issue on the i.MX6 side.
> >
> > So, looking at it, I would say than for each 8 bytes captured, a jump
> > of 8 bytes is done ?
>
> Sure looks that way.
>
> > The media-ctl is configured like this :
> > media-ctl -l "'ds90ub954 2-0034':0 -> 'imx6-mipi-csi2':0[1]" -v
> > media-ctl -l "'imx6-mipi-csi2':1 -> 'ipu1_csi0_mux':0[1]" -v
> > media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]" -v
> > media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
> > media-ctl -V "'ds90ub954 2-0034':0 [fmt:SBGGR8_1X8/1280x720 field:none]=
"
> > media-ctl -V "'imx6-mipi-csi2':1 [fmt:SBGGR8_1X8/1280x720 field:none]"
> > media-ctl -V "'ipu1_csi0_mux':2 [fmt:SBGGR8_1X8/1280x720 field:none]"
> > media-ctl -V "'ipu1_csi0':2 [fmt:SBGGR8_1X8/1280x720 field:none]"
> >
> > The ds90ub954 driver I wrote is very dump and just used to give I=C2=B2=
C
> > access and configure the deserializer to produce the pattern.
> > I also tried to use a camera, which produces RAW8 data, but the result
> > is the same, I don't get all my bytes, at least, not in the correct
> > order.
> >
> > And the command used to capture a file is :
> > v4l2-ctl -d4 --set-fmt-video=3Dwidth=3D1280,height=3D720,pixelformat=3D=
BA81
> > --stream-mmap --stream-count=3D1 --stream-to=3D/root/cam.raw
> >
> > I can send the raw file if it is needed.
> > I tried several configurations, changing the number of lanes, the
> > frequency, etc. but I have the same behaviour.
> >
> > So, I am right now stuck with this, as I can't see anything which
> > could explain this. IC burst ? Something else ?
>
> The problem couldn't be IC burst size as the IC isn't involved in this
> pipeline.

You are right, and in fact I was thinking of IDMAC while writing :s

> One way I see this happening is that the IDMA channel burst writes 16
> bytes to memory (so that the channel's read pointer advances by 16
> bytes), but somehow the channel's write pointer has only advanced by 8
> bytes.
>
> I don't know how that could happen, but you might try reverting
>
> 37ea9830139b3 ("media: imx-csi: fix burst size")

It is the correct issue, but what I didn't mention is that I was on a
4.14, and not the most recent, and burst_size is set to 8.
The commit 37ea9830139b3 has been introduced later, and so I didn't have it=
...

The commit is not explicit though, as it mentions IMX219 and not i.MX6.
But it works with 16 ;).

Thanks,
JM
