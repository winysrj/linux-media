Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:40781 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973Ab1I0HHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 03:07:49 -0400
Subject: Re: [PATCH v3 4/4] OMAP_VOUT: Don't trigger updates in
 omap_vout_probe
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Archit Taneja <archit@ti.com>
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Semwal, Sumit" <sumit.semwal@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <4E81750F.7060200@ti.com>
References: <1317038365-30650-1-git-send-email-archit@ti.com>
	 <1317038365-30650-5-git-send-email-archit@ti.com>
	 <1317103833.1991.6.camel@deskari>  <4E81750F.7060200@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 10:07:41 +0300
Message-ID: <1317107261.1991.18.camel@deskari>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-09-27 at 12:32 +0530, Archit Taneja wrote:
> On Tuesday 27 September 2011 11:40 AM, Valkeinen, Tomi wrote:
> > On Mon, 2011-09-26 at 17:29 +0530, Archit Taneja wrote:
> >> Remove the code in omap_vout_probe() which calls display->driver->update() for
> >> all the displays. This isn't correct because:
> >>
> >> - An update in probe doesn't make sense, because we don't have any valid content
> >>    to show at this time.
> >> - Calling update for a panel which isn't enabled is not supported by DSS2. This
> >>    leads to a crash at probe.
> >
> > Calling update() on a disabled panel should not crash... Where is the
> > crash coming from?
> 
> you are right, the crash isn't coming from the updates. I see the crash 
> when we have 4 dss devices in our board file. The last display pointer 
> is corrupted in that case. I'm trying to figure out why.

Could be totally unrelated, but does the V4L2 driver make sure that the
used dss devices have a driver loaded?

OMAPFB previously refused to start if all the devices do not have a
driver, but nowadays it starts fine by skipping the devices without a
driver.

 Tomi


