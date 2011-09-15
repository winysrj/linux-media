Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30875 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934046Ab1IOPnf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 11:43:35 -0400
Date: Thu, 15 Sep 2011 17:46:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jean Delvare <khali@linux-fr.org>, Luciano Coelho <coelho@ti.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	matti.j.aaltonen@nokia.com, johannes@sipsolutions.net,
	linux-kernel@vger.kernel.org, mchehab@infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Tony Lindgren <tony@atomide.com>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] mfd: remove CONFIG_MFD_SUPPORT
Message-ID: <20110915154611.GF32263@sortiz-mobl>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net>
 <201108311849.37273.arnd@arndb.de>
 <20110902143713.307bbebe@endymion.delvare>
 <201109021643.36369.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109021643.36369.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Fri, Sep 02, 2011 at 04:43:36PM +0200, Arnd Bergmann wrote:
> We currently have two symbols to control compilation the MFD subsystem,
> MFD_SUPPORT and MFD_CORE. The MFD_SUPPORT is actually not required
> at all, it only hides the submenu when not set, with the effect that
> Kconfig warns about missing dependencies when another driver selects
> an MFD driver while MFD_SUPPORT is disabled. Turning the MFD submenu
> back from menuconfig into a plain menu simplifies the Kconfig syntax
> for those kinds of users and avoids the surprise when the menu
> suddenly appears because another driver was enabled that selects this
> symbol.
So I applied this one, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
