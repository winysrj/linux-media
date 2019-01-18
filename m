Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E893DC43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 16:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1F1A2086D
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 16:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfARQvV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 11:51:21 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44849 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbfARQvU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 11:51:20 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gkXMU-00008M-0b; Fri, 18 Jan 2019 17:51:18 +0100
Message-ID: <1547830276.3375.20.camel@pengutronix.de>
Subject: Re: [PATCH v7] media: imx: add mem2mem device
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Date:   Fri, 18 Jan 2019 17:51:16 +0100
In-Reply-To: <1547810284.3375.6.camel@pengutronix.de>
References: <20190117155032.3317-1-p.zabel@pengutronix.de>
         <e68a4de5-a499-ea02-20e7-79e4d175708c@xs4all.nl>
         <1547810284.3375.6.camel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, 2019-01-18 at 12:18 +0100, Philipp Zabel wrote:
> Hi Hans,
> 
> On Fri, 2019-01-18 at 10:30 +0100, Hans Verkuil wrote:
> > On 1/17/19 4:50 PM, Philipp Zabel wrote:
> 
> [...]
> > > +
> > > +static const struct video_device ipu_csc_scaler_videodev_template = {
> > > +	.name		= "ipu0_ic_pp mem2mem",
> > 
> > I would expect to see something like 'imx-media-csc-scaler' as the name.
> > Wouldn't that be more descriptive?
> 
> Yes, thank you. I'll change this as well.

Actually, this is overwritten a few lines later anyway:

       snprintf(vfd->name, sizeof(vfd->name), "ipu_ic_pp mem2mem");

Not that it makes a difference. But I noticed that I chose this name for
something close to consistency with the other IPU devices:

$ cat /sys/class/video4linux/video*/name
ipu_ic_pp mem2mem
coda-encoder
coda-decoder
ipu1_ic_prpenc capture
ipu1_ic_prpvf capture
ipu2_ic_prpenc capture
ipu2_ic_prpvf capture
ipu1_csi0 capture
ipu1_csi1 capture
ipu2_csi0 capture
ipu2_csi1 capture

They all start with the IPU / subdevice (/ IC task) prefix.
Maybe "ipu_ic_pp csc/scaler" would be more appropriate?

regards
Philipp
