Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C03CC2F421
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 15:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C09E20823
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 15:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbfAUPVF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 10:21:05 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55450 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729732AbfAUPVF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 10:21:05 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gportay)
        with ESMTPSA id 5BF5E2639D0
Date:   Mon, 21 Jan 2019 10:21:08 -0500
From:   =?utf-8?B?R2HDq2w=?= PORTAY <gael.portay@collabora.com>
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org, Peter Seiderer <ps.report@gmx.net>,
        stable@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] media: imx: csi: Disable SMFC before disabling
 IDMA channel
Message-ID: <20190121152107.gruavvgkabwokvnz@archlinux.localdomain>
References: <20190119010457.2623-1-slongerbeam@gmail.com>
 <20190119010457.2623-2-slongerbeam@gmail.com>
 <1548071350.3287.3.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1548071350.3287.3.camel@pengutronix.de>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Philipp,

On Mon, Jan 21, 2019 at 12:49:10PM +0100, Philipp Zabel wrote:
> Hi,
> 
> On Fri, 2019-01-18 at 17:04 -0800, Steve Longerbeam wrote:
> > Disable the SMFC before disabling the IDMA channel, instead of after,
> > in csi_idmac_unsetup().
> > 
> > This fixes a complete system hard lockup on the SabreAuto when streaming
> > from the ADV7180, by repeatedly sending a stream off immediately followed
> > by stream on:
> > 
> > while true; do v4l2-ctl  -d4 --stream-mmap --stream-count=3; done
> > 
> > Eventually this either causes the system lockup or EOF timeouts at all
> > subsequent stream on, until a system reset.
> > 
> > The lockup occurs when disabling the IDMA channel at stream off. Stopping
> > the video data stream entering the IDMA channel before disabling the
> > channel itself appears to be a reliable fix for the hard lockup. That can
> > be done either by disabling the SMFC or the CSI before disabling the
> > channel. Disabling the SMFC before the channel is the easiest solution,
> > so do that.
> > 
> > Fixes: 4a34ec8e470cb ("[media] media: imx: Add CSI subdev driver")
> > 
> > Suggested-by: Peter Seiderer <ps.report@gmx.net>
> > Reported-by: Gaël PORTAY <gael.portay@collabora.com>
> > Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> 
> Gaël, could we get a Tested-by: for this as well?
>

I have not tested the v3 yet. I have planned to do it later this day for
a all night testing and report the result then.

Gael
