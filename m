Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:46742 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932Ab2BAFBk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Feb 2012 00:01:40 -0500
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Rabin VINCENT <rabin.vincent@stericsson.com>,
	Linus WALLEIJ <linus.walleij@stericsson.com>
Date: Wed, 1 Feb 2012 13:01:22 +0800
Subject: Handling <Ctrl-c> like events in 's_power' implementation when we
 have a GPIO controlling the sensor CE
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384ED2897780@EAPEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

I don't know if you are the right person to ask this query (since
it is also related to GPIO stuff), but here goes:

Our board has a I2C controlled camera sensor whose Chip Enable (CE)
pin is driven via a GPIO. This GPIO is made available by a I2C-to-GPIO
expander chip (STMPE801, see user manual [1])

Now, when we implement the 's_power' routines as specified by the soc-camera
framework, a peculiar issue arises:

The 's_power' routine simply toggles the CE of the sensor as per the power-on/off
command received from the framework/bridge driver. And this works absolutely fine
in normal cases. As we have a GPIO on a external chip (STMPE801) we need to use 
*_cansleep variants of the gpio_set/get routines (see [2] for reference) to toggle
the GPIO values to power-on/off the sensor chip.

Now, when we terminate a user application (a standard application like 'capture'
available as a reference v4l2 test application) which was capturing a large
number of frames from the sensor, using 'ctrl-c', I see that 's_power' is 
correctly called with a power-off argument. However, the I2C controller driver
(we use the standard SYNOPSYS designware device driver present in mainline,
see [3]) returns -ERESTARTSYS in response to the write command we had requested
for putting the sensor to power-off state (as it has received the <ctrl-c> kill
signal).

But as the gpio_set_val_* variants are inherently 'void' implementations, we have
no mechanism to use and handle the -ERESTARTSYS value in the 's_power' implementation.
I also found that the standard 'soc_camera.c' does not check the return value in
'soc_camera_power_off' routines, but that is a easily fixable issue.

Now, I want your opinions on how to get out of this mess.
Perhaps changes in GPIO implementations? Or am I missing
something here.

References:
[1] http://www.st.com/internet/analog/product/154542.jsp
[2] http://lxr.linux.no/linux+v3.1.5/Documentation/gpio.txt#L195
[3] http://lxr.linux.no/linux+v3.1.5/drivers/i2c/busses/i2c-designware.c

Regards,
Bhupesh 





