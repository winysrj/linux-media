Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46704 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab1CFLiX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 06:38:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
Date: Sun, 6 Mar 2011 12:38:42 +0100
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	David Cohen <dacohen@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <4D72C5F0.6090209@gmail.com> <4D736844.50703@redhat.com>
In-Reply-To: <4D736844.50703@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103061238.42784.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Sunday 06 March 2011 11:56:04 Mauro Carvalho Chehab wrote:
> Em 05-03-2011 20:23, Sylwester Nawrocki escreveu:
>
> A somewhat unrelated question that occurred to me today: what happens when
> a format change happens while streaming?
> 
> Considering that some formats need more bits than others, this could lead
> into buffer overflows, either internally at the device or externally, on
> bridges that just forward whatever it receives to the DMA buffers (there
> are some that just does that). I didn't see anything inside the mc code
> preventing such condition to happen, and probably implementing it won't be
> an easy job. So, one alternative would be to require some special CAPS if
> userspace tries to set the mbus format directly, or to recommend userspace
> to create media controller nodes with 0600 permission.

That's not really a media controller issue. Whether formats can be changed 
during streaming is a driver decision. The OMAP3 ISP driver won't allow 
formats to be changed during streaming. If the hardware allows for such format 
changes, drivers can implement support for that and make sure that no buffer 
overflow will occur.

-- 
Regards,

Laurent Pinchart
