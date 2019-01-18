Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C27C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 17:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3838D2086D
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 17:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfARRDX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 12:03:23 -0500
Received: from mout.gmx.net ([212.227.17.21]:43395 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbfARRDX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 12:03:23 -0500
Received: from localhost ([188.110.163.212]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MFctN-1gzA8y3ETF-00Edpa; Fri, 18
 Jan 2019 18:03:21 +0100
Date:   Fri, 18 Jan 2019 18:03:21 +0100
From:   Peter Seiderer <ps.report@gmx.net>
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     linux-media@vger.kernel.org
Subject: Re: [v2,1/2] media: imx: csi: Disable CSI immediately after last
 EOF
Message-ID: <20190118180321.2789f7a2@gmx.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:DFcp9V8qfthfrglVjaH7YXXMavQY1TLv++qzPrAi9XqZw3KoV7W
 1DDv1sgK2ufQY4E5jus5/sI64s/7MeQ+1nINcwqY17WxyLptHCADMD4RcFYljreuwneJxg6
 ZUMNFynEfxEfZ0tmz3D0G/+8WYOiAPiQz7w1rDIF7n90gywufJN7SBg1kF6WO13Ds3vlNTE
 3wVIz6ZKjwa288+Qs/APg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:FWpkEc9ZMZY=:WzsS3tUJQxLqBxkD27sUGN
 ZyKBFc94x5vUTMa0E7C00zO5KnPhSYGb6Cb/FEJKgGXXvwx/V2OQJ8pqb/yM9GLhMNkw0u84H
 oW0Ma64vpucNHy9/7PmM51o6cXhGl+18Oi8kDTCeOpKWlHH6hJjUGnAfwoqU4gYh5Y8g3f5E9
 ZPYxnAcTpCIFC1UPjIMkYaFofII7vRDSBLVd2uPVwuYVz4DxJg5H6uqZy0p00siEK4DqjN0+w
 /pS8OFVTEWdO40Bc8YWf+8CBgJEWvuUANMoAdaj+YOO6Br7ZDBwRo4nRAktBnlQsLjImXBI1g
 VAZOsmTimDpWpFrIhj7AWkR4DOICrIMaUGynfaPTrVp2Q69jiGKdBZmZyFRjYt5DToVPwM56V
 ru7bZBuhukpdS7QdSF01+mIRneOwEJHYh8lSVt2ZfSKpWBJ90TrlTrx2Wt0qm125q1ggxgiOx
 rPc8PknZ0kdxvLKWNwRgWFbZb1Wt7p3gc23RVVCGTYspZuuK7RreHrdV6pw2PuvDfC8qaynlK
 ecF/lcqFw3XwR7P6Gzq2fL3pbrUmssWlRtHaYjMiUFlcuE+EFu4NV6gW13fAeGDn2lMV0rt92
 HtgjeAE6g0vJOx5Q8frjAq2Tq2rAkXvxuFtY1A61cjNQjMMSs+h0zIUZ4mEkgy+QcqHsyLBA4
 JCYk6lB61brjnTBza9XgaHN/t2ONbGjmnojisJ2FtJvAuOACMTd3CZWVVg1+Dytq/PlruKYWa
 eAIoT/Rwv518W0QGompjADuC4kd3tXgLuXsYvzlkDw1Az/gLGOJrkwVF2HsYm6RXGoA4iSCs+
 XQEJkm/JGbLZASxEmxWFvBx6EZfz95xMLkP3j/VdCZPjDnIzHLFYNdYLvXaCRNnjhXO6YU7m6
 rqUDf2lRLvo0O6uNaXU5E2XSiGStE2G7/zA8t5vcLbc/yRQguj0M+QCp5REEWfIvlmp+7noza
 5mD64m9tsxQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Steve,

On Thu, Jan 17, 2019 at 6:15 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
> Disable the CSI immediately after receiving the last EOF before stream
> off (and thus before disabling the IDMA channel).
>
> This fixes a complete system hard lockup on the SabreAuto when streaming
> from the ADV7180, by repeatedly sending a stream off immediately followed
> by stream on:
> 
> while true; do v4l2-ctl  -d4 --stream-mmap --stream-count=3; done
> 
> Eventually this either causes the system lockup or EOF timeouts at all
> subsequent stream on, until a system reset.
> 
> The lockup occurs when disabling the IDMA channel at stream off. Disabling
> the CSI before disabling the IDMA channel appears to be a reliable fix for
> the hard lockup.
> 
> Fixes: 4a34ec8e470cb ("[media] media: imx: Add CSI subdev driver")
[...]

Similar lockup observed on a custom i.mx6 board, fixed locally by the following
patch/workaround:

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 555aa45e02e3..f04d1695f7a4 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -560,8 +560,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 static void csi_idmac_unsetup(struct csi_priv *priv,
                              enum vb2_buffer_state state)
 {
-       ipu_idmac_disable_channel(priv->idmac_ch);
        ipu_smfc_disable(priv->smfc);
+       ipu_idmac_disable_channel(priv->idmac_ch);

        csi_idmac_unsetup_vb2_buf(priv, state);
 }

Will test your patch the next days...

Regards,
Peter

[Sorry for missing some of the CC and Message-Id, not fully subscribed to linux-media]
