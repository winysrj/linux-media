Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40036 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab1IZTCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 15:02:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: cx231xx: DMA problem on ARM
Date: Mon, 26 Sep 2011 21:02:48 +0200
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, srinivasa.deevi@conexant.com,
	Maxime Ripard <maxime.ripard@free-electrons.com>
References: <20110921135604.64363a2e@skate> <20110926101323.41708d64@skate> <4E80B73F.5020804@redhat.com>
In-Reply-To: <4E80B73F.5020804@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201109262102.49056.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 26 September 2011 19:32:47 Mauro Carvalho Chehab wrote:
> Em 26-09-2011 05:13, Thomas Petazzoni escreveu:
> > Le Fri, 23 Sep 2011 23:15:54 -0300, Mauro Carvalho Chehab a écrit:
> >>> And still the result is the same: we get a first frame, and then
> >>> nothing more, and we have a large number of error messages in the
> >>> kernel logs.
> >> 
> >> I don't think that this is related to the power manager anymore. It can
> >> be related to cache coherency and/or to iommu support.
> > 
> > As you suspected, increasing PWR_SLEEP_INTERVAL didn't change anything.
> > What do you suggest to track down the potential cache coherency issues ?

Are you using the MMAP or USERPTR capture method ? If using MMAP, can you try 
(as a test only) to unmap the buffer before queueing it and to remap it after 
dequeuing it ?

> Take a look at the ML. The SoC people discussed a lot about cache
> coherency problems and how to solve it. Videobuf2 has a better support
> on embedded world. I would take a look on it and see what it does different
> than other drivers. Maybe Jonathan Corbet patches for the ccic driver may
> help you.
> 
> It is probably a good idea to change cx231xx to use videobuf2, in order to
> fix this issue.

-- 
Regards,

Laurent Pinchart
