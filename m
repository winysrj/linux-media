Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:34020 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683Ab0HYUYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 16:24:17 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nataraju, Kiran" <knataraju@ti.com>
Date: Wed, 25 Aug 2010 15:24:14 -0500
Subject: [RESEND][omap3camera] How does a lens subdevice get powered up?
Message-ID: <A24693684029E5489D1D202277BE894463BA7E4D@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

(Resending as plain text, as I sent it originally as HTML and
got rejected by ML security policies)

Hi Laurent,

I see that usually a sensor is powered up on attempting a
VIDIOC_STREAMON at the capture endpoint of the pipeline,
in which the sensor is linked.

Now, what I don't understand quite well is, the Lens driver
is a separate subdevice, BUT it's obviously not linked to the
sensor, nor the pipeline.

How would the lens driver know when to power up?

Regards,
Sergio
