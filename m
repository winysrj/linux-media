Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35961 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752225AbcKNMSn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 07:18:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mark Brown <broonie@kernel.org>
Cc: Todor Tomov <todor.tomov@linaro.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, hverkuil@xs4all.nl, geert@linux-m68k.org,
        matrandg@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v6 2/2] media: Add a driver for the ov5645 camera sensor.
Date: Mon, 14 Nov 2016 14:18:49 +0200
Message-ID: <7012441.uVkdQjEznh@avalon>
In-Reply-To: <20161026115149.GD17252@sirena.org.uk>
References: <1473326035-25228-1-git-send-email-todor.tomov@linaro.org> <5810931B.4070101@linaro.org> <20161026115149.GD17252@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mark,

On Wednesday 26 Oct 2016 12:51:49 Mark Brown wrote:
> On Wed, Oct 26, 2016 at 02:27:23PM +0300, Todor Tomov wrote:
> > And using Mark Brown's correct address...
> 
> This is an *enormous* e-mail quoted to multiple levels with top posting
> and very little editing which makes it incredibly hard to find any
> relevant content.
> 
> > >> I believe it should be an API guarantee, otherwise many drivers using
> > >> the bulk API would break. Mark, could you please comment on that ?
> > > 
> > > Ok, let's wait for a response from Mark.
> 
> Why would this be guaranteed by the API given that it's not documented
> and why would many drivers break?  It's fairly rare for devices other
> than SoCs to have strict power on sequencing requirements as it is hard
> to achieve in practical systems.

I'm surprised, I've always considered the bulk regulator API as guaranteeing 
sequencing, and have written quite a few drivers with that assumption. If 
that's not correct then I'll have to switch them back to manual regulator 
handling.

Is there a reason why the API shouldn't guarantee that regulators are powered 
on in the order listed, and powered off in the reverse order ? Looking at the 
implementation that's already the case for regulator_bulk_disable(), but 
regulator_bulk_enable() uses async scheduling so doesn't guarantee ordering. I 
wonder whether a synchronous version of regulator_bulk_enable() would be 
useful.

-- 
Regards,

Laurent Pinchart

