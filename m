Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:55500 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbcBWOND (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 09:13:03 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp2.macqel.be (Postfix) with ESMTP id 59679168B57
	for <linux-media@vger.kernel.org>; Tue, 23 Feb 2016 15:13:00 +0100 (CET)
Received: from smtp2.macqel.be ([127.0.0.1])
	by localhost (mail.macqel.be [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MagpIeveuQtL for <linux-media@vger.kernel.org>;
	Tue, 23 Feb 2016 15:12:58 +0100 (CET)
Received: from frolo.macqel.be (frolo.macqel [10.1.40.73])
	by smtp2.macqel.be (Postfix) with ESMTP id 884B3168B4B
	for <linux-media@vger.kernel.org>; Tue, 23 Feb 2016 15:12:58 +0100 (CET)
Date: Tue, 23 Feb 2016 15:12:58 +0100
From: Philippe De Muyter <phdm@macq.eu>
To: linux-media@vger.kernel.org
Subject: Re: i.mx6 camera interface (CSI) and mainline kernel
Message-ID: <20160223141258.GA5097@frolo.macqel>
References: <20160223114943.GA10944@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160223114943.GA10944@frolo.macqel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update.

On Tue, Feb 23, 2016 at 12:49:43PM +0100, Philippe De Muyter wrote:
> Hello,
> 
> We use a custom imx6 based board with a canera sensor on it.
> I have written the driver for the camera sensor, based on
> the freescale so-called "3.10" and even "3.14" linux versions.
> 
> The camera works perfectly, but we would like to switch to
> a mainline kernel for all the usual reasons (including being
> able to contribute our fixes).
> 
> >From an old mail thread (*), I have found two git repositories
> that used to contain not-yet-approved versions of mainline
> imx6 ipu-v3 drivers :
> 
> git://git.pengutronix.de/git/pza/linux.git test/nitrogen6x-ipu-media
> https://github.com:slongerbeam/mediatree.git, mx6-camera-staging
> 
> I have tried to compile them with the imx_v6_v7_defconfig, but both
> fail directly at compile time. because of later changes in the
> v4l2_subdev infrastructure, not ported to the those branches.

What I wrote is true for Steve Longerbeam's branch, but for Philipp Zabel's
branch the problem (so far) was only that CONFIG_MEDIA_CONTROLLER
is not defined in imx_v6_v7_defconfig, but is required for a succesfull
compilation of Philipp's tree.

> Can someone point me to compilable versions (either not rebased
> versions of those branches, or updated versions of those branches,
> or yet another place to look at). ?
> 
> Thanks in advance
> 
> Philippe
> 
> (*) http://linux-media.vger.kernel.narkive.com/cZQ8NrZ2/i-mx6-status-for-ipu-vpu-gpu
> 
> -- 
> Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
