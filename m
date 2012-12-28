Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab2L1OWU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 09:22:20 -0500
Date: Fri, 28 Dec 2012 12:21:11 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: LMML <linux-media@vger.kernel.org>,
	Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [patch 02/03 v2] usb hid quirks for Masterkit MA901 usb radio
Message-ID: <20121228122111.7f1590ed@redhat.com>
In-Reply-To: <alpine.LNX.2.00.1212281427120.12462@pobox.suse.cz>
References: <20121228102928.4103390e@redhat.com>
	<alpine.LNX.2.00.1212281427120.12462@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Dec 2012 14:27:56 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> escreveu:

> On Fri, 28 Dec 2012, Mauro Carvalho Chehab wrote:
> 
> > Hi Jiri,
> > 
> > There's another radio device that it is incorrectly detected as an HID driver.
> > As I'll be applying the driver's patch via the media tree, do you mind if I also
> > apply this hid patch there?
> 
> Hi Mauro,
> 
> please feel free to add
> 
> 	Acked-by: Jiri Kosina <jkosina@suse.cz>
> 
> and take the patch through your tree.

Thank you, Jiri!

Regards,
Mauro
