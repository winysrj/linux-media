Return-path: <mchehab@localhost>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55801 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1GLBVF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 21:21:05 -0400
MIME-Version: 1.0
In-Reply-To: <201107111244.21360.laurent.pinchart@ideasonboard.com>
References: <20110711174811.3c383595@tom-ThinkPad-T410>
	<201107111244.21360.laurent.pinchart@ideasonboard.com>
Date: Tue, 12 Jul 2011 09:21:05 +0800
Message-ID: <CACVXFVO3oY=RH8qDBEC7nNDxC0bc+JX8shJC2cb-FaojRwxrdg@mail.gmail.com>
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

Thanks for your reply.

On Mon, Jul 11, 2011 at 6:44 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:

> That's unfortunately not acceptable as-is. If two cameras are connected to the
> system, and only one of them doesn't support suspend/resume, the other will be
> affected by your patch.

Yes, other cameras may be affected, but they still can work well, so
the patch still
makes sense.

>
> Have you tried to investigate why suspend/resume fails for the above-mentioned
> camera, instead of working around the problem ?

I have investigated the problem, and not found failures in the
suspend/resume path,
either .suspend or .resume callback return successful, but no stream packets are
received from camera any longer after resume from sleep. Once doing a unbind&
bind will make the camera work again.

Could you give any suggestions to help to find the root cause of the problem?



thanks,
-- 
Ming Lei
