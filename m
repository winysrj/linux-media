Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50375 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828Ab2CBDpy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2012 22:45:54 -0500
Received: by iagz16 with SMTP id z16so1746831iag.19
        for <linux-media@vger.kernel.org>; Thu, 01 Mar 2012 19:45:54 -0800 (PST)
Date: Thu, 1 Mar 2012 21:45:45 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Jarod Wilson <jarod@redhat.com>,
	Torsten Crass <torsten.crass@eBiology.de>
Subject: Re: [PATCH 1/5] staging: lirc_serial: Fix init/exit order
Message-ID: <20120302034545.GA31860@burratino>
References: <1321422581.2885.50.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321422581.2885.50.camel@deadeye>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ben,

Ben Hutchings wrote[1]:

> Currently the module init function registers a platform_device and
> only then allocates its IRQ and I/O region.  This allows allocation to
> race with the device's suspend() function.  Instead, allocate
> resources in the platform driver's probe() function and free them in
> the remove() function.
>
> The module exit function removes the platform device before the
> character device that provides access to it.  Change it to reverse the
> order of initialisation.
>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> The down-side of this is that module insertion now succeeds even if the
> device can't be probed.  But that's how most driver modules work, and
> there will be obvious error messages logged on failure.

>From <http://bugs.debian.org/645811> I see that you tested these patches:

 affc9a0d59ac [media] staging: lirc_serial: Do not assume error codes
              returned by request_irq()
 9b98d6067971 [media] staging: lirc_serial: Fix bogus error codes
 1ff1d88e8629 [media] staging: lirc_serial: Fix deadlock on resume failure
 c8e57e1b766c [media] staging: lirc_serial: Free resources on failure
              paths of lirc_serial_probe()
 9105b8b20041 [media] staging: lirc_serial: Fix init/exit order

in a VM.  They were applied in 3.3-rc1 and have been in the Debian
kernel since 3.1.4-1 at the end of November.

Would some of these patches (e.g., at least patches 1, 2, and 5) be
appropriate for inclusion in the 3.0.y and 3.2.y stable kernels from
kernel.org?

Thanks,
Jonathan

[1] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/40486
