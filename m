Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:58233 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbZCMJMI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 05:12:08 -0400
Date: Fri, 13 Mar 2009 02:12:04 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Alain Kalker <miki@dds.nl>
cc: linux-media@vger.kernel.org
Subject: Re: Improve DKMS build of v4l-dvb?
In-Reply-To: <1236612894.5982.72.camel@miki-desktop>
Message-ID: <Pine.LNX.4.58.0903130153220.28292@shell2.speakeasy.net>
References: <1236612894.5982.72.camel@miki-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 9 Mar 2009, Alain Kalker wrote:
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

Does that actually work?  Figuring out that needs to be turned on to enable
some config options is a hard problem.  It's not just simple dependencies
between modules, but complex expressions that need to be satisfied.  E.g.,
something "depends on A || B", which do you turn on, A or B?  There are
multiple solutions so how does the code decide which is best?

> Secondly, the script v4l/scripts/analyze_build.pl generates a list of
> modules that will get built for each Kconfig variable selected, but it
> currently has no way of determing all the module dependencies that make
> up a fully functional driver.

I just wrote analyze_build.pl to make it easier for developers to figure
out that source files make up a module and how to enable it.  It's not
actually used by the build system.  It's also not perfect when it comes to
parsing makefiles, i.e. it no where near a re-implementation of make's
parser in perl.  It understands the typical syntax used by the kernel
makefiles but sometimes there is some unusual bit of make code that it
won't parse.

> The script v4l/scripts/check_deps.pl tries to discover dependencies
> between Kconfig variables, but it currently is somewhat slow, and hase a
> few other problems.

That it is!  It's not totally perfect either.  Sometimes a driver will only
depend on another if something is turned on.  But the way check_deps.pl
works won't know that.  There are also lots of Kconfig variables that don't
turn on a module but instead modify what a module does or are used for
menus.  I think a better system would be use the dependencies in the
Kconfig files instead of trying to figure them out from the source.

> B. To enable hardware autodetection before installing drivers, we need
> to have a list of modaliases of all supported hardware. This may be the
> hardest part, because many VendorIDs and ProductIDs are scattered
> throughout the code. Also coldbooting/warmbooting hardware is a problem.

Extract that from the compiled modules should be easy.
