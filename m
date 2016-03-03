Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34475 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439AbcCCLuD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 06:50:03 -0500
Date: Thu, 3 Mar 2016 17:19:51 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH 5/5] staging: media: lirc: use new parport device model
Message-ID: <20160303114332.GA14062@sudip-pc>
References: <1450443929-15305-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1450443929-15305-5-git-send-email-sudipm.mukherjee@gmail.com>
 <20160125142906.184a4cb5@recife.lan>
 <20160125170230.GA8787@sudip-laptop>
 <20160125151257.24d5c7d2@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160125151257.24d5c7d2@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 25, 2016 at 03:12:57PM -0200, Mauro Carvalho Chehab wrote:
> Em Mon, 25 Jan 2016 22:32:31 +0530
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> escreveu:
> 
> > On Mon, Jan 25, 2016 at 02:29:06PM -0200, Mauro Carvalho Chehab wrote:
> > > Em Fri, 18 Dec 2015 18:35:29 +0530
> > > Sudip Mukherjee <sudipm.mukherjee@gmail.com> escreveu:
> > >   
> > > > Modify lirc_parallel driver to use the new parallel port device model.  
> > > 
> > > Did you or someone else tested this patch?  
> > 
> > Only build tested and tested by inserting and removing the module.
> > But since the only change is in the way it registers and nothing else
> > so it should not break.
> 
> It would be worth to wait for a while in the hope that someone could
> test with a real hardware.

Hi Mauro,
Merge window is almost going to open. Maybe now you can consider
applying it.

regards
sudip
