Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.epfl.ch ([128.178.224.219]:53078 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751663AbZBMS3Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 13:29:25 -0500
Message-ID: <4995BA71.6090801@epfl.ch>
Date: Fri, 13 Feb 2009 19:22:41 +0100
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: i.MX31 Camera Sensor Interface support
References: <Pine.LNX.4.64.0901240218400.8371@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0901240218400.8371@axis700.grange>
Content-Type: multipart/mixed;
 boundary="------------090602060908010506050100"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090602060908010506050100
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Guennadi,

Guennadi Liakhovetski wrote:
> I uploaded my current patch-stack for the i.MX31 Camera Sensor Interface 
> to http://gross-embedded.homelinux.org/~lyakh/i.MX31-20090124/ (to be 
> submitted later, hopefully for 2.6.30). As stated in 0000-base-unknown, 
> these patches shall be used on top of the 
> git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git tree 
> "upstream" branch.
> 

I have tested your patchset on our mx31moboard system. However, I would
like some precisions on how things should be registered.

>From what I have seen in the code and is confirmed in the log below, we
have a mx3_camera platform device that is registered and matched with
the mx3_camera driver (please note the filter drop, is that normal ?
Should some other things be registered ?)

> kobject:kobject: 'mx3_camera' (bf008008): kobject_add_internal: parent: 'module', set: 'module'            
> kobject:kobject: 'holders' (c7963360): kobject_add_internal: parent: 'mx3_camera', set: '<NULL>'           
> kobject_uevent:kobject: 'mx3_camera' (bf008008): kobject_uevent_env                                        
> kobject:kobject: 'mx3_camera' (bf008008): fill_kobj_path: path = '/module/mx3_camera'                      
> kobject:kobject: 'notes' (c79632e0): kobject_add_internal: parent: 'mx3_camera', set: '<NULL>'             
> bus:bus: 'platform': add driver mx3-camera                                                                 
> kobject:kobject: 'mx3-camera' (c798d0c0): kobject_add_internal: parent: 'drivers', set: 'drivers'          
> dd:bus: 'platform': driver_probe_device: matched device mx3-camera.0 with driver mx3-camera                
> dd:bus: 'platform': really_probe: probing driver mx3-camera with device mx3-camera.0                       
> core:device: 'camera_host0': device_add                                                                    
> kobject:kobject: 'camera_host0' (c889e07c): kobject_add_internal: parent: 'mx3-camera.0', set: 'devices'   
> kobject_uevent:kobject: 'camera_host0' (c889e07c): kobject_uevent_env                                      
> kobject_uevent:kobject: 'camera_host0' (c889e07c): kobject_uevent_env: filter function caused the event to drop!
> dd:driver: 'mx3-camera.0': driver_bound: bound to device 'mx3-camera'                                           
> dd:bus: 'platform': really_probe: bound device mx3-camera.0 to driver mx3-camera                                
> kobject_uevent:kobject: 'mx3-camera' (c798d0c0): kobject_uevent_env                                             
> kobject:kobject: 'mx3-camera' (c798d0c0): fill_kobj_path: path = '/bus/platform/drivers/mx3-camera'

