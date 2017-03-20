Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:54671 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbdCTF0g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 01:26:36 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0ON300CEDLSA6T80@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Mar 2017 14:26:34 +0900 (KST)
Subject: Re: [Patch v2 02/11] s5p-mfc: Adding initial support for MFC v10.10
From: Smitha T Murthy <smitha.t@samsung.com>
To: Rob Herring <robh@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        devicetree@vger.kernel.org
In-reply-to: <20170315195250.kq4tywgzmvnzuy4j@rob-hp-laptop>
Date: Mon, 20 Mar 2017 10:57:57 +0530
Message-id: <1489987677.27807.145.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
Content-type: text/plain; charset=utf-8
References: <1488532036-13044-1-git-send-email-smitha.t@samsung.com>
 <CGME20170303090436epcas1p2097d589d9c5e6f7ee634ab9917cc987e@epcas1p2.samsung.com>
 <1488532036-13044-3-git-send-email-smitha.t@samsung.com>
 <20170315195250.kq4tywgzmvnzuy4j@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-03-15 at 14:52 -0500, Rob Herring wrote:
> On Fri, Mar 03, 2017 at 02:37:07PM +0530, Smitha T Murthy wrote:
> > Adding the support for MFC v10.10, with new register file and
> > necessary hw control, decoder, encoder and structural changes.
> > 
> > Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> > CC: Rob Herring <robh+dt@kernel.org>
> > CC: devicetree@vger.kernel.org
> > ---
> >  .../devicetree/bindings/media/s5p-mfc.txt          |    1 +
> 
> Acked-by: Rob Herring <robh@kernel.org>
> 
Thank you for the Acked-by.
Regards,
Smitha T Murthy
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
> 
> 
