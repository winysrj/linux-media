Return-path: <mchehab@pedra>
Received: from mga09.intel.com ([134.134.136.24]:34358 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab1A3XYD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Jan 2011 18:24:03 -0500
Date: Mon, 31 Jan 2011 00:23:59 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	lrg@slimlogic.co.uk, mchehab@redhat.com, hverkuil@xs4all.nl,
	linux-media@vger.kernel.org
Subject: Re: WL1273 FM Radio driver...
Message-ID: <20110130232358.GD2565@sortiz-mobl>
References: <1295363063.25951.67.camel@masi.mnp.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1295363063.25951.67.camel@masi.mnp.nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Matti,

On Tue, Jan 18, 2011 at 05:04:23PM +0200, Matti J. Aaltonen wrote:
> Hello
> 
> I have been trying to get the WL1273 FM radio driver into the kernel for
> some time. It has been kind of difficult, one of the reasons is that I
> didn't realize I should have tried to involve all relevant maintainers
> to the discussion form the beginning (AsoC, Media and MFD). At Mark's
> suggestion I'm trying to reopen the discussion now.
> 
> The driver consists of an MFD core and two child drivers (the audio
> codec and the V4L2 driver). And the question is mainly about the role of
> the MFD driver: the original design had the IO functions in the core.
> Currently the core is practically empty mainly because Mauro very
> strongly wanted to have “everything” in the V4L2 driver.
What was Mauro main concerns with having the IO part in the core ?
A lot of MFD drivers are going that path already.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
