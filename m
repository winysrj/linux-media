Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38734 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751494AbdECTGM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 May 2017 15:06:12 -0400
Date: Wed, 3 May 2017 20:05:56 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        abcloriens@gmail.com, linux-media@vger.kernel.org,
        khilman@kernel.org, tony@atomide.com, aaro.koskinen@iki.fi,
        kernel list <linux-kernel@vger.kernel.org>, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        pali.rohar@gmail.com, linux-omap@vger.kernel.org,
        patrikbachan@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        serge@hallyn.com
Subject: Re: [patch] autogain support for bayer10 format (was Re: [patch]
 propagating controls in libv4l2)
Message-ID: <20170503190556.GT23750@n2100.armlinux.org.uk>
References: <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 26, 2017 at 06:43:54PM +0300, Ivaylo Dimitrov wrote:
> >+static int get_luminosity_bayer10(uint16_t *buf, const struct v4l2_format *fmt)
> >+{
> >+	long long avg_lum = 0;
> >+	int x, y;
> >+	
> >+	buf += fmt->fmt.pix.height * fmt->fmt.pix.bytesperline / 4 +
> >+		fmt->fmt.pix.width / 4;
> >+
> >+	for (y = 0; y < fmt->fmt.pix.height / 2; y++) {
> >+		for (x = 0; x < fmt->fmt.pix.width / 2; x++)
> 
> That would take some time :). AIUI, we have NEON support in ARM kernels
> (CONFIG_KERNEL_MODE_NEON), I wonder if it makes sense (me) to convert the
> above loop to NEON-optimized when it comes to it? Are there any drawbacks in
> using NEON code in kernel?

Using neon without the VFP state saved and restored corrupts userspace's
FP state.  So, you have to save the entire VFP state to use neon in kernel
mode.  There are helper functions for this: kernel_neon_begin() and
kernel_neon_end().

You can't build C code with the compiler believing that neon is available
as the compiler could emit neon instructions in unprotected kernel code.

Note that kernel_neon_begin() is only allowed to be called outside
interrupt context and with preemption disabled.

Given that, do we really want to be walking over multi-megabytes of image
data in the kernel with preemption disabled - it sounds like a recipe for
a very sluggish system.  I think this should (and can only sensibly be
done) in userspace.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
