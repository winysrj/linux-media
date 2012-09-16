Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:39051 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab2IPTmG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Sep 2012 15:42:06 -0400
Date: Sun, 16 Sep 2012 20:42:04 +0100
From: Sean Young <sean@mess.org>
To: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Sakari Ailus <sakari.ailus@iki.fi>, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCHv3 2/9] ir-rx51: Handle signals properly
Message-ID: <20120916194204.GA19083@pequod.mess.org>
References: <1346349271-28073-1-git-send-email-timo.t.kokkonen@iki.fi>
 <1346349271-28073-3-git-send-email-timo.t.kokkonen@iki.fi>
 <20120901171420.GC6638@valkosipuli.retiisi.org.uk>
 <50437328.9050903@iki.fi>
 <504375FA.1030209@iki.fi>
 <20120902152027.GA5236@itanic.dhcp.inet.fi>
 <20120902194110.GA6834@valkosipuli.retiisi.org.uk>
 <5043BCB4.1040308@iki.fi>
 <20120903123653.GA7218@pequod.mess.org>
 <5052E3BD.9040502@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5052E3BD.9040502@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 14, 2012 at 10:58:53AM +0300, Timo Kokkonen wrote:
> It appears that all "modern" lirc drivers are now using the rc-core
> functionalities to implement the common stuff. When the rx51 lirc driver
> was first written, the core was not in place yet. Therefore it is
> implementing the file operations in the driver, which other rc drivers
> won't do today.
> 
> So, I think it would make sense to modify the rx51 driver to use the rc
> core functionality. But if there is an ABI change ongoing, I could wait
> until you have that done before I start working on the change?

There is no immediate need for porting to rc-core, AFAIK. OTOH I suspect 
that only some of the drivers using rc-core will only need to have their 
tx_ir method modified for a new sending/receiving ABI, so it shouldn't
stop you. If anything it might make the driver smaller.

At the moment I'm only just put initial patches together so I don't know 
when I or anyone else will have this finished. 


Sean
