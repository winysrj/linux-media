Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39654 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751488AbdDRKUE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 06:20:04 -0400
Date: Tue, 18 Apr 2017 13:19:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        mchehab@kernel.org, linux-media@vger.kernel.org
Subject: Re: et8ek8 camera on Nokia N900: trying to understand what is going
 on with modes
Message-ID: <20170418101929.GG7456@valkosipuli.retiisi.org.uk>
References: <20170412211159.GA2313@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170412211159.GA2313@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Wed, Apr 12, 2017 at 11:11:59PM +0200, Pavel Machek wrote:
> Hi!
> 
> 5Mpix mode does not work on N900, which is something I'd like to
> understand. et8ek8_mode contains huge tables of register settings and
> parameter values, but it seems that they are not really independend.
> 
> To test that theory, I started with checking values against each
> other.
> 
> This is the work so far, it is neither complete nor completely working
> at the moment. Perhaps someone wants to play...

You might seek to try lowering the pixel clock on the sensor to see whether
it makes any difference. I don't think there's been any changes to how the
sensor is programmed since the original software was shipped with the
device. That doesn't apply to the SoC and the clock tree in the SoC however.
I wonder if there could be changes in clock frequencies and how the ISP is
clocked. The omap3isp driver has changed heavily as well.

Just my 5 Euro cents (they have no smaller coins around here).

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
