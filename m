Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53321 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbcD2NjR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 09:39:17 -0400
Date: Fri, 29 Apr 2016 15:39:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 12/24] dt: bindings: Add CSI1/CCP2 related properties
 to video-interfaces.txt
Message-ID: <20160429133914.GD21251@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1461532104-24032-13-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1461532104-24032-13-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 2016-04-25 00:08:12, Ivaylo Dimitrov wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Document the CSI1/CCP2 properties strobe_clk_inv and strobe_clock
> properties. The former tells whether the strobe/clock signal is inverted,
> while the latter signifies the clock or strobe mode.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index f5b61bd..f0523f7 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -114,9 +114,10 @@ Optional endpoint properties
>    lane and followed by the data lanes in the same order as in data-lanes.
>    Valid values are 0 (normal) and 1 (inverted). The length of the array
>    should be the combined length of data-lanes and clock-lanes properties.
> -  If the lane-polarities property is omitted, the value must be interpreted
> -  as 0 (normal). This property is valid for serial busses only.
> -
> +- clock-inv: Clock or strobe signal inversion.
> +  Possible values: 0 -- not inverted; 1 -- inverted

I'd do "clock-inverted". And probably dt people need to be cc-ed on
this one.

> +- strobe: Whether the clock signal is used as clock or strobe. Used
> +  with CCP2, for instance.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
