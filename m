Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750995AbeBVGNr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 01:13:47 -0500
Date: Thu, 22 Feb 2018 14:13:38 +0800
From: Shawn Guo <shawnguo@kernel.org>
To: Tim Harvey <tharvey@gateworks.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v13 7/8] ARM: dts: imx: Add TDA19971 HDMI Receiver to
 GW54xx
Message-ID: <20180222061336.GI3217@dragon>
References: <1518717336-6271-1-git-send-email-tharvey@gateworks.com>
 <1518717336-6271-8-git-send-email-tharvey@gateworks.com>
 <7732637c-93bf-fac2-5553-695782890254@xs4all.nl>
 <CAJ+vNU3G9bJ16npp22O=7k72Pf3xSuQxW-CA2p5cbDq-nSZ4ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU3G9bJ16npp22O=7k72Pf3xSuQxW-CA2p5cbDq-nSZ4ew@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 15, 2018 at 01:19:17PM -0800, Tim Harvey wrote:
> On Thu, Feb 15, 2018 at 10:36 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On 15/02/18 18:55, Tim Harvey wrote:
> >> The GW54xx has a front-panel microHDMI connector routed to a TDA19971
> >> which is connected the the IPU CSI when using IMX6Q.
> >
> > I assume that this and the next patch go through another subsystem for arm
> > and/or imx?
> >
> > Regards,
> >
> >         Hans
> >
> 
> Hans,
> 
> Yes - Shawn should pick up the two dts patches:
> 0007-ARM-dts-imx-Add-TDA19971-HDMI-Receiver-to-GW54xx.patch
> 0008-ARM-dts-imx-Add-TDA19971-HDMI-Receiver-to-GW551x.patch
> 
> Shawn you've seen these before but haven't ack'd them - are they good
> to merge to your imx tree?

Yes.  I will pick up the dts patches after Hans merges driver part.

Shawn
