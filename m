Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41499 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753207AbcLHVZx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 16:25:53 -0500
Date: Fri, 9 Dec 2016 05:25:30 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: kbuild-all@01.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH 3/3] [media] em28xx: don't store usb_device at struct
 em28xx
Message-ID: <201612090518.C2CqHBA3%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b002d1d5d4a55ebd0c5c4d9577ba0d1f98d4e3c.1481226194.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on next-20161208]
[cannot apply to v4.9-rc8]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mauro-Carvalho-Chehab/em28xx-don-t-change-the-device-s-name/20161209-035446
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:253:8: sparse: attribute 'no_sanitize_address': unknown attribute
   drivers/media/usb/em28xx/em28xx-input.c:577:26: sparse: no member 'udev' in struct em28xx
   drivers/media/usb/em28xx/em28xx-input.c:589:32: sparse: no member 'udev' in struct em28xx
>> drivers/media/usb/em28xx/em28xx-input.c:589:32: sparse: cast from unknown type
   drivers/media/usb/em28xx/em28xx-input.c:590:33: sparse: no member 'udev' in struct em28xx
   drivers/media/usb/em28xx/em28xx-input.c:590:33: sparse: cast from unknown type
   drivers/media/usb/em28xx/em28xx-input.c:802:26: sparse: no member 'udev' in struct em28xx
   drivers/media/usb/em28xx/em28xx-input.c:809:31: sparse: no member 'udev' in struct em28xx
   drivers/media/usb/em28xx/em28xx-input.c:809:31: sparse: cast from unknown type
   drivers/media/usb/em28xx/em28xx-input.c:810:32: sparse: no member 'udev' in struct em28xx
   drivers/media/usb/em28xx/em28xx-input.c:810:32: sparse: cast from unknown type
   drivers/media/usb/em28xx/em28xx-input.c: In function 'em28xx_register_snapshot_button':
   drivers/media/usb/em28xx/em28xx-input.c:577:19: error: 'struct em28xx' has no member named 'udev'; did you mean 'adev'?
     usb_make_path(dev->udev, dev->snapshot_button_path,
                      ^~
   In file included from include/linux/byteorder/little_endian.h:4:0,
                    from arch/x86/include/uapi/asm/byteorder.h:4,
                    from include/asm-generic/bitops/le.h:5,
                    from arch/x86/include/asm/bitops.h:504,
                    from include/linux/bitops.h:36,
                    from include/linux/kernel.h:10,
                    from include/linux/list.h:8,
                    from include/linux/timer.h:4,
                    from include/linux/workqueue.h:8,
                    from drivers/media/usb/em28xx/em28xx.h:32,
                    from drivers/media/usb/em28xx/em28xx-input.c:24:
   drivers/media/usb/em28xx/em28xx-input.c:589:40: error: 'struct em28xx' has no member named 'udev'; did you mean 'adev'?
     input_dev->id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
                                           ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: in definition of macro '__le16_to_cpu'
    #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
                                                      ^
   drivers/media/usb/em28xx/em28xx-input.c:589:25: note: in expansion of macro 'le16_to_cpu'
     input_dev->id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
                            ^~~~~~~~~~~
   drivers/media/usb/em28xx/em28xx-input.c:590:41: error: 'struct em28xx' has no member named 'udev'; did you mean 'adev'?
     input_dev->id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
                                            ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: in definition of macro '__le16_to_cpu'
    #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
                                                      ^
   drivers/media/usb/em28xx/em28xx-input.c:590:26: note: in expansion of macro 'le16_to_cpu'
     input_dev->id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
                             ^~~~~~~~~~~
   drivers/media/usb/em28xx/em28xx-input.c: In function 'em28xx_ir_init':
   drivers/media/usb/em28xx/em28xx-input.c:802:19: error: 'struct em28xx' has no member named 'udev'; did you mean 'adev'?
     usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
                      ^~
   In file included from include/linux/byteorder/little_endian.h:4:0,
                    from arch/x86/include/uapi/asm/byteorder.h:4,
                    from include/asm-generic/bitops/le.h:5,
                    from arch/x86/include/asm/bitops.h:504,
                    from include/linux/bitops.h:36,
                    from include/linux/kernel.h:10,
                    from include/linux/list.h:8,
                    from include/linux/timer.h:4,
                    from include/linux/workqueue.h:8,
                    from drivers/media/usb/em28xx/em28xx.h:32,
                    from drivers/media/usb/em28xx/em28xx-input.c:24:
   drivers/media/usb/em28xx/em28xx-input.c:809:39: error: 'struct em28xx' has no member named 'udev'; did you mean 'adev'?
     rc->input_id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
                                          ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: in definition of macro '__le16_to_cpu'
    #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
                                                      ^
   drivers/media/usb/em28xx/em28xx-input.c:809:24: note: in expansion of macro 'le16_to_cpu'
     rc->input_id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
                           ^~~~~~~~~~~
   drivers/media/usb/em28xx/em28xx-input.c:810:40: error: 'struct em28xx' has no member named 'udev'; did you mean 'adev'?
     rc->input_id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
                                           ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: in definition of macro '__le16_to_cpu'
    #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
                                                      ^
   drivers/media/usb/em28xx/em28xx-input.c:810:25: note: in expansion of macro 'le16_to_cpu'
     rc->input_id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
                            ^~~~~~~~~~~

vim +589 drivers/media/usb/em28xx/em28xx-input.c

769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26  571  
42d0e2158 drivers/media/usb/em28xx/em28xx-input.c   Mauro Carvalho Chehab 2016-12-08  572  	dev_info(&dev->intf->dev, "Registering snapshot button...\n");
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26  573  	input_dev = input_allocate_device();
da4a73394 drivers/media/usb/em28xx/em28xx-input.c   Joe Perches           2013-10-23  574  	if (!input_dev)
f52226099 drivers/media/usb/em28xx/em28xx-input.c   Frank Schaefer        2013-12-01  575  		return -ENOMEM;
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26  576  
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26 @577  	usb_make_path(dev->udev, dev->snapshot_button_path,
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26  578  		      sizeof(dev->snapshot_button_path));
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26  579  	strlcat(dev->snapshot_button_path, "/sbutton",
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26  580  		sizeof(dev->snapshot_button_path));
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26  581  
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26  582  	input_dev->name = "em28xx snapshot button";
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26  583  	input_dev->phys = dev->snapshot_button_path;
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26  584  	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26  585  	set_bit(EM28XX_SNAPSHOT_KEY, input_dev->keybit);
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26  586  	input_dev->keycodesize = 0;
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26  587  	input_dev->keycodemax = 0;
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26  588  	input_dev->id.bustype = BUS_USB;
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26 @589  	input_dev->id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26  590  	input_dev->id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
769af2146 drivers/media/video/em28xx/em28xx-input.c Ezequiel García       2012-03-26  591  	input_dev->id.version = 1;
42d0e2158 drivers/media/usb/em28xx/em28xx-input.c   Mauro Carvalho Chehab 2016-12-08  592  	input_dev->dev.parent = &dev->intf->dev;

:::::: The code at line 589 was first introduced by commit
:::::: 769af2146a93c27c8834dbca54c02cd67468036d [media] em28xx: Change scope of em28xx-input local functions to static

:::::: TO: Ezequiel García <elezegarcia@gmail.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
