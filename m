Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC75C282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 03:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F3C621B68
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 03:41:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="m2w2garc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbfBMDlP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 22:41:15 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34537 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727614AbfBMDlP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 22:41:15 -0500
Received: by mail-ot1-f66.google.com with SMTP id 98so1715876oty.1
        for <linux-media@vger.kernel.org>; Tue, 12 Feb 2019 19:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=58B8G8X3Q4XpZNnJHFqf2/dMYMx2cfT2/6gIk5ZPDgM=;
        b=m2w2garcjjHQrlMfRSQO+gegZArUIyGF0sLUg0iEvQWlaINzbFZCdolra4zO/An/56
         QUOdEaaxfICq9CtBwcaTYltoPT/+Ztas1e+5SkS5MVQtTFoce6q81Lmurnm5WVGjBxpt
         WpkX1Q6RXUxFTTgL0UxoF3A7yfudjmy7QGsPY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=58B8G8X3Q4XpZNnJHFqf2/dMYMx2cfT2/6gIk5ZPDgM=;
        b=nHB5Z0mzECNauiW+4X323zkz0lDwpcBNV1uiaroZQpsvDW/jk+2XYhcXKxyPmV5aSE
         soOHPMsfbww0B8+Ug2sEyKwERsPJXZsj1b7WRUAgHtcXR//FeHN/DKeeWhpDSAWRak01
         lbGp/uFhRNlThV815aeH89ruUFJAnVfJNaTRY7urdKvc6j2BLy5sKPI/N6/pfH0KPfwx
         zKpLRbkjw/6JHSuWeu2GGtKFX4p6j1Q501u0ByKCUZZyQoFbLxxI7TraSMPVOL9N7eWR
         IYfCiYVESHjHtZZmLKEovzdq6rxArolhzm8+aJQMVS6uc0JwMoSFTxn+cQaSIE17BYN+
         /MEw==
X-Gm-Message-State: AHQUAuah4rPVtBW22SnMExKk9+LVqLXlVaYLIvCbQskr/WuvCh98LcZh
        A1oRPCSTar7GJA9e0nrY+Xlwa0vq6ck=
X-Google-Smtp-Source: AHgI3IZQZN8KV8QwjiiAug3qYxQGxWnZt2/auAlol/ymhqYTcj/cFxeiMsq7RwiiJfj3exV1Ed6fJg==
X-Received: by 2002:aca:fd4c:: with SMTP id b73mr1049oii.33.1550029273434;
        Tue, 12 Feb 2019 19:41:13 -0800 (PST)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com. [209.85.210.50])
        by smtp.gmail.com with ESMTPSA id q26sm6805513otf.73.2019.02.12.19.41.12
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 19:41:12 -0800 (PST)
Received: by mail-ot1-f50.google.com with SMTP id 32so1596301ota.12
        for <linux-media@vger.kernel.org>; Tue, 12 Feb 2019 19:41:12 -0800 (PST)
X-Received: by 2002:aca:644:: with SMTP id 65mr1104oig.21.1550029271733; Tue,
 12 Feb 2019 19:41:11 -0800 (PST)
MIME-Version: 1.0
References: <1549020091-42064-1-git-send-email-frederic.chen@mediatek.com>
 <1549020091-42064-2-git-send-email-frederic.chen@mediatek.com>
 <20190209155907.rbgwbdablndcesid@valkosipuli.retiisi.org.uk>
 <20190209181705.GB4505@pendragon.ideasonboard.com> <1549964242.27207.11.camel@mtksdccf07>
In-Reply-To: <1549964242.27207.11.camel@mtksdccf07>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 13 Feb 2019 12:41:00 +0900
X-Gmail-Original-Message-ID: <CAAFQd5AuvvgGO3t2bUk345QM6zSWo5LSq-j-=H_-qNchWKPPWg@mail.gmail.com>
Message-ID: <CAAFQd5AuvvgGO3t2bUk345QM6zSWo5LSq-j-=H_-qNchWKPPWg@mail.gmail.com>
Subject: Re: [RFC PATCH V0 1/7] [media] dt-bindings: mt8183: Add binding for
 DIP shared memory
To:     Frederic Chen <frederic.chen@mediatek.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc:     devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-mediatek@lists.infradead.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?B?U2VhbiBDaGVuZyAo6YSt5piH5byYKQ==?= 
        <Sean.Cheng@mediatek.com>, Sj Huang <sj.huang@mediatek.com>,
        =?UTF-8?B?Q2hyaXN0aWUgWXUgKOa4uOmbheaDoCk=?= 
        <christie.yu@mediatek.com>,
        =?UTF-8?B?SG9sbWVzIENoaW91ICjpgrHmjLop?= 
        <holmes.chiou@mediatek.com>, Jerry-ch.Chen@mediatek.com,
        =?UTF-8?B?SnVuZ28gTGluICjmnpfmmI7kv4op?= <jungo.lin@mediatek.com>,
        =?UTF-8?B?UnlubiBXdSAo5ZCz6IKy5oGpKQ==?= <Rynn.Wu@mediatek.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        srv_heupstream@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Feb 12, 2019 at 6:37 PM Frederic Chen
