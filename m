Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:46318 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2DBMY7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 08:24:59 -0400
Message-ID: <4F799A99.9010209@mlbassoc.com>
Date: Mon, 02 Apr 2012 06:24:57 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: OMAP3ISP won't start
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm testing Laurent's tree with the BT656 support.  My system
has an OMAP/3530 + TVP5150 running in BT656 mode.  Sadly, this
isn't working - I only get an endless stream of these messages
   [   43.457427] omap3isp omap3isp: CCDC won't become idle!
   [   43.490814] omap3isp omap3isp: CCDC won't become idle!

I've compared the operation between a similarly patched 3.2 system
and the current 3.3.  All OMAP3 CCDC registers are identical,
as well as the TVP5150 registers at the time that streaming
is enabled.

Any ideas what might be wrong?  where else to look?

Thanks

Just to be clear - I did have to make a few patches to both the
TVP5150 driver and CCDC part of OMAP3ISP as some of the BT656
support is still not in Laurent's tree.  I'll send patches, etc,
once I get it working, but as mentioned above, at least at the
register level, these are set up the same as in my working tree.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
