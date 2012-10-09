Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61610 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab2JIUuG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 16:50:06 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so5600996pad.19
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2012 13:50:06 -0700 (PDT)
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: paul@pwsan.com, laurent.pinchart@ideasonboard.com,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 1/2] omap3: Provide means for changing CSI2 PHY configuration
References: <20120926215001.GA14107@valkosipuli.retiisi.org.uk>
	<1348696236-3470-1-git-send-email-sakari.ailus@iki.fi>
Date: Tue, 09 Oct 2012 13:50:04 -0700
In-Reply-To: <1348696236-3470-1-git-send-email-sakari.ailus@iki.fi> (Sakari
	Ailus's message of "Thu, 27 Sep 2012 00:50:35 +0300")
Message-ID: <87zk3vz7yb.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Sakari Ailus <sakari.ailus@iki.fi> writes:

> The OMAP 3630 has configuration how the ISP CSI-2 PHY pins are connected to
> the actual CSI-2 receivers outside the ISP itself. Allow changing this
> configuration from the ISP driver.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

These control module registers (CSIRXFE, CAMERA_PHY_CTRL) are in the
CORE powerdomain, so they will be lost during off-mode transitions.  So,
I suspect you'll also want to add them to the save/restore functions in
control.c in order for this to work across off-mode transitions.

Kevin
