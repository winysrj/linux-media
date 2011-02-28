Return-path: <mchehab@pedra>
Received: from mga01.intel.com ([192.55.52.88]:36732 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab1B1AN1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 19:13:27 -0500
Date: Mon, 28 Feb 2011 01:13:24 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>,
	alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	lrg@slimlogic.co.uk, hverkuil@xs4all.nl,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v19 0/3] TI Wl1273 FM radio driver.
Message-ID: <20110228001323.GB2749@sortiz-mobl>
References: <1297757626-3281-1-git-send-email-matti.j.aaltonen@nokia.com>
 <4D5ADB38.4070600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5ADB38.4070600@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Tue, Feb 15, 2011 at 05:59:52PM -0200, Mauro Carvalho Chehab wrote:
> Em 15-02-2011 06:13, Matti J. Aaltonen escreveu:
> > Hello.
> > 
> > Now I've refactored the code so that the I2C I/O functions are in the 
> > MFD core. Also now the codec can be compiled without compiling the V4L2
> > driver.
> > 
> > I haven't implemented the audio routing (yet), but I've added a TODO
> > comment about it in the codec file.
> 
> Matti,
> 
> It looks ok on my eyes. As most of the changes is at the V4L part, it is
> probably better to merge this patch via my tree.
I'm fine with that, yes. I'll add my Acked-by once Matti has fixed the minor
issues I found.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
