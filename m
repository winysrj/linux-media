Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60D3C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 11:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73A6E21738
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 11:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbfAILLu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 06:11:50 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:48311 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730569AbfAILLt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 06:11:49 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ghBm0-00032G-H6; Wed, 09 Jan 2019 12:11:48 +0100
Message-ID: <1547032306.4160.0.camel@pengutronix.de>
Subject: Re: [PATCH v6 02/12] gpu: ipu-csi: Swap fields according to
 input/output field types
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
Date:   Wed, 09 Jan 2019 12:11:46 +0100
In-Reply-To: <20190109001551.16113-3-slongerbeam@gmail.com>
References: <20190109001551.16113-1-slongerbeam@gmail.com>
         <20190109001551.16113-3-slongerbeam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 2019-01-08 at 16:15 -0800, Steve Longerbeam wrote:
> The function ipu_csi_init_interface() was inverting the F-bit for
> NTSC case, in the CCIR_CODE_1/2 registers. The result being that
> for NTSC bottom-top field order, the CSI would swap fields and
> capture in top-bottom order.
> 
> Instead, base field swap on the field order of the input to the CSI,
> and the field order of the requested output. If the input/output
> fields are sequential but different, swap fields, otherwise do
> not swap. This requires passing both the input and output mbus
> frame formats to ipu_csi_init_interface().
> 
> Move this code to a new private function ipu_csi_set_bt_interlaced_codes()
> that programs the CCIR_CODE_1/2 registers for interlaced BT.656 (and
> possibly interlaced BT.1120 in the future).
> 
> When detecting input video standard from the input frame width/height,
> make sure to double height if input field type is alternate, since
> in that case input height only includes lines for one field.
> 
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

Also
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
to be merged via the media tree

regards
Philipp
