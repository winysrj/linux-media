Return-path: <mchehab@localhost>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32871 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965115Ab1GMI7d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 04:59:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia camera
Date: Wed, 13 Jul 2011 10:59:34 +0200
Cc: Ming Lei <ming.lei@canonical.com>, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <20110711174811.3c383595@tom-ThinkPad-T410> <201107131038.33153.laurent.pinchart@ideasonboard.com> <CACVXFVPs20+0ZFcrJpwDt+6jaaniYc9ZgSaKpkCyVAcGM+ZQmA@mail.gmail.com>
In-Reply-To: <CACVXFVPs20+0ZFcrJpwDt+6jaaniYc9ZgSaKpkCyVAcGM+ZQmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107131059.34753.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Wednesday 13 July 2011 10:51:11 Ming Lei wrote:
> On Wed, Jul 13, 2011 at 4:38 PM, Laurent Pinchart wrote:
> > They can still work, but not optimally, as they will be reset instead of
> > suspended/resumed. That's not acceptable.
> 
> If the "reset" you mentioned is usb bus reset signal, I think unbind&bind
> will not produce the reset signal.

Sorry, I haven't been clear. If you remove the suspend/resume handlers from 
the driver, the USB core will unbind and rebind the driver instead of 
suspending/resuming the device properly. As this will affect other UVC devices 
as well, that's not a good solution.

-- 
Regards,

Laurent Pinchart
