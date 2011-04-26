Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43941 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab1DZGhk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2011 02:37:40 -0400
Received: by bwz15 with SMTP id 15so258961bwz.19
        for <linux-media@vger.kernel.org>; Mon, 25 Apr 2011 23:37:39 -0700 (PDT)
Message-ID: <4DB6682F.2010109@gmail.com>
Date: Tue, 26 Apr 2011 08:37:35 +0200
From: Vladimir Pantelic <vladoman@gmail.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH v16 01/13] davinci vpbe: V4L2 display driver for DM644X
 SoC
References: <1301737249-4012-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1301737249-4012-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Manjunath Hadli wrote:
> This is the display driver for Texas Instruments's DM644X family
> SoC. This patch contains the main implementation of the driver with the
> V4L2 interface. The driver implements the streaming model with
> support for both kernel allocated buffers and user pointers. It also
> implements all of the necessary IOCTLs necessary and supported by the
> video display device.

is there any hope/chance to make this share code with the omap v4l2
driver in drivers/media/video/omap?

