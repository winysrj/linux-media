Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C111C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 09:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2666521917
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 09:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfBHJOo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 04:14:44 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41365 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727169AbfBHJOo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 04:14:44 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gs2F8-0005WT-Tk; Fri, 08 Feb 2019 10:14:42 +0100
Message-ID: <1549617281.3305.0.camel@pengutronix.de>
Subject: Re: [PATCH 4/4] media: imx-pxp: Start using the format VUYA32
 instead of YUV32
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Vivek Kasireddy <vivek.kasireddy@intel.com>,
        linux-media@vger.kernel.org
Date:   Fri, 08 Feb 2019 10:14:41 +0100
In-Reply-To: <20190208031846.14453-5-vivek.kasireddy@intel.com>
References: <20190208031846.14453-1-vivek.kasireddy@intel.com>
         <20190208031846.14453-5-vivek.kasireddy@intel.com>
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

On Thu, 2019-02-07 at 19:18 -0800, Vivek Kasireddy wrote:
> Buffers generated with YUV32 format seems to be incorrect, hence use
> VUYA32 instead.
> 
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>

Thanks!

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

