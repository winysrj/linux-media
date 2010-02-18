Return-path: <linux-media-owner@vger.kernel.org>
Received: from proxy2.bredband.net ([195.54.101.72]:60488 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab0BRKZQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 05:25:16 -0500
Received: from ipb2.telenor.se (195.54.127.165) by proxy2.bredband.net (7.3.140.3)
        id 4AD3E1BC03914F54 for linux-media@vger.kernel.org; Thu, 18 Feb 2010 11:04:35 +0100
Message-ID: <b13e649a0061e6efbfc91c6a8c7b57f4.squirrel@mail.kurelid.se>
In-Reply-To: <4B782CCA.3010903@s5r6.in-berlin.de>
References: <4B782CCA.3010903@s5r6.in-berlin.de>
Date: Thu, 18 Feb 2010 11:04:33 +0100
Subject: Re: How to add DVB-S2 support to firedtv?
From: "Henrik Kurelid" <henke@kurelid.se>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: linux-media@vger.kernel.org, "Ben Backx" <ben@bbackx.com>,
	"Henrik Kurelid" <henrik@kurelid.se>,
	"Beat Michel Liechti" <bml303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Regarding the documentation and code:
>From a quick glance, the LNB/QPSK2 code follows the documentation fairly good.
I guess it could do with a deeper check (I could see that at least the FEC switch case does seems to have some invalid values) but I would prefer
that this is done by someone that actually has a DVB-S(2) card.

Regards,
Henrik

> Hi all,
>
> what steps need to be taken to get DVB-S2 support into the firedtv
> driver?  (The status is, as far as I understood:  FireDTV S2 and Floppy
> DTV S2 devices recognize HD channels during channel scan but cannot tune
> to them.  FireDTV C/CI DVB-C boxes however tune and play back HD
> channels just fine.)
>
> I suppose the frontend needs to be extended for s2api.  Was there a
> respective conversion in another DVB driver that can serve as a good
> coding example?
>
> Is documentation from Digital Everywhere required regarding the
> vendor-specific AV/C requests (LNB_CONTROL? TUNE_QPSK2?) or is the
> current driver code enough to connect the dots?
>
> Is the transport stream different from DVB-C HD streams so that changes
> to the isochronous I/O part would be required?
> --
> Stefan Richter
> -=====-==-=- --=- -===-
> http://arcgraph.de/sr/
>

