Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33741 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752766Ab0BSQVI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 11:21:08 -0500
Content-Type: text/plain; charset="iso-8859-1"
Date: Fri, 19 Feb 2010 17:21:01 +0100
From: "Philipp Wiesner" <p.wiesner@gmx.net>
Message-ID: <20100219162101.92410@gmx.net>
MIME-Version: 1.0
Subject: soc-camera: pixclk polarity question
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm working with µCs (i.MX27) and cameras (Aptina) at the moment.

Now I encountered a problem introduced by serializing and deserializing (lvds) camera data on its way to the µC.

The serializer expects a specific pixclk polarity which can be configured in hardware. In most cases this is no problem as it is permanently connected to only one sensor chip, but camera sensors with configurable pixclk could negotiate the wrong polarity.

The deserializer generates pixclk from data, its polarity again can be configured in hardware. This leads to pixclk inversion depending on wheter serdes is happening or not, so its not an attribute of the platform (in opposition to what SOCAM_SENSOR_INVERT_PCLK is meant for)

What would be the correct way to address this?

Do we need another platform flag, e.g. SOCAM_PCLK_SAMPLE_RISING_FIXED?
The only solution coming to my mind is checking for the SerDes on boot time and setting flags like SOCAM_PCLK_SAMPLE_RISING_FIXED and SOCAM_SENSOR_INVERT_PCLK if necessary.

Any other ideas?

Thanks,
Philipp
-- 
NEU: Mit GMX DSL über 1000,- ¿ sparen!
http://portal.gmx.net/de/go/dsl02
