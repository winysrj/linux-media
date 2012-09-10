Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.telros.ru ([83.136.244.21]:51311 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab2IJGZy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 02:25:54 -0400
Date: Mon, 10 Sep 2012 14:28:29 +0400
From: volokh@telros.ru
To: Adam Rosi-Kessel <adam@rosi-kessel.org>
Cc: linux-media@vger.kernel.org, volokh84@gmail.com
Subject: Re: go7007 question
Message-ID: <20120910102829.GA2507@VPir.telros.ru>
References: <5044F8DC.20509@rosi-kessel.org>
 <20120906191014.GA2540@VPir.Home>
 <20120907141831.GA12333@VPir.telros.ru>
 <20120909022331.GA28838@whitehail.bostoncoop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120909022331.GA28838@whitehail.bostoncoop.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 08, 2012 at 10:23:31PM -0400, Adam Rosi-Kessel wrote:
> On Fri, Sep 07, 2012 at 06:18:31PM +0400, volokh@telros.ru wrote:
> > On Thu, Sep 06, 2012 at 11:10:14PM +0400, Volokh Konstantin wrote:
> > > On Mon, Sep 03, 2012 at 02:37:16PM -0400, Adam Rosi-Kessel wrote:
> > > > 
> > > > [469.928881] wis-saa7115: initializing SAA7115 at address 32 on WIS
> > > > GO7007SB EZ-USB
> > > > 
> > > > [469.989083] go7007: probing for module i2c:wis_saa7115 failed
> > > > 
> > > > [470.004785] wis-uda1342: initializing UDA1342 at address 26 on WIS
> > > > GO7007SB EZ-USB
> > > > 
> > > > [470.005454] go7007: probing for module i2c:wis_uda1342 failed
> > > > 
> > > > [470.011659] wis-sony-tuner: initializing tuner at address 96 on WIS
> > > > GO7007SB EZ-USB
> > Hi, I generated patchs, that u may in your own go7007/ folder
> > It contains go7007 initialization and i2c_subdev fixing
> > 
> > It was checked for 3.6 branch (compile only)
> 
> So I have this installed now (patched with your 3.6 patch) but I'm not
> seeing the device.
> 
> The module is there:
> 
> [  416.189030] Linux media interface: v0.10
> [  416.198616] Linux video capture interface: v2.00
> [  416.220656] wis_uda1342: module is from the staging directory, the quality is unknown, you have been warned.
> 
> # lsmod|grep -i go7
> go7007_usb             10059  0 
> go7007                 46966  1 go7007_usb
> v4l2_common             4206  1 go7007
> videodev               78250  2 go7007,v4l2_common
> 
> # uname -a
> Linux storage 3.6.0-rc4.ajk+ #5 SMP Sat Sep 8 22:05:57 EDT 2012 i686 GNU/Linux
> 
> # grep -i go7 /boot/config-`uname -r`
> CONFIG_VIDEO_GO7007=m
> CONFIG_VIDEO_GO7007_USB=m
> CONFIG_VIDEO_GO7007_OV7640=m
> # CONFIG_VIDEO_GO7007_SAA7113 is not set
Linux must autoload these modules for working:
wis-saa7115
wis-uda1342
wis-sony-tuner,
so need set m below:
> # CONFIG_VIDEO_GO7007_SAA7115 is not set
> CONFIG_VIDEO_GO7007_TW9903=m
> CONFIG_VIDEO_GO7007_UDA1342=m
> CONFIG_VIDEO_GO7007_SONY_TUNER=m
> CONFIG_VIDEO_GO7007_TW2804=m

after compilation need install modules, or handly load them.
modprobe wis-saa7115, etc ... for each modules.

> 
> But I'm not getting any device to appear:
> 
> # ls /dev/video*
> ls: cannot access /dev/video*: No such file or directory
> # gorecord -format mpeg4 test.avi
> Driver loaded but no GO7007 devices found.
> Is the device connected properly?
> 
> When I connect the device I see this:
> 
> [  585.705406] usb 1-4: udev 4, busnum 1, minor = 3
> [  585.705412] usb 1-4: New USB device found, idVendor=093b, idProduct=a004
> [  585.705415] usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [  585.705532] usb 1-4: usb_probe_device
> [  585.705535] usb 1-4: configuration #1 chosen from 1 choice
> [  585.706233] usb 1-4: adding 1-4:1.0 (config #1, interface 0)
> 
> But no video node.
> 
> Am I missing something?
> 
> Adam
