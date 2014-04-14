Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:57434 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752562AbaDNJe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:34:29 -0400
Date: Mon, 14 Apr 2014 06:33:55 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-usb@vger.kernel.org
Subject: Re: stk1160 / ehci-pci 0000:00:0a.0: DMA-API: device driver maps
 memory fromstack [addr=ffff88003d0b56bf]
Message-ID: <20140414093355.GA702@arch.cereza>
References: <438386739.20140413224553@eikelenboom.it>
 <Pine.LNX.4.44L0.1404132220550.24243-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.1404132220550.24243-100000@netrider.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Apr 13, Alan Stern wrote:
> On Sun, 13 Apr 2014, Sander Eikelenboom wrote:
> 
> > Hi,
> > 
> > I'm hitting this warning on boot with a syntek usb video grabber, it's not clear 
> > to me if it's a driver issue of the stk1160 or a generic ehci issue.
> 
> It is a bug in the stk1160 driver.
> 

Thanks for pointing this out, I'm on it.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
