Return-path: <mchehab@localhost>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55740 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965064Ab1GMIvL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 04:51:11 -0400
MIME-Version: 1.0
In-Reply-To: <201107131038.33153.laurent.pinchart@ideasonboard.com>
References: <20110711174811.3c383595@tom-ThinkPad-T410>
	<201107111244.21360.laurent.pinchart@ideasonboard.com>
	<CACVXFVO3oY=RH8qDBEC7nNDxC0bc+JX8shJC2cb-FaojRwxrdg@mail.gmail.com>
	<201107131038.33153.laurent.pinchart@ideasonboard.com>
Date: Wed, 13 Jul 2011 16:51:11 +0800
Message-ID: <CACVXFVPs20+0ZFcrJpwDt+6jaaniYc9ZgSaKpkCyVAcGM+ZQmA@mail.gmail.com>
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

On Wed, Jul 13, 2011 at 4:38 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:

> They can still work, but not optimally, as they will be reset instead of
> suspended/resumed. That's not acceptable.

If the "reset" you mentioned is usb bus reset signal, I think unbind&bind
will not produce the reset signal.

thanks,
-- 
Ming Lei
