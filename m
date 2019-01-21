Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7420C2F421
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 16:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCCAF21019
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 16:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbfAUQaK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 11:30:10 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39699 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbfAUQaJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 11:30:09 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1glcSd-0004Tw-Im; Mon, 21 Jan 2019 17:30:07 +0100
Message-ID: <1548088207.3287.11.camel@pengutronix.de>
Subject: Re: [PATCH v2 1/3] media: dt-bindings: media: document allegro-dvt
 bindings
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Michael Tretter <m.tretter@pengutronix.de>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     mchehab@kernel.org, robh+dt@kernel.org, kernel@pengutronix.de,
        tfiga@chromium.org
Date:   Mon, 21 Jan 2019 17:30:07 +0100
In-Reply-To: <26befa99cb1ddb0c36823cb573f2012d4bd98015.camel@ndufresne.ca>
References: <20190118133716.29288-1-m.tretter@pengutronix.de>
         <20190118133716.29288-2-m.tretter@pengutronix.de>
         <1548068375.3287.1.camel@pengutronix.de>
         <26befa99cb1ddb0c36823cb573f2012d4bd98015.camel@ndufresne.ca>
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

On Mon, 2019-01-21 at 11:17 -0500, Nicolas Dufresne wrote:
[...]
> > > +Example:
> > > +	al5e: al5e@a0009000 {
> > 
> > Should the node names be "vpu" or "video-codec"?
> 
> Xilinx calls this IP the "vcu", so "vpu" would be even more confusing.
> Was this just a typo ?

I was just going by what is already commonly used in other device trees.
Given that "vpu" doesn't seem to be as universally accepted as for
example "gpu", maybe "video-codec" is the better choice?

In any case, it should not matter what the the IP vendor or the SoC
vendor call this, the node name should be common and descriptive of its
function, same as ethernet controller nodes should be called "ethernet".

> That being said, is this referring to the actual
> HW or the firmware that runs on a microblaze (the firmware being
> Allegro specific) ?

As I understand it this binding is referring to the whole [microblaze +
attached encoder/decoder hardware] setup that is supposed to work with
the Allegro specific firmware.

regards
Philipp
