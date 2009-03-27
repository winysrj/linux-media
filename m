Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbZC0KeL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 06:34:11 -0400
Date: Fri, 27 Mar 2009 07:34:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Darius Augulis <augulis.darius@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/5] CSI camera interface driver for MX1
Message-ID: <20090327073402.16252251@pedra.chehab.org>
In-Reply-To: <49CC9E53.9070805@gmail.com>
References: <49C89F00.1020402@gmail.com>
	<Pine.LNX.4.64.0903261405520.5438@axis700.grange>
	<49CBD53C.6060700@gmail.com>
	<20090326170910.6926d8de@pedra.chehab.org>
	<49CC9E53.9070805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 27 Mar 2009 11:37:23 +0200
Darius Augulis <augulis.darius@gmail.com> wrote:

> Mauro Carvalho Chehab wrote:
> > Hi Darius,
> > 
> > Please always base your patches against the last v4l-dvb tree or linux-next.
> > This is specially important those days, where v4l core is suffering several
> > changes.
> 
> Hi,
> 
> could you please advice which v4l-dvb Git repository I should pull from?
> Because git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/devel.git does not have any new stuff now.

During the merge window, all patches that are ready for submission are moved to:

	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git

> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git is marked as "unstable" for testing purposes.
> What is better to base my patches on?
> 
> Darius.




Cheers,
Mauro
