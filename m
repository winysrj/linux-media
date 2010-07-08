Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:43998 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571Ab0GHJf2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Jul 2010 05:35:28 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OWnVr-00078R-80
	for linux-media@vger.kernel.org; Thu, 08 Jul 2010 11:35:23 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 08 Jul 2010 11:35:23 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 08 Jul 2010 11:35:23 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: The mantis driver is now in Debian
Date: Thu, 08 Jul 2010 11:35:10 +0200
Message-ID: <87sk3u1fld.fsf@nemi.mork.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just a FYI: Thanks to the excellent Debian kernel team, the mantis
driver (backported from linux 2.6.34) is now included in Debian kernel
images starting with version 2.6.32-16.  This means that mantis based
cards will work out of the box in the next stable Debian release,
"squeeze".

This info should probably go into the assorted wiki-pages with all sorts
of outdated documentation on how to download and build the driver, but
I'm not nuch of a wiki writer.  I prefer putting it here for Google to
find... 

I addition to the Debian kernel team, I owe a big thanks to those of you
who have written the driver, helped pushing it upstream, and continue to
support it.  Thank you!



Bjørn

