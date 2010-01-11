Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57310 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab0AKNYK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 08:24:10 -0500
Date: Mon, 11 Jan 2010 11:24:05 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Huang Shijie <shijie8@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 00/11] add linux driver for chip TLG2300
Message-ID: <20100111112405.0505c9df@pedra>
In-Reply-To: <4B1FF5AB.30405@redhat.com>
References: <1258687493-4012-1-git-send-email-shijie8@gmail.com>
	<4B1FF5AB.30405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 09 Dec 2009 17:08:27 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Huang Shijie wrote:
> > The TLG2300 is a chip of Telegent System.
> > It support analog tv,DVB-T and radio in a single chip.
> > The chip has been used in several dongles, such as aeromax DH-9000:
> > 	http://www.b2bdvb.com/dh-9000.htm
> > 
> > You can get more info from:
> > 	[1] http://www.telegent.com/
> > 	[2] http://www.telegent.com/press/2009Sept14_CSI.html
> > 
> > Huang Shijie (10):
> >   add maitainers for tlg2300
> >   add readme file for tlg2300
> >   add Kconfig and Makefile for tlg2300
> >   add header files for tlg2300
> >   add the generic file
> >   add video file for tlg2300
> >   add vbi code for tlg2300
> >   add audio support for tlg2300
> >   add DVB-T support for tlg2300
> >   add FM support for tlg2300
> > 
> 
> Ok, finished reviewing it.
> 
> Patches 01, 02 and 04 seems ok to me. You didn't sent a patch 03.
> Patch 05 will likely need some changes (the headers) due to some reviews I did
> on the other patches.
> 
> The other patches need some adjustments, as commented on separate emails.
> 

Hi Huang,

Happy new year!

Had you finish fixing the pointed issues?

Cheers,
Mauro
