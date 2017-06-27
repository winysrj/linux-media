Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:34082 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751513AbdF0KG6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 06:06:58 -0400
Date: Tue, 27 Jun 2017 03:06:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Jyri Sarha <jsarha@ti.com>
Subject: Re: [PATCH 1/8] arm: omap4: enable CEC pin for Pandaboard A4 and ES
Message-ID: <20170627100654.GA3730@atomide.com>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-2-hverkuil@xs4all.nl>
 <4355dab4-9c70-77f7-f89b-9a1cf24976cf@ti.com>
 <20170626110711.GW3730@atomide.com>
 <701dbbfa-000a-2b93-405b-246aa90b6dd6@xs4all.nl>
 <20170627091421.GZ3730@atomide.com>
 <1d970218-d24a-d460-7d95-b31102d735f2@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d970218-d24a-d460-7d95-b31102d735f2@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Hans Verkuil <hverkuil@xs4all.nl> [170627 02:27]:
> On 27/06/17 11:14, Tony Lindgren wrote:
> > Adding Jyri to Cc, hopefully the CEC support allows also setting the
> > HDMI audio volume level on devices implementing it? Or am I too
> > optimistic? :)
> 
> I'm not quite sure what you mean. Do you want CEC to change the volume on the
> TV, or use the TV's remote to change the volume of the HDMI audio output of the
> omap4?

I'm hoping to change audio volume on a USB+HDMI lapdock from omap4.

> Anyway, either is supported, but it requires a userspace implementation.
> 
> Although TV remote control messages will be mapped to an input device, and if
> those are hooked up to the alsa audio volume, then this already works.

OK great thanks,

Tony
