Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 485C6C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 17:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1764F20823
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 17:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfCZROG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 13:14:06 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40411 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfCZROG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 13:14:06 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1h8peH-00088a-4D; Tue, 26 Mar 2019 18:14:05 +0100
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1h8peG-0005UD-10; Tue, 26 Mar 2019 18:14:04 +0100
Date:   Tue, 26 Mar 2019 18:14:04 +0100
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Michael Tretter <m.tretter@pengutronix.de>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dshah@xilinx.com, mchehab@kernel.org, robh+dt@kernel.org,
        kernel@pengutronix.de, tfiga@chromium.org
Subject: Re: [PATCH v4 0/3] Add ZynqMP VCU/Allegro DVT H.264 encoder driver
Message-ID: <20190326171403.aj7wp5yn6gugkdky@pengutronix.de>
References: <20190301152718.23134-1-m.tretter@pengutronix.de>
 <20190326084613.405e7ed4@litschi.hi.pengutronix.de>
 <484d66c6-a2c0-6c18-6cdf-81ef647295e3@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <484d66c6-a2c0-6c18-6cdf-81ef647295e3@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

On Tue, Mar 26, 2019 at 12:47:38PM +0100, Hans Verkuil wrote:
> On 3/26/19 8:46 AM, Michael Tretter wrote:
> > On Fri, 01 Mar 2019 16:27:15 +0100, Michael Tretter wrote:
> >> This is v4 of the series to add support for the Allegro DVT H.264 encoder
> >> found in the EV family of the Xilinx ZynqMP platform.
> > 
> > Ping.
> 
> It's delegated to me in patchwork, so I'll get to it in a few days.
> 
> We were waiting for the 5.1-rc1 release.

There is a misunderstanding somewhere here. We have 5.1-rc2 since
Sunday and 5.1-rc1 since Sunday the week before. What am I missing?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
