Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52744 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753386Ab2JIWdp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Oct 2012 18:33:45 -0400
Date: Wed, 10 Oct 2012 01:33:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: paul@pwsan.com, laurent.pinchart@ideasonboard.com,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 1/2] omap3: Provide means for changing CSI2 PHY
 configuration
Message-ID: <20121009223340.GM14107@valkosipuli.retiisi.org.uk>
References: <20120926215001.GA14107@valkosipuli.retiisi.org.uk>
 <1348696236-3470-1-git-send-email-sakari.ailus@iki.fi>
 <87zk3vz7yb.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zk3vz7yb.fsf@deeprootsystems.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kevin,

Thanks for the comments!

On Tue, Oct 09, 2012 at 01:50:04PM -0700, Kevin Hilman wrote:
> Hi Sakari,
> 
> Sakari Ailus <sakari.ailus@iki.fi> writes:
> 
> > The OMAP 3630 has configuration how the ISP CSI-2 PHY pins are connected to
> > the actual CSI-2 receivers outside the ISP itself. Allow changing this
> > configuration from the ISP driver.
> >
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> These control module registers (CSIRXFE, CAMERA_PHY_CTRL) are in the
> CORE powerdomain, so they will be lost during off-mode transitions.  So,
> I suspect you'll also want to add them to the save/restore functions in
> control.c in order for this to work across off-mode transitions.

I've got another patch that implements this in the ISP driver instead.

<URL:http://www.spinics.net/lists/linux-media/msg54781.html>

The ISP also can't wake up the MPU from the off mode, so I don't think
losing the register contents is necessarily an issue. The registers will be
written to a new value whenever streaming is started. Perhaps adding a note
about that would be worthwhile.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
