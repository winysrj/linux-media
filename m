Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:29430 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965175Ab0GPLoX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 07:44:23 -0400
Subject: Re: [PATCH 24/25] video/ivtv: Convert pci_table entries to
 PCI_VDEVICE (if PCI_ANY_ID is used)
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Peter Huewe <PeterHuewe@gmx.de>,
	Kernel Janitors <kernel-janitors@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ian Armstrong <ian@iarmst.demon.co.uk>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	Steven Toth <stoth@kernellabs.com>, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikFTK4KwxKgQqwIId3dPy5hf5X0WjsAYkE5pEd4@mail.gmail.com>
References: <201007152108.27175.PeterHuewe@gmx.de>
	 <1279230200.7920.23.camel@morgan.silverblock.net>
	 <AANLkTikFTK4KwxKgQqwIId3dPy5hf5X0WjsAYkE5pEd4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jul 2010 07:42:54 -0400
Message-ID: <1279280574.2905.18.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-07-15 at 18:07 -0400, Jarod Wilson wrote:
> On Thu, Jul 15, 2010 at 5:43 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> > On Thu, 2010-07-15 at 21:08 +0200, Peter Huewe wrote:
> >> From: Peter Huewe <peterhuewe@gmx.de>

> > a. PCI_ANY_ID indicates to the reader a wildcard match is being
> > performed.  The PCI_VDEVICE() macro hides that to some degree.
> >
> > b. PCI_VENDOR_ID_ICOMP clearly indicates that ICOMP is a vendor.
> > "ICOMP" alone does not hint to the reader that is stands for a company
> > (the now defunct "Internext Compression, Inc.").
> 
> Personally, I'm a fan of comments around things like this to describe
> *exactly* what device(s) they're referring to.

Something like this then for ivtv: 

/* Claim every iTVC15/CX23415 or CX23416 based PCI Subsystem ever made */

?


>  Then ICOMP being all
> alone without the prefix isn't really much of an issue (though it
> could still be easily mistaken for something other than a pci vendor
> id, I suppose).

Probably not.  Another minor side effect is that it breaks a tag search
for easily jumping to the definition to see the ID value.  "ICOMP" won't
be in the tags file, but "PCI_VENDOR_ID_ICOMP" will be.

Regards,
Andy

