Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:46435 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbZJBNn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2009 09:43:57 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 2 Oct 2009 08:43:57 -0500
Subject: mt9t031-VPFE integration issues...
Message-ID: <A69FA2915331DC488A831521EAE36FE4015537027D@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

I am currently integrating latest MT9T031 driver to vpfe_capture driver and see following issues:-

1) Currently MT9T031 Kconfig configuration variable has a dependency on SOC_CAMERA. We need to remove this dependency since this sensor can be used on other platforms like DM6446/DM355/DM365. This is trivial and I can send a patch to remove the dependency.

2) The code still has reference to soc_camera_device and associated changes. I think this should be removed so that it can be used on other platforms as well. I am expecting these will go away once the bus parameter as well data format related RFCs are approved. If this is true, I can wait until the same is approved. If not, we need to work together so that this driver can be integrated with vpfe capture driver.

Please let me know what you think on this.

Regards,
Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

