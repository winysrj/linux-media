Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39797 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab0DMQTg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Apr 2010 12:19:36 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1O1ipq-0000iO-U9
	for linux-media@vger.kernel.org; Tue, 13 Apr 2010 18:19:34 +0200
Received: from nemi.mork.no ([148.122.252.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 13 Apr 2010 18:19:34 +0200
Received: from bjorn by nemi.mork.no with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 13 Apr 2010 18:19:34 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: mantis crashes
Date: Tue, 13 Apr 2010 18:19:21 +0200
Message-ID: <87ochne35i.fsf@nemi.mork.no>
References: <20100413150153.GB11631@mail.tyldum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Vidar Tyldum Hansen <vidar@tyldum.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Vidar Tyldum Hansen <vidar@tyldum.com> writes:

> Hello list,
>
> I am having issues with my TerraTec Cinergy C DVB-C, described in detail
> here: https://bugzilla.kernel.org/show_bug.cgi?id=15750
>
> The essence is that machine would reboot or hang at random intervals if
> the card is actively used (mythtv or tvheadend running for instance).
> Just loading the mantis module and let the card idle does not trigger
> anything.

Does the 2.6.31-20-generic Ubuntu kernel come bundled with the mantis
driver, or did you build this yourself?  If so, from where and which
version?

AFAIK, mantis wasn't included in mainline until 2.6.33.  I've just filed
a wishlist bug for Debian's 2.6.32 so I'd really be interested in any
Ubuntu work on this...

> I am trying to figure out if this is a driver or hardware issue, and by
> enabling more verbose logging on the mantis module I ended up with the
> syslog output attached to the bug report. It shows binary garbage and
> function calls for parts of the kernel not in use by the machine in
> question right before the crash occurred.
>
> I have not been able to find a different card to test with yet.
>
> So, based on this, is it possible to conclude whom to blame for the
> crash?

FWIW I have exactly the same card with no such problems observed.  I am
using a standard Debian 2.6.32-4-amd64 kernel with mantis driver taken
from vanilla 2.6.34-rc4 (after patching mantis-input.c to compensate for
the recent ir layer changes).  This is also what I submitted to Debian
in the wishlist bug report.


Bjørn

