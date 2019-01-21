Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C174BC2F441
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 16:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99E6120663
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 16:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbfAUQ7D (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 11:59:03 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47127 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729459AbfAUQ7D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 11:59:03 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1glcua-0007lw-Sd; Mon, 21 Jan 2019 17:59:00 +0100
Message-ID: <1548089940.3287.19.camel@pengutronix.de>
Subject: Re: [PATCH 4/4] media: imx: Don't register IPU subdevs/links if CSI
 port missing
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 21 Jan 2019 17:59:00 +0100
In-Reply-To: <20190119214600.30897-5-slongerbeam@gmail.com>
References: <20190119214600.30897-1-slongerbeam@gmail.com>
         <20190119214600.30897-5-slongerbeam@gmail.com>
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

On Sat, 2019-01-19 at 13:46 -0800, Steve Longerbeam wrote:
> The second IPU internal sub-devices were being registered and links
> to them created even when the second IPU is not present. This is wrong
> for i.MX6 S/DL and i.MX53 which have only a single IPU.
> 
> Fixes: e130291212df5 ("[media] media: Add i.MX media core driver")
> 
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
