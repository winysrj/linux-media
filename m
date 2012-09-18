Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:54213 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab2IRJOM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 05:14:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 12/34] media: mx1_camera: remove the driver
Date: Tue, 18 Sep 2012 09:13:54 +0000
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1347860103-4141-1-git-send-email-shawn.guo@linaro.org> <Pine.LNX.4.64.1209171031010.1689@axis700.grange> <20120918012848.GE1338@S2101-09.ap.freescale.net>
In-Reply-To: <20120918012848.GE1338@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209180913.54835.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 18 September 2012, Shawn Guo wrote:
> 
> On Mon, Sep 17, 2012 at 10:33:25AM +0200, Guennadi Liakhovetski wrote:
> > Ok, it used to compile not-so-long-ago, but it doesn't seem to be cared 
> > for a lot lately. Let's give Paulius a bit more time to react to this 
> > mail, otherwise I'll have no objections. Just as an idea, to make it a bit 
> > milder we could first mark it BROKEN and add to remove schedule... But I 
> > don't mind either way.
> > 
> I chose to remove the driver completely rather than marking it BROKEN
> because the removal of the driver cleans up platform code a lot :)
> 
> Ok, if we hear anything back from Paulius in the next couple of weeks,
> I keep the driver there with BROKEN marked.

Sounds fine to me. Of course, if someone wants the driver back and is
willing to fix it, we'll just revert this patch even after the driver
is gone.

I would like an Ack from Mauro however. You did not Cc him directly
in the patch, and he probably has an opionion on it as well, or may
want to take this patch through his git tree.

	Arnd
