Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:54225 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960Ab1I0GKj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 02:10:39 -0400
Subject: Re: [PATCH v3 4/4] OMAP_VOUT: Don't trigger updates in
 omap_vout_probe
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Archit Taneja <archit@ti.com>
Cc: hvaibhav@ti.com, linux-omap@vger.kernel.org, sumit.semwal@ti.com,
	linux-media@vger.kernel.org
In-Reply-To: <1317038365-30650-5-git-send-email-archit@ti.com>
References: <1317038365-30650-1-git-send-email-archit@ti.com>
	 <1317038365-30650-5-git-send-email-archit@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 09:10:33 +0300
Message-ID: <1317103833.1991.6.camel@deskari>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2011-09-26 at 17:29 +0530, Archit Taneja wrote:
> Remove the code in omap_vout_probe() which calls display->driver->update() for
> all the displays. This isn't correct because:
> 
> - An update in probe doesn't make sense, because we don't have any valid content
>   to show at this time.
> - Calling update for a panel which isn't enabled is not supported by DSS2. This
>   leads to a crash at probe.

Calling update() on a disabled panel should not crash... Where is the
crash coming from?

 Tomi


