Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58651 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663AbcEQOvS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2016 10:51:18 -0400
Date: Tue, 17 May 2016 16:51:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [Q] Asynchronous controls vs. events
Message-ID: <Pine.LNX.4.64.1605171540010.14153@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I need to add asynchronous control support to the UVC driver. Some UVC 
cameras support some controls in asynchronous mode. For those controls a 
USB status is returned to the host, but the control will only be 
completed, when an Interrupt packet is sent by the device. I can see two 
ways to support this:

(1) synchronously: the driver waits in S_CTRL until the interrupt packet 
arrives

(2) asynchronously: the driver returns immediately and sends an event 
after the Interrupt packet is received.

Question: which method would be preferred, if (2) - what error code should 
the driver use to indicate, that the result of the control isn't known 
yet? Or should success be returned, since a success anyway doesn't 
guarantee that the specified value has already taken effect.

Thanks
Guennadi
