Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39923 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaBJO7L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 09:59:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 43/47] adv7604: Control hot-plug detect through a GPIO
Date: Mon, 10 Feb 2014 16:00:12 +0100
Message-ID: <1924613.0QAdEVj0Bb@avalon>
In-Reply-To: <52F389AD.4040702@metafoo.de>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com> <1391618558-5580-44-git-send-email-laurent.pinchart@ideasonboard.com> <52F389AD.4040702@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars,

On Thursday 06 February 2014 14:10:05 Lars-Peter Clausen wrote:
> On 02/05/2014 05:42 PM, Laurent Pinchart wrote:
> > Replace the ADV7604-specific hotplug notifier with a GPIO to control the
> > HPD pin directly instead of going through the bridge driver.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> This should probably use the new GPIO descriptor API[1]. It will make things
> a bit simpler as it allows to move the active low handling to the gpio
> subsystem. The other thing is that it makes integration with devicetree
> nicer.

Agreed. I'll fix that for the next version.

-- 
Regards,

Laurent Pinchart

