Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43881 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab1HAL0V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2011 07:26:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] uvcvideo: add SetInterface(0) in .reset_resume handler
Date: Mon, 1 Aug 2011 13:26:31 +0200
Cc: linux-media@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-usb@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <CACVXFVPHfskUCxhznpATknNxokmL5hft-b+KoxWiMzprVmuJ4w@mail.gmail.com> <201107311738.58462.laurent.pinchart@ideasonboard.com> <CACVXFVMJvZqYH3eS7LH_jgewL40KK74wrSX_-FhqLmyDJmPEGg@mail.gmail.com>
In-Reply-To: <CACVXFVMJvZqYH3eS7LH_jgewL40KK74wrSX_-FhqLmyDJmPEGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108011326.31648.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ming,

On Monday 01 August 2011 02:56:59 Ming Lei wrote:
> On Sun, Jul 31, 2011 at 11:38 PM, Laurent Pinchart wrote:
> > Hi Ming,
> > 
> > Thanks for the patch. I've queued it for v3.2 with a small modification
> > (the usb_set_interface() call has been moved to uvc_video.c).
> 
> Thanks for queuing it.
> 
> Considered it is a fix patch, could you queue it for 3.1 -rcX as fix patch?
> But anyway, it is up to you, :-)

It's not completely up to me :-) This patch falls in the "features that never 
worked" category. I've heard that Linus didn't want such non-regression fixes 
during the 3.0-rc phase. Mauro, is it still true for v3.1-rc ? Can I push this 
patch for 3.1, or does it need to wait until 3.2 ?

-- 
Regards,

Laurent Pinchart
