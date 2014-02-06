Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-143.synserver.de ([212.40.185.143]:1043 "EHLO
	smtp-out-089.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756523AbaBFNR3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Feb 2014 08:17:29 -0500
Message-ID: <52F389AD.4040702@metafoo.de>
Date: Thu, 06 Feb 2014 14:10:05 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 43/47] adv7604: Control hot-plug detect through a GPIO
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com> <1391618558-5580-44-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-44-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/2014 05:42 PM, Laurent Pinchart wrote:
> Replace the ADV7604-specific hotplug notifier with a GPIO to control the
> HPD pin directly instead of going through the bridge driver.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

This should probably use the new GPIO descriptor API[1]. It will make things 
a bit simpler as it allows to move the active low handling to the gpio 
subsystem. The other thing is that it makes integration with devicetree nicer.

- Lars

[1] 
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/linux/gpio/consumer.h


