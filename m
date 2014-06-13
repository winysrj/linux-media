Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44135 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaFMVIF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 17:08:05 -0400
Date: Fri, 13 Jun 2014 23:07:58 +0200
From: Philipp Zabel <pza@pengutronix.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH 12/30] [media] coda: Add runtime pm support
Message-ID: <20140613210758.GA29487@pengutronix.de>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
 <1402675736-15379-13-git-send-email-p.zabel@pengutronix.de>
 <539B2D30.8080301@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539B2D30.8080301@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Fri, Jun 13, 2014 at 06:56:16PM +0200, Sylwester Nawrocki wrote:
[...]
> > @@ -3394,10 +3406,29 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
> >  	memcpy(dev->codebuf.vaddr, fw->data, fw->size);
> >  	release_firmware(fw);
> >  
> > -	ret = coda_hw_init(dev);
> > -	if (ret) {
> > -		v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
> > -		return;
> > +	if (IS_ENABLED(CONFIG_PM_RUNTIME) && pdev->dev.pm_domain) {
> 
> How about using the pm_runtime_enabled() helper ? Also why do you need to
> be checking dev.pm_domain here and in the resume() callback ? Couldn't it 
> be done unconditionally ? Why the driver needs to care about the PM domain
> existence ?

Thank you for the hint, pm_runtime_enabled() is what I want here.

The idea with the pm_domain check was that without an associated pm_domain
there is no need to do the hardware initialization over and over again.
So if PM_RUNTIME is enabled, but no pm_domain is associated with the device,
we call hw_init only once, and not on every runtime_resume.
The hardware initialization on coda mostly consists of a 4KiB firmware upload
into the code SRAM via an upload register, and a reset of the DSP processor.

regards
Philipp
