Return-path: <mchehab@localhost>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57364 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965050Ab1GMJHV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 05:07:21 -0400
MIME-Version: 1.0
In-Reply-To: <201107131059.34753.laurent.pinchart@ideasonboard.com>
References: <20110711174811.3c383595@tom-ThinkPad-T410>
	<201107131038.33153.laurent.pinchart@ideasonboard.com>
	<CACVXFVPs20+0ZFcrJpwDt+6jaaniYc9ZgSaKpkCyVAcGM+ZQmA@mail.gmail.com>
	<201107131059.34753.laurent.pinchart@ideasonboard.com>
Date: Wed, 13 Jul 2011 17:07:21 +0800
Message-ID: <CACVXFVNZ9mFJGSRPYDDZNkky39+gTuewMpPN4gxUOL_a4aXa5g@mail.gmail.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia camera
From: Ming Lei <tom.leiming@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ming Lei <ming.lei@canonical.com>, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi,

On Wed, Jul 13, 2011 at 4:59 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:

> Sorry, I haven't been clear. If you remove the suspend/resume handlers from
> the driver, the USB core will unbind and rebind the driver instead of
> suspending/resuming the device properly. As this will affect other UVC devices
> as well, that's not a good solution.

I agree with you this is not a good solution, but seems there are no
other solutions
for the buggy device.

You are uvc expert, could you give some suggestion about accepted solutions?

thanks,
-- 
Ming Lei
