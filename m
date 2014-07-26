Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.uli-eckhardt.de ([85.214.28.137]:41815 "EHLO
	mail.uli-eckhardt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751448AbaGZRrD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 13:47:03 -0400
Message-ID: <53D3E991.9040006@uli-eckhardt.de>
Date: Sat, 26 Jul 2014 19:46:57 +0200
From: Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: jarod@wilsonet.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] [media] imon: Fix internal key table for 15c2:0034
References: <53247996.7050303@uli-eckhardt.de> <20140723175537.0e9e5541.m.chehab@samsung.com>
In-Reply-To: <20140723175537.0e9e5541.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 23.07.2014 22:55, schrieb Mauro Carvalho Chehab:

This patchset contains the changes required to get the front panel 
of the Thermaltake DH102 to work, including the incorporated review 
comments from my first patch (also reverted the while loops).

The internal key table does not contain the correct definitions. Some of the 
key table entries required for this device are conflicting with existing 
ones. So I had to extend the code to allow to define a key table for 
each USB id.

The first patch of this patchset contains the changes required to
specify key tables per USB id. The second patch contains the key table
changes for the DH102. And the last patch contains a bugfix that the
panel keys does not work when a key on the remote was pressed.
-- 
Ulrich Eckhardt                  http://www.uli-eckhardt.de

Ein Blitzableiter auf dem Kirchturm ist das denkbar stärkste 
Misstrauensvotum gegen den lieben Gott. (Karl Krauss)
