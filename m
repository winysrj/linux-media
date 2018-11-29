Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:51108 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728255AbeK3Eww (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 23:52:52 -0500
Received: by mail-it1-f196.google.com with SMTP id z7so4964943iti.0
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2018 09:46:42 -0800 (PST)
MIME-Version: 1.0
References: <1543502916-21632-1-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1543502916-21632-1-git-send-email-jacopo+renesas@jmondi.org>
From: Adam Ford <aford173@gmail.com>
Date: Thu, 29 Nov 2018 11:46:29 -0600
Message-ID: <CAHCN7xKSDXqk=J7ZbeXonci0OVoRdnPtb=QCZUm=mNoBQxeR5g@mail.gmail.com>
Subject: Re: [PATCH 0/2] media: ov5640: MIPI fixes on top of Maxime's v5
To: jacopo+renesas@jmondi.org
Cc: maxime.ripard@bootlin.com, sam@elite-embedded.com,
        Steve Longerbeam <slongerbeam@gmail.com>, mchehab@kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org, hugues.fruchet@st.com,
        loic.poulain@linaro.org, daniel@zonque.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 29, 2018 at 8:48 AM Jacopo Mondi <jacopo+renesas@jmondi.org> wrote:
>
> Hello ov5640-ers,
>    these two patches should be applied on top of Maxime's clock tree rework v5
> and 'fix' MIPI CSI-2 clock tree configuration.
>
> The first patch is a fix that appeard in various forms on the list several
> times: if the image sizes gets updated but not the image format, the size
> update gets ignored. I had to fix this to run my FPS tests, and thus I'm
> sending the two together. I wish in future a re-work of the image format
> handling part, but for now, let's just fix it for v4.21.
>
> The second patch slightly reworks the MIPI clock tree configuration, based on
> inputs from Sam. The currently submitted v5 in which Maxime squashed my previous
> changes is 'broken'. That's my bad, as explained in the patch change log.
>
> Test results are attacched to patch [2/2].
> Changelog for [2/2] is included in the patch itself.
>
> I wish these patches to go in with Maxime awesome clock tree re-work, pending
> his ack.
>
> Also, I have tested with an i.MX6Q board, with a CSI-2 2 data lanes setup. There
> are still a few things not clear to me in the MIPI clock tree, and I welcome
> more testing, preferibly with 1-lanes setups.
>
> Also, I had to re-apply Maxime's series and latest ov5640 patches on v4.19,
> as my test board is sort of broken with v4.20-rcX (it shouldn't make any
> difference in regard to this series, but I'm pointing it out anyhow).

Greg KH is pulling in some of the first round of fixes to the 4.19.y
branch.  If they're working, we may want to consider having Greg Apply
these there as well.

>
> Recently Adam has been testing quite some ov5640 patches, if you fill like
> testing these as well on your setup (which I understand is a MIPI CSI-2 one)
> please report the results. Same for all other interested ones :)

You are correct, I have an i.MX6 with CSI2 interface.  I'll test
against 4.20-RCx and my 4.19 version with some of the newer patches
pulled down.  I will try to get to these before Monday.

adam

>
> Thanks
>   j
>
> Jacopo Mondi (2):
>   media: i2c: ov5640: Fix set format regression
>   media: ov5640: make MIPI clock depend on mode
>
>  drivers/media/i2c/ov5640.c | 110 ++++++++++++++++++++++-----------------------
>  1 file changed, 54 insertions(+), 56 deletions(-)
>
> --
> 2.7.4
>
