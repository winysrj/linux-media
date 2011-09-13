Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38831 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1IMJIi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 05:08:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enrico <ebutera@users.berlios.de>
Subject: Re: omap3isp as a wakeup source
Date: Tue, 13 Sep 2011 11:08:37 +0200
Cc: linux-media@vger.kernel.org
References: <CA+2YH7s-BH=4vN-DUZJXa9DKrwYsZORWq-YR9fK7JV9236ntMQ@mail.gmail.com>
In-Reply-To: <CA+2YH7s-BH=4vN-DUZJXa9DKrwYsZORWq-YR9fK7JV9236ntMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109131108.37394.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

On Monday 12 September 2011 16:50:42 Enrico wrote:
> 
> While testing omap3isp+tvp5150 with latest Deepthy bt656 patches
> (kernel 3.1rc4) i noticed that yavta hangs very often when grabbing
> or, if not hanged, it grabs at max ~10fps.
> 
> Then i noticed that tapping on the (serial) console made it "unblock"
> for some frames, so i thought it doesn't prevent the cpu to go
> idle/sleep. Using the boot arg "nohlt" the problem disappear and it
> grabs at a steady 25fps.
> 
> In the code i found a comment that says the camera can't be a wakeup
> source but the camera powerdomain is instead used to decide to not go
> idle, so at this point i think the camera powerdomain is not enabled
> but i don't know how/where to enable it. Any ideas?

Could that be related to the OMAP3 ISP driver not implementing the runtime PM 
API ?

-- 
Regards,

Laurent Pinchart
