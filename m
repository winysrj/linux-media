Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50566 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbZCIXnk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 19:43:40 -0400
Date: Mon, 9 Mar 2009 20:43:08 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alain Kalker <miki@dds.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: Improve DKMS build of v4l-dvb?
Message-ID: <20090309204308.10c9afc6@pedra.chehab.org>
In-Reply-To: <1236612894.5982.72.camel@miki-desktop>
References: <1236612894.5982.72.camel@miki-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 09 Mar 2009 16:34:54 +0100
Alain Kalker <miki@dds.nl> wrote:

> I'm interested in improving the very interesting work[1] by Martin
> Pitt[2] on making the v4l-dvb tree build under DKMS[3], so the drivers
> get automatically rebuilt when the user installs a new kernel package.
> 
> Martin also works on the Jockey driver manager[4] which is used in
> Ubuntu to detect hardware for which there are no drivers in the kernel
> and to inform the user about available driver packages which can then be
> downloaded and installed automatically.
> 
> Enabling DKMS build of v4l-dvb will also enable users with no experience
> in building kernel modules to easily install the latest development
> drivers for their hardware. This will improve the exposure of v4l-dvb
> drivers to a wider community of users who can help with testing the
> drivers on the wide variety of hardware that is out there.
> 
> Martin has an older version of the drivers packaged for building with
> DKMS on Ubuntu in his PPA[5], but it currently has some disadvantages:
> 
> A. It builds all available drivers, no matter which hardware is actually
> installed in the system. This takes a lot of time, and may not be
> practical at all on systems with limited resources (e.g. embedded, MIDs,
> netbooks)
> B. It currently has no support for Jockey to detect installed hardware,
> so individual drivers can be selected.
> 
> To address these issues, I would like to propose the following:
> 
> A. Building individual drivers (i.e. sets of modules which constitute a
> fully-functional driver), without having to manually configure them
> using "make menuconfig"
> 
> I see two possibilities for realizing this:
> Firstly: generating a .config with just one config variable for the
> requested driver set to 'm' merged with the config for the kernel being
> built for, and then doing a "make silentoldconfig". Big disatvantage is
> that full kernel source is required for the 'silentoldconfig' target to
> be available. 
> Secondly, the script v4l/scripts/analyze_build.pl generates a list of
> modules that will get built for each Kconfig variable selected, but it
> currently has no way of determing all the module dependencies that make
> up a fully functional driver.
> The script v4l/scripts/check_deps.pl tries to discover dependencies
> between Kconfig variables, but it currently is somewhat slow, and hase a
> few other problems.
> 
> B. To enable hardware autodetection before installing drivers, we need
> to have a list of modaliases of all supported hardware. This may be the
> hardest part, because many VendorIDs and ProductIDs are scattered
> throughout the code. Also coldbooting/warmbooting hardware is a problem.
> 
> I am very interested in any comments on these ideas, and getting in
> contact with anyone who would like to help me with this project.

It is not that hard. You'll have a few vars that will always have the same values, like:

CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_GSPCA=m
CONFIG_RADIO_ADAPTERS=y
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y
CONFIG_MEDIA_TUNER=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_GSPCA=m
CONFIG_RADIO_ADAPTERS=y
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y
# CONFIG_DAB is not set

You should also be sure that the helper chips will be auto-selected, with those
three options:

CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
# MEDIA_TUNER_CUSTOMIZE is not set
# CONFIG_DVB_FE_CUSTOMISE is not set

Then, all you need, in order to support an specific board is to add the
driver-specific Kconfig, like (for cx88):

CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_CX88_VP3054=m

Of course, you'll need to write some script to identify what devices are
available at the host (by USB or PCI ID), and associate it with the V4L/DVB
drivers.

Probably, the hardest part is to maintain, so, ideally, the scripts should scan
the source codes to check what drivers you have, and what are the driver
options associated with that device.

If you can write such script, then we can add it at v4l/scripts and add a
"make myconfig" option that would run the script and compile the minimal set of
drivers.

> 
> Kind regards,
> 
> Alain
> 
> [1]
> http://martinpitt.wordpress.com/2008/06/10/packaged-dvb-t-drivers-for-ubuntu-804/
> [2] https://launchpad.net/~pitti
> [3] http://linux.dell.com/projects.shtml#dkms
> [4] https://launchpad.net/jockey
> [5] https://launchpad.net/~pitti/+archive/ppa
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