<frederic.chen@mediatek.com> wrote:
>
> Dear Laurent and Sakari,
>
> I appreciate your messages.
>
> On Sat, 2019-02-09 at 20:17 +0200, Laurent Pinchart wrote:
> > On Sat, Feb 09, 2019 at 05:59:07PM +0200, Sakari Ailus wrote:
> > > Hi Frederic,
> > >
> > > Could you cc the devicetree list, please?
> > >
> > > On Fri, Feb 01, 2019 at 07:21:25PM +0800, Frederic Chen wrote:
> > > > This patch adds the binding for describing the shared memory
> > > > used to exchange configuration and tuning data between the
> > > > co-processor and Digital Image Processing (DIP) unit of the
> > > > camera ISP system on Mediatek SoCs.
> > > >
> > > > Signed-off-by: Frederic Chen <frederic.chen@mediatek.com>
> > > > ---
> > > >  .../mediatek,reserve-memory-dip_smem.txt           | 45 ++++++++++=
++++++++++++
> > > >  1 file changed, 45 insertions(+)
> > > >  create mode 100644 Documentation/devicetree/bindings/reserved-memo=
ry/mediatek,reserve-memory-dip_smem.txt
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/reserved-memory/medi=
atek,reserve-memory-dip_smem.txt b/Documentation/devicetree/bindings/reserv=
ed-memory/mediatek,reserve-memory-dip_smem.txt
> > > > new file mode 100644
> > > > index 0000000..0ded478
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/reserved-memory/mediatek,re=
serve-memory-dip_smem.txt
> > > > @@ -0,0 +1,45 @@
> > > > +Mediatek DIP Shared Memory binding
> > > > +
> > > > +This binding describes the shared memory, which serves the purpose=
 of
> > > > +describing the shared memory region used to exchange data between =
Digital
> > > > +Image Processing (DIP) and co-processor in Mediatek SoCs.
> > > > +
> > > > +The co-processor doesn't have the iommu so we need to use the phys=
ical
> > > > +address to access the shared buffer in the firmware.
> > > > +
> > > > +The Digital Image Processing (DIP) can access memory through mt818=
3 IOMMU so
> > > > +it can use dma address to access the memory region.
> > > > +(See iommu/mediatek,iommu.txt for the detailed description of Medi=
atek IOMMU)
> > >
> > > What kind of purpose is the memory used for? Buffers containing video=
 data,
> > > or something else? Could the buffer objects be mapped on the devices
> > > based on the need instead?
>
> The memory buffers contain camera 3A tuning data, which are used by the
> co-processor and DIP IP. About mapping the buffer based on the need
> instead, I=E2=80=99m not sure I understand this point. Do you mean that
> allocating and mapping the memory dynamically?
>
> >
> > And could CMA be used when physically contiguous memory is needed ?
>
> DIP driver does not use CMA now, because the first version will be used
> by CrOS but CrOS won=E2=80=99t enable CMA.
>

Thanks Frederic for replying. Let me further clarify what's the problem her=
e.

The co-processor is behind a simple MPU (Memory Protection Unit),
which does not have any mapping capabilities, but can only allow or
deny access to particular parts of the physical address space. That
means that we have to either build some scatter gather capability
inside of the firmware or just do with contiguous allocation.

There is also a security aspect here. The MPU can be accessed from
both the co-processor and CPU, but it has a lockdown mode, which makes
it read only until the SoC is reset. If we allocate the memory
dynamically, we need to keep the MPU unlocked, which automatically
grants the firmware access to all the address space.

For security reasons we decided to go with preallocated memory pool,
which lets us pre-program the MPU and lock it down.

Best regards,
Tomasz

> >
> > > > +
> > > > +
> > > > +Required properties:
> > > > +
> > > > +- compatible: must be "mediatek,reserve-memory-dip_smem"
> > > > +
> > > > +- reg: required for static allocation (see reserved-memory.txt for
> > > > +  the detailed usage)
> > > > +
> > > > +- alloc-range: required for dynamic allocation. The range must
> > > > +  between 0x00000400 and 0x100000000 due to the co-processer's
> > > > +  addressing limitation
> > > > +
> > > > +- size: required for dynamic allocation. The unit is bytes.
> > > > +  If you want to enable the full feature of Digital Processing Uni=
t,
> > > > +  you need 20 MB at least.
> > > > +
> > > > +
> > > > +Example:
> > > > +
> > > > +The following example shows the DIP shared memory setup for MT8183=
.
> > > > +
> > > > + reserved-memory {
> > > > +         #address-cells =3D <2>;
> > > > +         #size-cells =3D <2>;
> > > > +         ranges;
> > > > +         reserve-memory-isp_smem {
> > > > +                 compatible =3D "mediatek,reserve-memory-dip_smem"=
;
> > > > +                 size =3D <0 0x1400000>;
> > > > +                 alignment =3D <0 0x1000>;
> > > > +                 alloc-ranges =3D <0 0x40000000 0 0x50000000>;
> > > > +         };
> > > > + };
> >
>
> Sincerely,
>
> Frederic Chen
>
>
