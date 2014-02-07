Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:57444 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755610AbaBGM2v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 07:28:51 -0500
Date: Fri, 7 Feb 2014 12:28:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Daniel Vetter <daniel@ffwll.ch>, devel@driverdev.osuosl.org,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Takashi Iwai <tiwai@suse.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 26/46] drivers/base: provide an infrastructure for
	componentised subsystems
Message-ID: <20140207122832.GA26684@n2100.arm.linux.org.uk>
References: <20140102212528.GD7383@n2100.arm.linux.org.uk> <E1Vypo6-0007FF-Lb@rmk-PC.arm.linux.org.uk> <CAKMK7uFYhz8Pmv5E7aKY7yzZGDe_m8a0382Njv7tZRoBSfmRpw@mail.gmail.com> <20140207094656.GY26684@n2100.arm.linux.org.uk> <20140207125721.2d925387@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207125721.2d925387@armhf>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 07, 2014 at 12:57:21PM +0100, Jean-Francois Moine wrote:
> I started to use your code (which works fine, thanks), and it avoids a
> lot of problems, especially, about probe_defer in a DT context.
> 
> I was wondering if your componentised mechanism could be extended to the
> devices defined by DT.

It was developed against imx-drm, which is purely DT based.  I already
have a solution for the cubox armada DRM.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
