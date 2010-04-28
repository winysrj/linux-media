Return-path: <linux-media-owner@vger.kernel.org>
Received: from drm03.Deuromedia.ro ([194.176.161.3]:43547 "HELO deuromedia.de"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751033Ab0D1HcW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 03:32:22 -0400
Message-ID: <4BD7E501.2070701@Deuromedia.ro>
Date: Wed, 28 Apr 2010 10:34:25 +0300
From: Doru Marin <Doru.Marin@Deuromedia.ro>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: WinTV-Nova-HD-S2 firmware failure
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have a WinTV-Nova-HD-S2 (known as HVR4000Lite) card for HD receiving.
After a while of browsing trough channels, I'm getting the message:

cx24116_cmd_execute() Firmware not responding

and the card fails to tune anymore.
The only fix from this situation is to reload the drivers and the 
firmware gets initialized again.

Any chance to have a workaround to automatically reload the firmware ?

Regards,

Doru.
