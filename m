Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 438D9C282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 09:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04AA9218DA
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 09:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfAVJ6T (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 04:58:19 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57193 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbfAVJ6T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 04:58:19 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1glsoz-00081s-Ab; Tue, 22 Jan 2019 10:58:17 +0100
Message-ID: <1548151096.3929.1.camel@pengutronix.de>
Subject: Re: [PATCH v3 1/2] media: imx: csi: Disable SMFC before disabling
 IDMA channel
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Gael PORTAY <gael.portay@collabora.com>,
        Peter Seiderer <ps.report@gmx.net>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 22 Jan 2019 10:58:16 +0100
In-Reply-To: <12937f2b-e25e-6cc5-0727-59a5e6224fd9@gmail.com>
References: <20190119010457.2623-1-slongerbeam@gmail.com>
         <20190119010457.2623-2-slongerbeam@gmail.com>
         <1548071350.3287.3.camel@pengutronix.de>
         <7432d18b-12fc-34c6-832f-576fc1b8e2e8@gmail.com>
         <12937f2b-e25e-6cc5-0727-59a5e6224fd9@gmail.com>
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

On Mon, 2019-01-21 at 10:46 -0800, Steve Longerbeam wrote:
> 
> On 1/21/19 10:43 AM, Steve Longerbeam wrote:
> > 
> > 
> > On 1/21/19 3:49 AM, Philipp Zabel wrote:
> > > Also ipu_smfc_disable is refcounted, so if the other CSI is capturing
> > > simultaneously, this change has no effect.
> > 
> > Sigh, you're right. Let me go back to disabling the CSI before the 
> > channel, the CSI enable/disable is not refcounted (it doesn't need to 
> > be since it is single use) so it doesn't have this problem.
> > 
> > Should we drop this patch or keep it (with a big comment)? By only 
> > changing the disable order to "CSI then channel", the hang is reliably 
> > fixed from my and Gael's testing, but my concern is that by not 
> > disabling the SMFC before the channel, the SMFC could still empty its 
> > FIFO to the channel's internal FIFO and still create a hang.
> 
> Well, as you said it will have no effect if both CSI's are streaming 
> with the SMFC, in which case the danger would still exist. Perhaps it 
> would be best to just drop this patch.

Hm, if we can't guarantee the intended effect with this patch, and
stopping the CSI first helps reliably, it's indeed better to just do
that instead.

regards
Philipp
