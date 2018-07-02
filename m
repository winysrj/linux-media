Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40686 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753133AbeGBF4S (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 01:56:18 -0400
Date: Mon, 2 Jul 2018 08:55:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild@01.org, "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: kbuild-all@01.org, Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RESEND][PATCH v6 3/6] cx25840: add pin to pad mapping and
 output format configuration
Message-ID: <20180702055548.4puqbtjzgf2afyyb@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69af3169d998d78c4ce1fe8702ff795dbe89b4b7.1530305665.git.mail@maciej.szmigiero.name>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maciej,

Thank you for the patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Maciej-S-Szmigiero/Add-analog-mode-support-for-Medion-MD95700/20180630-050341
base:   git://linuxtv.org/media_tree.git master

New smatch warnings:
drivers/media/i2c/cx25840/cx25840-core.c:468 cx25840_s_io_pin_config() warn: bitwise AND condition is false here

Old smatch warnings:
drivers/media/i2c/cx25840/cx25840-core.c:497 cx25840_s_io_pin_config() warn: bitwise AND condition is false here
drivers/media/i2c/cx25840/cx25840-core.c:526 cx25840_s_io_pin_config() warn: bitwise AND condition is false here

# https://github.com/0day-ci/linux/commit/64372f380e540a77b73d4628a585c9c92956a7fd
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 64372f380e540a77b73d4628a585c9c92956a7fd
vim +468 drivers/media/i2c/cx25840/cx25840-core.c

64372f38 Maciej S. Szmigiero 2018-06-29  435  
64372f38 Maciej S. Szmigiero 2018-06-29  436  static int cx25840_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
64372f38 Maciej S. Szmigiero 2018-06-29  437  				   struct v4l2_subdev_io_pin_config *p)
64372f38 Maciej S. Szmigiero 2018-06-29  438  {
64372f38 Maciej S. Szmigiero 2018-06-29  439  	struct i2c_client *client = v4l2_get_subdevdata(sd);
64372f38 Maciej S. Szmigiero 2018-06-29  440  	unsigned int i;
64372f38 Maciej S. Szmigiero 2018-06-29  441  	u8 pinctrl[6], pinconf[10], voutctrl4;
64372f38 Maciej S. Szmigiero 2018-06-29  442  
64372f38 Maciej S. Szmigiero 2018-06-29  443  	for (i = 0; i < 6; i++)
64372f38 Maciej S. Szmigiero 2018-06-29  444  		pinctrl[i] = cx25840_read(client, 0x114 + i);
64372f38 Maciej S. Szmigiero 2018-06-29  445  
64372f38 Maciej S. Szmigiero 2018-06-29  446  	for (i = 0; i < 10; i++)
64372f38 Maciej S. Szmigiero 2018-06-29  447  		pinconf[i] = cx25840_read(client, 0x11c + i);
64372f38 Maciej S. Szmigiero 2018-06-29  448  
64372f38 Maciej S. Szmigiero 2018-06-29  449  	voutctrl4 = cx25840_read(client, 0x407);
64372f38 Maciej S. Szmigiero 2018-06-29  450  
64372f38 Maciej S. Szmigiero 2018-06-29  451  	for (i = 0; i < n; i++) {
64372f38 Maciej S. Szmigiero 2018-06-29  452  		u8 strength = p[i].strength;
64372f38 Maciej S. Szmigiero 2018-06-29  453  
64372f38 Maciej S. Szmigiero 2018-06-29  454  		if (strength != CX25840_PIN_DRIVE_SLOW &&
64372f38 Maciej S. Szmigiero 2018-06-29  455  		    strength != CX25840_PIN_DRIVE_MEDIUM &&
64372f38 Maciej S. Szmigiero 2018-06-29  456  		    strength != CX25840_PIN_DRIVE_FAST) {
64372f38 Maciej S. Szmigiero 2018-06-29  457  
64372f38 Maciej S. Szmigiero 2018-06-29  458  			v4l_err(client,
64372f38 Maciej S. Szmigiero 2018-06-29  459  				"invalid drive speed for pin %u (%u), assuming fast\n",
64372f38 Maciej S. Szmigiero 2018-06-29  460  				(unsigned int)p[i].pin,
64372f38 Maciej S. Szmigiero 2018-06-29  461  				(unsigned int)strength);
64372f38 Maciej S. Szmigiero 2018-06-29  462  
64372f38 Maciej S. Szmigiero 2018-06-29  463  			strength = CX25840_PIN_DRIVE_FAST;
64372f38 Maciej S. Szmigiero 2018-06-29  464  		}
64372f38 Maciej S. Szmigiero 2018-06-29  465  
64372f38 Maciej S. Szmigiero 2018-06-29  466  		switch (p[i].pin) {
64372f38 Maciej S. Szmigiero 2018-06-29  467  		case CX25840_PIN_DVALID_PRGM0:
64372f38 Maciej S. Szmigiero 2018-06-29 @468  			if (p[i].flags & V4L2_SUBDEV_IO_PIN_DISABLE)

V4L2_SUBDEV_IO_PIN_DISABLE is zero.  It's sometimes used as a bit zero
BIT(V4L2_SUBDEV_IO_PIN_DISABLE) and presumably that's what is intended
here.

64372f38 Maciej S. Szmigiero 2018-06-29  469  				pinctrl[0] &= ~BIT(6);
64372f38 Maciej S. Szmigiero 2018-06-29  470  			else
64372f38 Maciej S. Szmigiero 2018-06-29  471  				pinctrl[0] |= BIT(6);
64372f38 Maciej S. Szmigiero 2018-06-29  472  
64372f38 Maciej S. Szmigiero 2018-06-29  473  			pinconf[3] &= 0xf0;
64372f38 Maciej S. Szmigiero 2018-06-29  474  			pinconf[3] |= cx25840_function_to_pad(client,
64372f38 Maciej S. Szmigiero 2018-06-29  475  							      p[i].function);
64372f38 Maciej S. Szmigiero 2018-06-29  476  
64372f38 Maciej S. Szmigiero 2018-06-29  477  			cx25840_set_invert(&pinctrl[3], &voutctrl4,
64372f38 Maciej S. Szmigiero 2018-06-29  478  					   p[i].function,
64372f38 Maciej S. Szmigiero 2018-06-29  479  					   CX25840_PIN_DVALID_PRGM0,
64372f38 Maciej S. Szmigiero 2018-06-29  480  					   p[i].flags &
64372f38 Maciej S. Szmigiero 2018-06-29  481  					   V4L2_SUBDEV_IO_PIN_ACTIVE_LOW);
64372f38 Maciej S. Szmigiero 2018-06-29  482  
64372f38 Maciej S. Szmigiero 2018-06-29  483  			pinctrl[4] &= ~(3 << 2); /* CX25840_PIN_DRIVE_MEDIUM */
64372f38 Maciej S. Szmigiero 2018-06-29  484  			switch (strength) {
64372f38 Maciej S. Szmigiero 2018-06-29  485  			case CX25840_PIN_DRIVE_SLOW:
64372f38 Maciej S. Szmigiero 2018-06-29  486  				pinctrl[4] |= 1 << 2;
64372f38 Maciej S. Szmigiero 2018-06-29  487  				break;
64372f38 Maciej S. Szmigiero 2018-06-29  488  
64372f38 Maciej S. Szmigiero 2018-06-29  489  			case CX25840_PIN_DRIVE_FAST:
64372f38 Maciej S. Szmigiero 2018-06-29  490  				pinctrl[4] |= 2 << 2;
64372f38 Maciej S. Szmigiero 2018-06-29  491  				break;
64372f38 Maciej S. Szmigiero 2018-06-29  492  			}
64372f38 Maciej S. Szmigiero 2018-06-29  493  
64372f38 Maciej S. Szmigiero 2018-06-29  494  			break;
64372f38 Maciej S. Szmigiero 2018-06-29  495  
64372f38 Maciej S. Szmigiero 2018-06-29  496  		case CX25840_PIN_HRESET_PRGM2:
64372f38 Maciej S. Szmigiero 2018-06-29  497  			if (p[i].flags & V4L2_SUBDEV_IO_PIN_DISABLE)
64372f38 Maciej S. Szmigiero 2018-06-29  498  				pinctrl[1] &= ~BIT(0);
64372f38 Maciej S. Szmigiero 2018-06-29  499  			else
64372f38 Maciej S. Szmigiero 2018-06-29  500  				pinctrl[1] |= BIT(0);
64372f38 Maciej S. Szmigiero 2018-06-29  501  
64372f38 Maciej S. Szmigiero 2018-06-29  502  			pinconf[4] &= 0xf0;
64372f38 Maciej S. Szmigiero 2018-06-29  503  			pinconf[4] |= cx25840_function_to_pad(client,
64372f38 Maciej S. Szmigiero 2018-06-29  504  							      p[i].function);
64372f38 Maciej S. Szmigiero 2018-06-29  505  
64372f38 Maciej S. Szmigiero 2018-06-29  506  			cx25840_set_invert(&pinctrl[3], &voutctrl4,
64372f38 Maciej S. Szmigiero 2018-06-29  507  					   p[i].function,
64372f38 Maciej S. Szmigiero 2018-06-29  508  					   CX25840_PIN_HRESET_PRGM2,
64372f38 Maciej S. Szmigiero 2018-06-29  509  					   p[i].flags &
64372f38 Maciej S. Szmigiero 2018-06-29  510  					   V4L2_SUBDEV_IO_PIN_ACTIVE_LOW);
64372f38 Maciej S. Szmigiero 2018-06-29  511  
64372f38 Maciej S. Szmigiero 2018-06-29  512  			pinctrl[4] &= ~(3 << 2); /* CX25840_PIN_DRIVE_MEDIUM */
64372f38 Maciej S. Szmigiero 2018-06-29  513  			switch (strength) {
64372f38 Maciej S. Szmigiero 2018-06-29  514  			case CX25840_PIN_DRIVE_SLOW:
64372f38 Maciej S. Szmigiero 2018-06-29  515  				pinctrl[4] |= 1 << 2;
64372f38 Maciej S. Szmigiero 2018-06-29  516  				break;
64372f38 Maciej S. Szmigiero 2018-06-29  517  
64372f38 Maciej S. Szmigiero 2018-06-29  518  			case CX25840_PIN_DRIVE_FAST:
64372f38 Maciej S. Szmigiero 2018-06-29  519  				pinctrl[4] |= 2 << 2;
64372f38 Maciej S. Szmigiero 2018-06-29  520  				break;
64372f38 Maciej S. Szmigiero 2018-06-29  521  			}
64372f38 Maciej S. Szmigiero 2018-06-29  522  
64372f38 Maciej S. Szmigiero 2018-06-29  523  			break;
64372f38 Maciej S. Szmigiero 2018-06-29  524  
64372f38 Maciej S. Szmigiero 2018-06-29  525  		case CX25840_PIN_PLL_CLK_PRGM7:
64372f38 Maciej S. Szmigiero 2018-06-29  526  			if (p[i].flags & V4L2_SUBDEV_IO_PIN_DISABLE)
64372f38 Maciej S. Szmigiero 2018-06-29  527  				pinctrl[2] &= ~BIT(2);
64372f38 Maciej S. Szmigiero 2018-06-29  528  			else
64372f38 Maciej S. Szmigiero 2018-06-29  529  				pinctrl[2] |= BIT(2);
64372f38 Maciej S. Szmigiero 2018-06-29  530  
64372f38 Maciej S. Szmigiero 2018-06-29  531  			switch (p[i].function) {
64372f38 Maciej S. Szmigiero 2018-06-29  532  			case CX25840_PAD_XTI_X5_DLL:
64372f38 Maciej S. Szmigiero 2018-06-29  533  				pinconf[6] = 0;
64372f38 Maciej S. Szmigiero 2018-06-29  534  				break;
64372f38 Maciej S. Szmigiero 2018-06-29  535  
64372f38 Maciej S. Szmigiero 2018-06-29  536  			case CX25840_PAD_AUX_PLL:
64372f38 Maciej S. Szmigiero 2018-06-29  537  				pinconf[6] = 1;
64372f38 Maciej S. Szmigiero 2018-06-29  538  				break;
64372f38 Maciej S. Szmigiero 2018-06-29  539  
64372f38 Maciej S. Szmigiero 2018-06-29  540  			case CX25840_PAD_VID_PLL:
64372f38 Maciej S. Szmigiero 2018-06-29  541  				pinconf[6] = 5;
64372f38 Maciej S. Szmigiero 2018-06-29  542  				break;
64372f38 Maciej S. Szmigiero 2018-06-29  543  
64372f38 Maciej S. Szmigiero 2018-06-29  544  			case CX25840_PAD_XTI:
64372f38 Maciej S. Szmigiero 2018-06-29  545  				pinconf[6] = 2;
64372f38 Maciej S. Szmigiero 2018-06-29  546  				break;
64372f38 Maciej S. Szmigiero 2018-06-29  547  
64372f38 Maciej S. Szmigiero 2018-06-29  548  			default:
64372f38 Maciej S. Szmigiero 2018-06-29  549  				pinconf[6] = 3;
64372f38 Maciej S. Szmigiero 2018-06-29  550  				pinconf[6] |=
64372f38 Maciej S. Szmigiero 2018-06-29  551  					cx25840_function_to_pad(client,
64372f38 Maciej S. Szmigiero 2018-06-29  552  								p[i].function)
64372f38 Maciej S. Szmigiero 2018-06-29  553  					<< 4;
64372f38 Maciej S. Szmigiero 2018-06-29  554  			}
64372f38 Maciej S. Szmigiero 2018-06-29  555  
64372f38 Maciej S. Szmigiero 2018-06-29  556  			break;
64372f38 Maciej S. Szmigiero 2018-06-29  557  
64372f38 Maciej S. Szmigiero 2018-06-29  558  		default:
64372f38 Maciej S. Szmigiero 2018-06-29  559  			v4l_err(client, "invalid or unsupported pin %u\n",
64372f38 Maciej S. Szmigiero 2018-06-29  560  				(unsigned int)p[i].pin);
64372f38 Maciej S. Szmigiero 2018-06-29  561  			break;
64372f38 Maciej S. Szmigiero 2018-06-29  562  		}
64372f38 Maciej S. Szmigiero 2018-06-29  563  	}
64372f38 Maciej S. Szmigiero 2018-06-29  564  
64372f38 Maciej S. Szmigiero 2018-06-29  565  	cx25840_write(client, 0x407, voutctrl4);
64372f38 Maciej S. Szmigiero 2018-06-29  566  
64372f38 Maciej S. Szmigiero 2018-06-29  567  	for (i = 0; i < 6; i++)
64372f38 Maciej S. Szmigiero 2018-06-29  568  		cx25840_write(client, 0x114 + i, pinctrl[i]);
64372f38 Maciej S. Szmigiero 2018-06-29  569  
64372f38 Maciej S. Szmigiero 2018-06-29  570  	for (i = 0; i < 10; i++)
64372f38 Maciej S. Szmigiero 2018-06-29  571  		cx25840_write(client, 0x11c + i, pinconf[i]);
64372f38 Maciej S. Szmigiero 2018-06-29  572  
64372f38 Maciej S. Szmigiero 2018-06-29  573  	return 0;
64372f38 Maciej S. Szmigiero 2018-06-29  574  }
64372f38 Maciej S. Szmigiero 2018-06-29  575  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
