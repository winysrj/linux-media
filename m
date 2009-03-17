Return-path: <linux-media-owner@vger.kernel.org>
Received: from rotring.dds.nl ([85.17.178.138]:47888 "EHLO rotring.dds.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbZCQPaG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 11:30:06 -0400
Subject: Re: Improve DKMS build of v4l-dvb?
From: Alain Kalker <miki@dds.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0903130153220.28292@shell2.speakeasy.net>
References: <1236612894.5982.72.camel@miki-desktop>
	 <Pine.LNX.4.58.0903130153220.28292@shell2.speakeasy.net>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 16:29:58 +0100
Message-Id: <1237303798.5988.27.camel@miki-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op vrijdag 13-03-2009 om 02:12 uur [tijdzone -0700], schreef Trent
Piepho: 
> On Mon, 9 Mar 2009, Alain Kalker wrote:
> > Martin has an older version of the drivers packaged for building with
> > DKMS on Ubuntu in his PPA[5], but it currently has some disadvantages:
> >
> > A. It builds all available drivers, no matter which hardware is actually
> > installed in the system. This takes a lot of time, and may not be
> > practical at all on systems with limited resources (e.g. embedded, MIDs,
> > netbooks)
> > B. It currently has no support for Jockey to detect installed hardware,
> > so individual drivers can be selected.
> >
> > To address these issues, I would like to propose the following:
> >
> > A. Building individual drivers (i.e. sets of modules which constitute a
> > fully-functional driver), without having to manually configure them
> > using "make menuconfig"
> >
> > I see two possibilities for realizing this:
> > Firstly: generating a .config with just one config variable for the
> > requested driver set to 'm' merged with the config for the kernel being
> > built for, and then doing a "make silentoldconfig". Big disatvantage is
> > that full kernel source is required for the 'silentoldconfig' target to
> > be available.
> 
> Does that actually work?  Figuring out that needs to be turned on to enable
> some config options is a hard problem.  It's not just simple dependencies
> between modules, but complex expressions that need to be satisfied.  E.g.,
> something "depends on A || B", which do you turn on, A or B?  There are
> multiple solutions so how does the code decide which is best?

Well, make_kconfig.pl does quite a nice job trying to select as many
drivers without causing conflicts.

Anyway, you're quite right about this being a hard problem, and the
fact that the Kconfig system wasn't designed to be very helpful in
auto-selecting dependencies and resolving conflicts the same way modern
package managers are, doesn't make it any easier.

For the moment, I would suggest either to choose a default which works
for most people, or ask the user (using any Kconfig menu tool, if only
they didn't need write access to the kernel source, grrr!) to choose
among alternatives if no combination of options can be selected
automatically.

> > Secondly, the script v4l/scripts/analyze_build.pl generates a list of
> > modules that will get built for each Kconfig variable selected, but it
> > currently has no way of determing all the module dependencies that make
> > up a fully functional driver.
> 
> I just wrote analyze_build.pl to make it easier for developers to figure
> out that source files make up a module and how to enable it.  It's not
> actually used by the build system.  It's also not perfect when it comes to
> parsing makefiles, i.e. it no where near a re-implementation of make's
> parser in perl.  It understands the typical syntax used by the kernel
> makefiles but sometimes there is some unusual bit of make code that it
> won't parse.

Nice work! I've been using it a lot while testing. I expect to use it
also in a tool which will work like 'modinfo', except using module
source files as input. I plan to add some nice extensions like showing
the config options which enable a module, symbolic DeviceID/VendorID,
values, etc.

Kind regards,

Alain

