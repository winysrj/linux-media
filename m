Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:41768 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1HAA47 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 20:56:59 -0400
MIME-Version: 1.0
In-Reply-To: <201107311738.58462.laurent.pinchart@ideasonboard.com>
References: <CACVXFVPHfskUCxhznpATknNxokmL5hft-b+KoxWiMzprVmuJ4w@mail.gmail.com>
	<Pine.LNX.4.44L0.1107151122490.1866-100000@iolanthe.rowland.org>
	<20110716115100.10f6f764@tom-ThinkPad-T410>
	<201107311738.58462.laurent.pinchart@ideasonboard.com>
Date: Mon, 1 Aug 2011 08:56:59 +0800
Message-ID: <CACVXFVMJvZqYH3eS7LH_jgewL40KK74wrSX_-FhqLmyDJmPEGg@mail.gmail.com>
Subject: Re: [PATCH] uvcvideo: add SetInterface(0) in .reset_resume handler
From: Ming Lei <tom.leiming@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-usb@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sun, Jul 31, 2011 at 11:38 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Ming,
>
> Thanks for the patch. I've queued it for v3.2 with a small modification (the
> usb_set_interface() call has been moved to uvc_video.c).

Thanks for queuing it.

Considered it is a fix patch, could you queue it for 3.1 -rcX as fix patch?
But anyway, it is up to you, :-)

thanks,
-- 
Ming Lei
