Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:53646 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdBFI4z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2017 03:56:55 -0500
Subject: Re: [PATCH 02/11] [media] s5p-mfc: Adding initial support for MFC
 v10.10
From: Smitha T Murthy <smitha.t@samsung.com>
To: Rob Herring <robh@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        devicetree@vger.kernel.org
In-reply-to: <20170121202852.pxxfxpqwjxewjoj5@rob-hp-laptop>
Content-type: text/plain; charset=UTF-8
Date: Mon, 06 Feb 2017 14:07:02 +0530
Message-id: <1486370223.16927.76.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
References: <1484733729-25371-1-git-send-email-smitha.t@samsung.com>
 <CGME20170118100723epcas5p132e0ebfad38261bed95cffc47334f9dc@epcas5p1.samsung.com>
 <1484733729-25371-3-git-send-email-smitha.t@samsung.com>
 <20170121202852.pxxfxpqwjxewjoj5@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2017-01-21 at 14:28 -0600, Rob Herring wrote:
> On Wed, Jan 18, 2017 at 03:32:00PM +0530, Smitha T Murthy wrote:
> > Adding the support for MFC v10.10, with new register file and
> > necessary hw control, decoder, encoder and structural changes.
> > 
> > CC: Rob Herring <robh+dt@kernel.org>
> > CC: devicetree@vger.kernel.org 
> > Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> > ---
> >  .../devicetree/bindings/media/s5p-mfc.txt          |    1 +
> >  drivers/media/platform/s5p-mfc/regs-mfc-v10.h      |   36 ++++++++++++++++
> >  drivers/media/platform/s5p-mfc/s5p_mfc.c           |   30 +++++++++++++
> >  drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    4 +-
> >  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |    4 ++
> >  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   44 +++++++++++---------
> >  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   21 +++++----
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |    9 +++-
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |    2 +
> >  9 files changed, 118 insertions(+), 33 deletions(-)
> >  create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> > 
> > diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
> > index 2c90128..b70c613 100644
> > --- a/Documentation/devicetree/bindings/media/s5p-mfc.txt
> > +++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
> > @@ -13,6 +13,7 @@ Required properties:
> >  	(c) "samsung,mfc-v7" for MFC v7 present in Exynos5420 SoC
> >  	(d) "samsung,mfc-v8" for MFC v8 present in Exynos5800 SoC
> >  	(e) "samsung,exynos5433-mfc" for MFC v8 present in Exynos5433 SoC
> > +	(f) "samsung,mfc-v10" for MFC v10 present in a variant of Exynos7 SoC
> 
> You are up to v10 in how many SoCs? Please stop with versions and use 
> SoC numbers. It's one thing to use versions when you have many SoCs per 
> version, but that doesn't seem to be happening here.
> 
> Rob
MFCv10.10 is used in Exynos7880. There are other variants of MFCv10 used
in Exynos8890 and Exynos7870. I will mention in the next version of
patches the SoC name Exynos7880 using MFCv10 on which I have tested.
 
Thank you for the review.

Regards,
Smitha
> 
> 





