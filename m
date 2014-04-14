Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:33145 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754523AbaDNQG6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 12:06:58 -0400
Date: Mon, 14 Apr 2014 13:06:28 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-usb@vger.kernel.org
Subject: Re: stk1160 / ehci-pci 0000:00:0a.0: DMA-API: device driver maps
 memory fromstack [addr=ffff88003d0b56bf]
Message-ID: <20140414160628.GA4420@arch>
References: <438386739.20140413224553@eikelenboom.it>
 <20140414121231.GA6393@arch.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140414121231.GA6393@arch.cereza>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Apr 14, Ezequiel Garcia wrote:
> On Apr 13, Sander Eikelenboom wrote:
> > 
> > I'm hitting this warning on boot with a syntek usb video grabber, it's not clear 
> > to me if it's a driver issue of the stk1160 or a generic ehci issue.
> > 
> 
> Can't reproduce the same warning easily here. Could you test the following patch?
> 

Nevermind, just reproduced the warning. I'll be pushing a fix now.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
