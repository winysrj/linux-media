Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:42327 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab1JPI5r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Oct 2011 04:57:47 -0400
Date: Sun, 16 Oct 2011 10:57:31 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Piotr Chmura <chmooreck@poczta.onet.pl>
Cc: Greg KH <gregkh@suse.de>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/7] Staging submission: PCTV 74e driver (as102)
Message-ID: <20111016105731.09d66f03@stein>
In-Reply-To: <4E99F2FC.5030200@poczta.onet.pl>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
	<20110927213300.6893677a@stein>
	<4E999733.2010802@poczta.onet.pl>
	<4E99F2FC.5030200@poczta.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 15 Piotr Chmura wrote:
> Staging submission: PCTV 74e driver (as102)
> 
> From: Devin Heitmueller<dheitmueller@kernellabs.com>
> 
> pull as102 driver from
> 
> This is driver for PCTV 74e DVB-T USB tuner, taken from [1],
> written by Devin Heitmueller using the GPL reference driver provided by Abilis.
> 
> The only change needed to compile it in current git tree [2]
> was changing calls usb_buffer_alloc() and usb_buffer_free() to
> usb_alloc_coherent() and usb_free_coherent(). It's included in this patch.
> 
> Patch was tested by me on amd64.
> 
> [1]http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
> [2] git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git kernel-3.1.0-git9+
> 
> Signed-off-by: Piotr Chmura<chmooreck@poczta.onet.pl>
> Cc: Devin Heitmueller<dheitmueller@kernellabs.com>
> Cc: Greg HK<gregkh@suse.de>
> 
> diff -Nur linux.clean/drivers/staging/as102/as102_drv.c linux.as102_initial/drivers/staging/as102/as102_drv.c
> --- linux.clean/drivers/staging/as102/as102_drv.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux.as102_initial/drivers/staging/as102/as102_drv.c	2011-10-14 17:55:02.000000000 +0200
> @@ -0,0 +1,360 @@
> +/*
> + * Abilis Systems Single DVB-T Receiver
> + * Copyright (C) 2008 Pierrick Hascoet<pierrick.hascoet@abilis.com>
> + * Copyright (C) 2010 Devin Heitmueller<dheitmueller@kernellabs.com>

Hi Piotr,

thanks for getting this going again.  - I have not yet looked through the
source but have some small remarks on the patch format.

  - In your changelogs and in the diffs, somehow the space between real
    name and e-mail address got lost.

  - The repetition of the Subject: line as first line in the changelog is
    unnecessary (and would cause an undesired duplication e.g. when git-am
    is used, last time I checked).

  - AFAICT, author of patch 1/7 is not Devin but you.  Hence the From: line
    right above the changelog is wrong.

  - The reference to the source hg tree is very helpful.  However, since
    the as102 related history in there is very well laid out, it may be
    beneficial to quote some of this prior history.  I suggest, include
    the changelog of "as102: import initial as102 driver",
    http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/rev/a78bda1e1a0b
    (but mark it clearly as a quote from the out-of-tree repo), and include
    a shortlog from this commit inclusive until the head commit inclusive.
    (Note, the hg author field appears to be wrong; some of the changes
    apparently need to be attributed to Pierrick Hascoet as author.)
    This would IMO improve the picture of who contributed what when this
    goes into mainline git history, even though the hg history needed to
    be discarded.

  - A diffstat is always very nice to have in a patch posting.  Most tools
    for patch generation make it easy to add, and it helps the recipients
    of the patch posting.
    (Also, a diffstat of all patches combined would be good to have in the
    introductory PATCH 0/n posting, but not many developers take the time
    to do so.)

Again, thanks for the effort and also thanks to Devin for making it
possible.
-- 
Stefan Richter
-=====-==-== =-=- =----
http://arcgraph.de/sr/
