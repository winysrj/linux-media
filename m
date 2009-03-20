Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43032 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbZCTGdV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 02:33:21 -0400
Date: Fri, 20 Mar 2009 03:32:52 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Jonathan Cameron <jic23@cam.ac.uk>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: RFC: ov7670 soc-camera driver
Message-ID: <20090320033252.20572221@pedra.chehab.org>
In-Reply-To: <200903160846.12487.hverkuil@xs4all.nl>
References: <49BD3669.1070409@cam.ac.uk>
	<20090315162338.3be11fec@bike.lwn.net>
	<200903160846.12487.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Mar 2009 08:46:12 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:


> > I think it's necessary, really.  Having two drivers for the same device
> > seems like a bad idea.  As Hans noted, he's already put quite a bit of
> > work into generalizing the ov7670 driver; I think it would be best to
> > work with him to get a driver that works for everybody.
> 
> Just FYI: I'll try to get my ov7670 code merged this week. I'm waiting for 
> Mauro to merge a pending pull request of mine, and then I'll rebase 
> my 'cafe2' tree and send out a pull request for it.

The cafe2 code were merged today. As said, the better is to use the existing
ov7670 code, instead of just creating another.

Cheers,
Mauro
