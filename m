Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF844C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 11:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97B96217F9
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 11:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730752AbfAILQ3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 06:16:29 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39735 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730111AbfAILQ2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 06:16:28 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ghBqV-0003Xf-F1; Wed, 09 Jan 2019 12:16:27 +0100
Message-ID: <1547032586.4160.3.camel@pengutronix.de>
Subject: Re: [PATCH v6 12/12] media: imx.rst: Update doc to reflect fixes to
 interlaced capture
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 09 Jan 2019 12:16:26 +0100
In-Reply-To: <20190109001551.16113-13-slongerbeam@gmail.com>
References: <20190109001551.16113-1-slongerbeam@gmail.com>
         <20190109001551.16113-13-slongerbeam@gmail.com>
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
> Also add an example pipeline for unconverted capture with interweave
> on SabreAuto.
> 
> Cleanup some language in various places in the process.
> 
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
