Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40018 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2FRMPo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 08:15:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 30/32] v4l2-ioctl.c: shorten the lines of the table.
Date: Mon, 18 Jun 2012 14:15:52 +0200
Message-ID: <5828709.8CxBIyvKM1@avalon>
In-Reply-To: <201206181334.33076.hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <2301007.COnlniXjQu@avalon> <201206181334.33076.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 18 June 2012 13:34:33 Hans Verkuil wrote:
> On Mon June 18 2012 11:57:24 Laurent Pinchart wrote:
> > On Sunday 10 June 2012 12:25:52 Hans Verkuil wrote:
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > 
> > > Use some macro magic to reduce the length of the lines in the table.
> > > This makes it more readable.
> > 
> > It indeed shortens the lines, but to be honest I find the result less
> > readable.
> 
> What do you think, should I just keep those long lines?

I think that's better. If several fields could be computed from the same 
information in all cases then I'd be fine with specifying the common 
information only, but just shortening names makes the code less readable in my 
opinion. 

> I've tried splitting them up, but that too made it harder to read.

-- 
Regards,

Laurent Pinchart

