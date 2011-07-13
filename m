Return-path: <mchehab@localhost>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52210 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965029Ab1GMIib (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 04:38:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia camera
Date: Wed, 13 Jul 2011 10:38:32 +0200
Cc: Ming Lei <ming.lei@canonical.com>, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <20110711174811.3c383595@tom-ThinkPad-T410> <201107111244.21360.laurent.pinchart@ideasonboard.com> <CACVXFVO3oY=RH8qDBEC7nNDxC0bc+JX8shJC2cb-FaojRwxrdg@mail.gmail.com>
In-Reply-To: <CACVXFVO3oY=RH8qDBEC7nNDxC0bc+JX8shJC2cb-FaojRwxrdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107131038.33153.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Tuesday 12 July 2011 03:21:05 Ming Lei wrote:
> On Mon, Jul 11, 2011 at 6:44 PM, Laurent Pinchart wrote:
> > That's unfortunately not acceptable as-is. If two cameras are connected
> > to the system, and only one of them doesn't support suspend/resume, the
> > other will be affected by your patch.
> 
> Yes, other cameras may be affected, but they still can work well, so
> the patch still makes sense.

They can still work, but not optimally, as they will be reset instead of 
suspended/resumed. That's not acceptable.

> > Have you tried to investigate why suspend/resume fails for the
> > above-mentioned camera, instead of working around the problem ?
> 
> I have investigated the problem, and not found failures in the
> suspend/resume path,
> either .suspend or .resume callback return successful, but no stream
> packets are received from camera any longer after resume from sleep. Once
> doing a unbind& bind will make the camera work again.
> 
> Could you give any suggestions to help to find the root cause of the
> problem?

-- 
Regards,

Laurent Pinchart
