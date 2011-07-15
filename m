Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48784 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750998Ab1GOPZr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 11:25:47 -0400
Date: Fri, 15 Jul 2011 11:25:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Ming Lei <tom.leiming@gmail.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ming Lei <ming.lei@canonical.com>,
	<linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia
 camera
In-Reply-To: <CACVXFVPHfskUCxhznpATknNxokmL5hft-b+KoxWiMzprVmuJ4w@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1107151122490.1866-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 15 Jul 2011, Ming Lei wrote:

> Hi,
> 
> On Fri, Jul 15, 2011 at 10:27 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > This is fine with me.  However, it is strange that the Set-Interface
> > request is necessary.  After being reset, the device should
> > automatically be in altsetting 0 for all interfaces.
> 
> For uvc devices, seems it is not strange, see uvc_video_init(), which
> is called in .probe path and executes Set-Interface 0 first, then starts
> to get/set video control.

I see what you mean.  Apparently other UVC devices also need to receive
a Set-Interface(0) request before they will work right.  (It's still 
strange, though...)

Anyway, since the driver does this during probe, it makes sense to do 
it during reset-resume as well.

Alan Stern

