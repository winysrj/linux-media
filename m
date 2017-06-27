Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:33236 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751553AbdF0JO0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 05:14:26 -0400
Date: Tue, 27 Jun 2017 02:14:23 -0700
From: Tony Lindgren <tony@atomide.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Jyri Sarha <jsarha@ti.com>
Subject: Re: [PATCH 1/8] arm: omap4: enable CEC pin for Pandaboard A4 and ES
Message-ID: <20170627091421.GZ3730@atomide.com>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-2-hverkuil@xs4all.nl>
 <4355dab4-9c70-77f7-f89b-9a1cf24976cf@ti.com>
 <20170626110711.GW3730@atomide.com>
 <701dbbfa-000a-2b93-405b-246aa90b6dd6@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <701dbbfa-000a-2b93-405b-246aa90b6dd6@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Hans Verkuil <hverkuil@xs4all.nl> [170627 01:39]:
> On 26/06/17 13:07, Tony Lindgren wrote:
> > Tomi,
> > 
> > * Tomi Valkeinen <tomi.valkeinen@ti.com> [170428 04:15]:
> >> On 14/04/17 13:25, Hans Verkuil wrote:
> >>> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>>
> >>> The CEC pin was always pulled up, making it impossible to use it.
> > ...
> > 
> >> Tony, can you queue this? It's safe to apply separately from the rest of
> >> the HDMI CEC work.
> > 
> > So the dts changes are merged now but what's the status of the CEC driver
> > changes? Were there some issues as I don't see them in next?
> 
> Tomi advised me to wait until a 'hotplug-interrupt-handling series' for the
> omap driver is merged to prevent conflicts. Last I heard (about 3 weeks ago)
> this was still pending review.

OK thanks for the update.

Adding Jyri to Cc, hopefully the CEC support allows also setting the
HDMI audio volume level on devices implementing it? Or am I too
optimistic? :)

> Tomi, any updates on this? It would be nice to get this in for 4.14.

Yeah seems like we have real mainline kernel user needs for this one.

Regards,

Tony
