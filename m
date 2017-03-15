Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34609 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753375AbdCOTw7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 15:52:59 -0400
Date: Wed, 15 Mar 2017 14:52:50 -0500
From: Rob Herring <robh@kernel.org>
To: Smitha T Murthy <smitha.t@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        devicetree@vger.kernel.org
Subject: Re: [Patch v2 02/11] s5p-mfc: Adding initial support for MFC v10.10
Message-ID: <20170315195250.kq4tywgzmvnzuy4j@rob-hp-laptop>
References: <1488532036-13044-1-git-send-email-smitha.t@samsung.com>
 <CGME20170303090436epcas1p2097d589d9c5e6f7ee634ab9917cc987e@epcas1p2.samsung.com>
 <1488532036-13044-3-git-send-email-smitha.t@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488532036-13044-3-git-send-email-smitha.t@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 03, 2017 at 02:37:07PM +0530, Smitha T Murthy wrote:
> Adding the support for MFC v10.10, with new register file and
> necessary hw control, decoder, encoder and structural changes.
> 
> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> CC: Rob Herring <robh+dt@kernel.org>
> CC: devicetree@vger.kernel.org
> ---
>  .../devicetree/bindings/media/s5p-mfc.txt          |    1 +

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/media/platform/s5p-mfc/regs-mfc-v10.h      |   36 ++++++++++++++++
>  drivers/media/platform/s5p-mfc/s5p_mfc.c           |   30 +++++++++++++
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    4 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |    4 ++
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   44 +++++++++++---------
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   21 +++++----
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |    9 +++-
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |    2 +
>  9 files changed, 118 insertions(+), 33 deletions(-)
>  create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v10.h
