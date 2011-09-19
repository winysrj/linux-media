Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:58719 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab1ISPO0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 11:14:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] misc: remove CONFIG_MISC_DEVICES
Date: Mon, 19 Sep 2011 17:14:18 +0200
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Jean Delvare <khali@linux-fr.org>,
	Luciano Coelho <coelho@ti.com>, matti.j.aaltonen@nokia.com,
	johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
	sameo@linux.intel.com, mchehab@infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Tony Lindgren <tony@atomide.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net> <2282172.TF7nejTDIZ@wuerfel> <20110919130755.GA9829@kroah.com>
In-Reply-To: <20110919130755.GA9829@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109191714.18334.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 19 September 2011, Greg KH wrote:
> That sounds good to me, I'll be glad to collect the patches and push
> them to Linus for both of those trees (might as well keep them in the
> same git tree, no need to separate them, right?) and I'll rely on you
> for review and acking them.  Much like I do today for the tty and serial
> trees.
> 
> I'll go set up the trees locally today and when kernel.org opens back
> up, make them public and add them to linux-next.

Ok, great!

Thanks,

	Arnd
