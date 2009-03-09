Return-path: <linux-media-owner@vger.kernel.org>
Received: from rotring.dds.nl ([85.17.178.138]:40309 "EHLO rotring.dds.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbZCIPfD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2009 11:35:03 -0400
Received: from localhost (localhost [127.0.0.1])
	by rotring.dds.nl (Postfix) with ESMTP id 5D592272CD5
	for <linux-media@vger.kernel.org>; Mon,  9 Mar 2009 16:34:59 +0100 (CET)
Received: from [192.168.1.222] (cc941058-b.ensch1.ov.home.nl [82.74.126.12])
	by rotring.dds.nl (Postfix) with ESMTP id 52251272CCE
	for <linux-media@vger.kernel.org>; Mon,  9 Mar 2009 16:34:53 +0100 (CET)
Subject: Improve DKMS build of v4l-dvb?
From: Alain Kalker <miki@dds.nl>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Mon, 09 Mar 2009 16:34:54 +0100
Message-Id: <1236612894.5982.72.camel@miki-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm interested in improving the very interesting work[1] by Martin
Pitt[2] on making the v4l-dvb tree build under DKMS[3], so the drivers
get automatically rebuilt when the user installs a new kernel package.

Martin also works on the Jockey driver manager[4] which is used in
Ubuntu to detect hardware for which there are no drivers in the kernel
and to inform the user about available driver packages which can then be
downloaded and installed automatically.

Enabling DKMS build of v4l-dvb will also enable users with no experience
in building kernel modules to easily install the latest development
drivers for their hardware. This will improve the exposure of v4l-dvb
drivers to a wider community of users who can help with testing the
drivers on the wide variety of hardware that is out there.

Martin has an older version of the drivers packaged for building with
DKMS on Ubuntu in his PPA[5], but it currently has some disadvantages:

A. It builds all available drivers, no matter which hardware is actually
installed in the system. This takes a lot of time, and may not be
practical at all on systems with limited resources (e.g. embedded, MIDs,
netbooks)
B. It currently has no support for Jockey to detect installed hardware,
so individual drivers can be selected.

To address these issues, I would like to propose the following:

A. Building individual drivers (i.e. sets of modules which constitute a
fully-functional driver), without having to manually configure them
using "make menuconfig"

I see two possibilities for realizing this:
Firstly: generating a .config with just one config variable for the
requested driver set to 'm' merged with the config for the kernel being
built for, and then doing a "make silentoldconfig". Big disatvantage is
that full kernel source is required for the 'silentoldconfig' target to
be available. 
Secondly, the script v4l/scripts/analyze_build.pl generates a list of
modules that will get built for each Kconfig variable selected, but it
currently has no way of determing all the module dependencies that make
up a fully functional driver.
The script v4l/scripts/check_deps.pl tries to discover dependencies
between Kconfig variables, but it currently is somewhat slow, and hase a
few other problems.

B. To enable hardware autodetection before installing drivers, we need
to have a list of modaliases of all supported hardware. This may be the
hardest part, because many VendorIDs and ProductIDs are scattered
throughout the code. Also coldbooting/warmbooting hardware is a problem.

I am very interested in any comments on these ideas, and getting in
contact with anyone who would like to help me with this project.

Kind regards,

Alain

[1]
http://martinpitt.wordpress.com/2008/06/10/packaged-dvb-t-drivers-for-ubuntu-804/
[2] https://launchpad.net/~pitti
[3] http://linux.dell.com/projects.shtml#dkms
[4] https://launchpad.net/jockey
[5] https://launchpad.net/~pitti/+archive/ppa

