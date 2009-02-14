Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47600 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZBNIwe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 03:52:34 -0500
Date: Sat, 14 Feb 2009 06:52:06 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: libv4l2 library problem
Message-ID: <20090214065206.1a9494d9@pedra.chehab.org>
In-Reply-To: <200902131357.46279.hverkuil@xs4all.nl>
References: <200902131357.46279.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Feb 2009 13:57:45 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi Hans,
> 
> I've developed a converter for the HM12 format (produced by Conexant MPEG 
> encoders as used in the ivtv and cx18 drivers).
> 
> But libv4l2 has a problem in its implementation of v4l2_read: it assumes 
> that the driver can always do streaming. However, that is not the case for 
> some drivers, including cx18 and ivtv. These drivers only implement read() 
> functionality and no streaming.
> 
> Can you as a minimum modify libv4l2 so that it will check for this case? The 
> best solution would be that libv4l2 can read HM12 from the driver and 
> convert it on the fly. But currently it tries to convert HM12 by starting 
> to stream, and that produces an error.
> 
> This bug needs to be fixed first before I can contribute my HM12 converter.

Hans Verkuil,

I think it would be valuable if you could convert the drivers to use videobuf.
There's currently a videobuf variation for devices that don't support
scatter/gather dma transfers. By using videobuf, the mmap() methods (and also
overlay, if you want) will be supported.


Cheers,
Mauro
