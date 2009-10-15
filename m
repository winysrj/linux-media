Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.viadmin.org ([195.145.128.101]:58840 "EHLO www.viadmin.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757351AbZJOKp4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2009 06:45:56 -0400
Date: Thu, 15 Oct 2009 12:45:09 +0200
From: "H. Langos" <henrik-dvb@prak.org>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] request driver for cards
Message-ID: <20091015104509.GO6384@www.viadmin.org>
References: <23582ca0910140607v54a15d46y7ac834a3b6255af3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23582ca0910140607v54a15d46y7ac834a3b6255af3@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 14, 2009 at 03:07:00PM +0200, Theunis Potgieter wrote:
> Hi, what is the procedure to request drivers for specific new, perhaps
> unknown supported cards?

The "procedure" is to hit google with something 
like "linux <vendor> <model>" and see what you find. :-)

Especially links to mailing list archives like linux-media and linux-dvb
are worth a read.


> Perhaps I shouldn't waste time if I could find a dual/twin tuner card for
> dvb-s or dvb-s2. Are there any recommended twin-tuner pci-e cards that is
> support and can actually be bought by the average consumer?

Did you risk a look at any of those?

http://www.linuxtv.org/wiki/index.php/DVB-S_PCI_Cards
http://www.linuxtv.org/wiki/index.php/DVB-S_PCIe_Cards
http://www.linuxtv.org/wiki/index.php/DVB-S2_PCI_Cards
http://www.linuxtv.org/wiki/index.php/DVB-S2_PCIe_Cards

I suspect they might contain some usable informaion. You should however
take into account that most developers don't care to update a bazillion
different places after they added support for a particular devices. So 
in most cases there will be a brief announcment on the developers
mailinglist and the code is the documentation.

cheers
-henrik

