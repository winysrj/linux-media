Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:41153 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab1DZNaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2011 09:30:23 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Vladimir Pantelic <vladoman@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	"Nori, Sekhar" <nsekhar@ti.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Date: Tue, 26 Apr 2011 18:59:50 +0530
Subject: RE: [PATCH v16 01/13] davinci vpbe: V4L2 display driver for DM644X
 SoC
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BBC5CAC@dbde02.ent.ti.com>
References: <1301737249-4012-1-git-send-email-manjunath.hadli@ti.com>,<4DB6682F.2010109@gmail.com>
In-Reply-To: <4DB6682F.2010109@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Vladimir,
  Davinci family of devices consist of mainly Dm6446, Dm6467, Dm365, Dm355 which are dissimilar to OMAP devices in features and registers, and some (for ex Dm6467) in entire architecture. the current driver which you are seeing is DM6446, but the intent is to build-up the same code with support for DM355 and dM365 which belong to the same family and have almost same features and registers. There is no plan to share code with OMAP directory.

Thanks and Regards,
-Manju
________________________________________
From: Vladimir Pantelic [vladoman@gmail.com]
Sent: Tuesday, April 26, 2011 12:07 PM
To: Hadli, Manjunath
Cc: LMML; Kevin Hilman; LAK; Nori, Sekhar; dlos
Subject: Re: [PATCH v16 01/13] davinci vpbe: V4L2 display driver for DM644X SoC

Manjunath Hadli wrote:
> This is the display driver for Texas Instruments's DM644X family
> SoC. This patch contains the main implementation of the driver with the
> V4L2 interface. The driver implements the streaming model with
> support for both kernel allocated buffers and user pointers. It also
> implements all of the necessary IOCTLs necessary and supported by the
> video display device.

is there any hope/chance to make this share code with the omap v4l2
driver in drivers/media/video/omap?

