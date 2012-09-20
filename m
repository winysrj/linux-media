Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43418 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab2ITBfO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 21:35:14 -0400
Received: by pbbrr13 with SMTP id rr13so3850784pbb.19
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2012 18:35:13 -0700 (PDT)
Date: Thu, 20 Sep 2012 09:35:09 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 12/34] media: mx1_camera: remove the driver
Message-ID: <20120920013507.GD2450@S2101-09.ap.freescale.net>
References: <1347860103-4141-1-git-send-email-shawn.guo@linaro.org>
 <Pine.LNX.4.64.1209171031010.1689@axis700.grange>
 <20120918012848.GE1338@S2101-09.ap.freescale.net>
 <201209180913.54835.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209180913.54835.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 18, 2012 at 09:13:54AM +0000, Arnd Bergmann wrote:
> On Tuesday 18 September 2012, Shawn Guo wrote:
> > 
> > On Mon, Sep 17, 2012 at 10:33:25AM +0200, Guennadi Liakhovetski wrote:
> > > Ok, it used to compile not-so-long-ago, but it doesn't seem to be cared 
> > > for a lot lately. Let's give Paulius a bit more time to react to this 
> > > mail, otherwise I'll have no objections. Just as an idea, to make it a bit 
> > > milder we could first mark it BROKEN and add to remove schedule... But I 
> > > don't mind either way.
> > > 
> > I chose to remove the driver completely rather than marking it BROKEN
> > because the removal of the driver cleans up platform code a lot :)
> > 
> > Ok, if we hear anything back from Paulius in the next couple of weeks,
> > I keep the driver there with BROKEN marked.
> 
> Sounds fine to me. Of course, if someone wants the driver back and is
> willing to fix it, we'll just revert this patch even after the driver
> is gone.
> 
> I would like an Ack from Mauro however. You did not Cc him directly
> in the patch, and he probably has an opionion on it as well, or may
> want to take this patch through his git tree.
> 
I've seen Guennadi is collecting camera patches and sending them to
Mauro recently.  So I think Guennadi is someone that Mauro trusts.
But yes, we should copy him directly to see if he has an opionion on
this driver removal.

Shawn
