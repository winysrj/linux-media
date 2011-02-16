Return-path: <mchehab@pedra>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49747 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758338Ab1BPCCD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Feb 2011 21:02:03 -0500
Date: Tue, 15 Feb 2011 18:02:18 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: alsa-devel@alsa-project.org, lrg@slimlogic.co.uk,
	mchehab@redhat.com, hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v19 3/3] ASoC: WL1273 FM radio: Access I2C IO functions
 through pointers.
Message-ID: <20110216020217.GB3021@opensource.wolfsonmicro.com>
References: <1297757626-3281-1-git-send-email-matti.j.aaltonen@nokia.com>
 <1297757626-3281-2-git-send-email-matti.j.aaltonen@nokia.com>
 <1297757626-3281-3-git-send-email-matti.j.aaltonen@nokia.com>
 <1297757626-3281-4-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297757626-3281-4-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Feb 15, 2011 at 10:13:46AM +0200, Matti J. Aaltonen wrote:

>  	if (core->i2s_mode != mode) {
> -		r = wl1273_fm_write_cmd(core, WL1273_I2S_MODE_CONFIG_SET, mode);
> +		r = core->write(core, WL1273_I2S_MODE_CONFIG_SET, mode);

I'm having a hard time loving the replacement of the function with the
direct dereference from the struct but overall this is a good win so:

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
