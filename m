Return-path: <linux-media-owner@vger.kernel.org>
Received: from panicking.kicks-ass.org ([95.141.32.57]:53952 "EHLO
	panicking.kicks-ass.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760446Ab0FKTkW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jun 2010 15:40:22 -0400
Message-ID: <4C128C33.8060309@panicking.kicks-ass.org>
Date: Fri, 11 Jun 2010 21:19:15 +0200
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Guennadi Liakhovetski <kernel@pengutronix.de>
Subject: PXA320 camera support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have seen that the pxa27xx-camera is inside the devices for the PXA320 but I don't know if this support work
for this cpu. Looking at the code for example the overrun condition check is wrong for the PXA320 because
the bits of the overrun is different

-       camera_status = __raw_readl(pcdev->base + CISR);
+       camera_status = __raw_readl(pcdev->base + CIFSR);

In the two implementation. Anyone has tried to use it on the pxa320?

Michael Trimarchi