The soc-camera also creates a bus. However, even with a capture device
driver loaded (let's say mt9m001 for instance), I have nothing in
/sys/bus/soc-camera/devices (that's where the capture devices should be
regitered thanks to the soc_camera_device_register() call if I have
understood correctly).

Furthermore, in /sys/bus/soc-camera/drivers, I only have the "dummy"
camera driver that is declared in the soc_camera.c file. Shouldn't I
have something related to mx3-camera there thanks to the the
soc_camera_host_register call (although of course the mx3-camera driver
already is registered with the mx3-camera platform_device) as you can
see it (like something related to camera_host0):

> root@mx31moboard:~/cam_test# ls -al /sys/bus/platform/devices/mx3-camera.0/
> drwxr-xr-x    3 root     root            0 Oct 16 13:51 .
> drwxr-xr-x    9 root     root            0 Oct 16 13:51 ..
> lrwxrwxrwx    1 root     root            0 Oct 16 13:52 bus -> ../../../bus/platform
> drwxr-xr-x    2 root     root            0 Oct 16 13:52 camera_host0
> lrwxrwxrwx    1 root     root            0 Oct 16 13:52 driver -> ../../../bus/platform/drivers/mx3-camera
> -r--r--r--    1 root     root         4096 Oct 16 13:52 modalias
> lrwxrwxrwx    1 root     root            0 Oct 16 13:52 subsystem -> ../../../bus/platform
> -rw-r--r--    1 root     root         4096 Oct 16 13:52 uevent

Is all this correct so far, and I would need further declarations in my
platform devices for the things to be registered together ? I have
attached you the file where I do the initializations related to the
mx3_camera device and the sensor  we want to test against so that you
can check (we are testing with a mt9m001 device atm, but we are
targeting a mt9t031 that's why the mixed names). I have tried to copy
this from what is done with the pxa.

Thank you for your explainations and best regards.

Val

-- 
Valentin Longchamp, PhD Student, EPFL-STI-LSRO1
valentin.longchamp@epfl.ch, Phone: +41216937827
http://people.epfl.ch/valentin.longchamp
MEA3485, Station 9, CH-1015 Lausanne

--------------090602060908010506050100
Content-Type: text/x-csrc;
 name="mx31moboard-marxbot.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mx31moboard-marxbot.c"

/*
 * Copyright (C) 2009 Valentin Longchamp, EPFL Mobots group
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <linux/types.h>
#include <linux/init.h>
#include <linux/gpio.h>
#include <linux/delay.h>

#include <linux/platform_device.h>

#include <mach/hardware.h>
#include <mach/common.h>
#include <mach/imx-uart.h>
#include <mach/iomux-mx3.h>
#include <mach/mx3_camera.h>
#include <linux/i2c.h>
#include <media/soc_camera.h>

#include "devices.h"

static int csi_pins[] = {
	MX31_PIN_CSI_D4__CSI_D4, MX31_PIN_CSI_D5__CSI_D5,
	MX31_PIN_CSI_D6__CSI_D6, MX31_PIN_CSI_D7__CSI_D7,
	MX31_PIN_CSI_D8__CSI_D8, MX31_PIN_CSI_D9__CSI_D9,
	MX31_PIN_CSI_D10__CSI_D10, MX31_PIN_CSI_D11__CSI_D11,
	MX31_PIN_CSI_D12__CSI_D12, MX31_PIN_CSI_D13__CSI_D13,
	MX31_PIN_CSI_D14__CSI_D14, MX31_PIN_CSI_D15__CSI_D15,
	MX31_PIN_CSI_HSYNC__CSI_HSYNC, MX31_PIN_CSI_MCLK__CSI_MCLK,
	MX31_PIN_CSI_PIXCLK__CSI_PIXCLK, MX31_PIN_CSI_VSYNC__CSI_VSYNC,
	MX31_PIN_GPIO3_0__GPIO3_0, MX31_PIN_GPIO3_1__GPIO3_1,
};

static int marxbot_mt9t031_power(struct device *dev, int on)
{
	//GPIO3_0 is connected to standby, it would be more a sleep function
	if (on)
		gpio_direction_output(IOMUX_TO_GPIO(MX31_PIN_GPIO3_1), 0);
	else
		gpio_direction_output(IOMUX_TO_GPIO(MX31_PIN_GPIO3_1), 1);
	
	return 0;
}

static int marxbot_mt9t031_reset(struct device *dev)
{
	gpio_direction_output(IOMUX_TO_GPIO(MX31_PIN_GPIO3_0), 1);
	udelay(100);
	gpio_direction_output(IOMUX_TO_GPIO(MX31_PIN_GPIO3_0), 0);
	return 0;
}

static struct soc_camera_link mt9t031_pdata = {
	.bus_id	= 0x5d,
	.gpio	= ARCH_NR_GPIOS + 1,
	.power	= marxbot_mt9t031_power,
	.reset	= marxbot_mt9t031_reset,
};

#ifdef CONFIG_I2C_IMX
static struct i2c_board_info marxbot_i2c_devices[] = {
	[0] = {
		I2C_BOARD_INFO("mt9m001", 0x5d),
		.platform_data = &mt9t031_pdata,
	},
};
#endif

/*
 * Try to reserve buffer space enough for 8 buffers 320x240@1 for
 * streaming plus 2 buffers 2048x1536@1 for still image < 10MB
 */
#define MX31MARXBOT_CAMERA_MEM_SIZE (4 * 1024 * 1024)

/*
 * system init for baseboard usage. Will be called by mx31moboard init.
 */
void __init mx31moboard_marxbot_init(void)
{
	printk(KERN_INFO "Initializing mx31marxbot peripherals\n");

	mxc_iomux_setup_multiple_pins(csi_pins, ARRAY_SIZE(csi_pins), "csi");
	mx3_register_camera(MX31MARXBOT_CAMERA_MEM_SIZE,
			MX3_CAMERA_DATAWIDTH_8 | MX3_CAMERA_DATAWIDTH_10,
			2000);
#ifdef CONFIG_I2C_IMX
	i2c_register_board_info(0, marxbot_i2c_devices,
			ARRAY_SIZE(marxbot_i2c_devices));
#endif

}

--------------090602060908010506050100--
