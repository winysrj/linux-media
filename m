Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55605 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbZKIOsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 09:48:31 -0500
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id nA9EmbIE008420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 9 Nov 2009 08:48:37 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id nA9EmbXm003106
	for <linux-media@vger.kernel.org>; Mon, 9 Nov 2009 08:48:37 -0600 (CST)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id nA9EmbRX025223
	for <linux-media@vger.kernel.org>; Mon, 9 Nov 2009 08:48:37 -0600 (CST)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 9 Nov 2009 08:48:35 -0600
Subject: S_FMT @ sensor driver & bridge driver
Message-ID: <A69FA2915331DC488A831521EAE36FE401558AB985@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Currently the S_FMT IOCTL is used to configure the image resolution
and (there by scaler settings) at the sensor (example MT9T031).
Platforms like TI's DMxxx VPFE has Resizer in the pipeline that can
be used as well by application to either zoom in a specific region
of the capture image from the sensor or scale it up for some other
reason. To do this we need to issue two S_FMT commands, 1st to set
the capture frame resolution at the sensor and second to configure
resize ration at the SOC Resizer. With the current API, I don't see
a way this can be done. I wish we had some extra bytes in the S_FMT structure to add a flag that can indicate if S_FMT applies to the
sensor or at the SOC (bridge). One way to implement this is to add
a control to tell the bridge driver to send a specific IOCTL command
to the sensor. Another use of such a command will be for control.
For example if a specific control such as White balance is available
at the SOC pipeline as well as at the sensor, then application can
use the above control to direct that IOCTL command to the specific
device.

You might argue that Media controller will allow you to direct
such commands directly to the target device. This is true for
control example I have mentioned above. But when applying
S_FMT at the sensor, we might want to passing it through the
bridge driver (as is the case with VPFE) so that it can request
extra lines to be captured as overhead to allow processing the
frame at the SOC pipeline in real time. So I do see this control
command staying even after we have media controller. Let me know
if you disagree with this proposal or have alternative to implement
the same. If I don't hear anything against this approach, I would
like to send patch to implement this control for vpfe capture
driver.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

