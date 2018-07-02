Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:34064 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753356AbeGBLid (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 07:38:33 -0400
Subject: Re: [RESEND][PATCH v6 3/6] cx25840: add pin to pad mapping and output
 format configuration
To: Dan Carpenter <dan.carpenter@oracle.com>, kbuild@01.org
Cc: kbuild-all@01.org, Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
References: <20180702055548.4puqbtjzgf2afyyb@mwanda>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <80ad8df5-f826-67bf-8ec5-f30aa70cf426@maciej.szmigiero.name>
Date: Mon, 2 Jul 2018 13:38:29 +0200
MIME-Version: 1.0
In-Reply-To: <20180702055548.4puqbtjzgf2afyyb@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

On 02.07.2018 07:55, Dan Carpenter wrote:
> Hi Maciej,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> url:    https://github.com/0day-ci/linux/commits/Maciej-S-Szmigiero/Add-analog-mode-support-for-Medion-MD95700/20180630-050341
> base:   git://linuxtv.org/media_tree.git master
> 
> New smatch warnings:
> drivers/media/i2c/cx25840/cx25840-core.c:468 cx25840_s_io_pin_config() warn: bitwise AND condition is false here
> 
> Old smatch warnings:
> drivers/media/i2c/cx25840/cx25840-core.c:497 cx25840_s_io_pin_config() warn: bitwise AND condition is false here
> drivers/media/i2c/cx25840/cx25840-core.c:526 cx25840_s_io_pin_config() warn: bitwise AND condition is false here
> 
> # https://github.com/0day-ci/linux/commit/64372f380e540a77b73d4628a585c9c92956a7fd
> git remote add linux-review https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout 64372f380e540a77b73d4628a585c9c92956a7fd
> vim +468 drivers/media/i2c/cx25840/cx25840-core.c
> 
> 64372f38 Maciej S. Szmigiero 2018-06-29  435  
> 64372f38 Maciej S. Szmigiero 2018-06-29  436  static int cx25840_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
> 64372f38 Maciej S. Szmigiero 2018-06-29  437  				   struct v4l2_subdev_io_pin_config *p)
> 64372f38 Maciej S. Szmigiero 2018-06-29  438  {
> 64372f38 Maciej S. Szmigiero 2018-06-29  439  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> 64372f38 Maciej S. Szmigiero 2018-06-29  440  	unsigned int i;
> 64372f38 Maciej S. Szmigiero 2018-06-29  441  	u8 pinctrl[6], pinconf[10], voutctrl4;
> 64372f38 Maciej S. Szmigiero 2018-06-29  442  
> 64372f38 Maciej S. Szmigiero 2018-06-29  443  	for (i = 0; i < 6; i++)
> 64372f38 Maciej S. Szmigiero 2018-06-29  444  		pinctrl[i] = cx25840_read(client, 0x114 + i);
> 64372f38 Maciej S. Szmigiero 2018-06-29  445  
> 64372f38 Maciej S. Szmigiero 2018-06-29  446  	for (i = 0; i < 10; i++)
> 64372f38 Maciej S. Szmigiero 2018-06-29  447  		pinconf[i] = cx25840_read(client, 0x11c + i);
> 64372f38 Maciej S. Szmigiero 2018-06-29  448  
> 64372f38 Maciej S. Szmigiero 2018-06-29  449  	voutctrl4 = cx25840_read(client, 0x407);
> 64372f38 Maciej S. Szmigiero 2018-06-29  450  
> 64372f38 Maciej S. Szmigiero 2018-06-29  451  	for (i = 0; i < n; i++) {
> 64372f38 Maciej S. Szmigiero 2018-06-29  452  		u8 strength = p[i].strength;
> 64372f38 Maciej S. Szmigiero 2018-06-29  453  
> 64372f38 Maciej S. Szmigiero 2018-06-29  454  		if (strength != CX25840_PIN_DRIVE_SLOW &&
> 64372f38 Maciej S. Szmigiero 2018-06-29  455  		    strength != CX25840_PIN_DRIVE_MEDIUM &&
> 64372f38 Maciej S. Szmigiero 2018-06-29  456  		    strength != CX25840_PIN_DRIVE_FAST) {
> 64372f38 Maciej S. Szmigiero 2018-06-29  457  
> 64372f38 Maciej S. Szmigiero 2018-06-29  458  			v4l_err(client,
> 64372f38 Maciej S. Szmigiero 2018-06-29  459  				"invalid drive speed for pin %u (%u), assuming fast\n",
> 64372f38 Maciej S. Szmigiero 2018-06-29  460  				(unsigned int)p[i].pin,
> 64372f38 Maciej S. Szmigiero 2018-06-29  461  				(unsigned int)strength);
> 64372f38 Maciej S. Szmigiero 2018-06-29  462  
> 64372f38 Maciej S. Szmigiero 2018-06-29  463  			strength = CX25840_PIN_DRIVE_FAST;
> 64372f38 Maciej S. Szmigiero 2018-06-29  464  		}
> 64372f38 Maciej S. Szmigiero 2018-06-29  465  
> 64372f38 Maciej S. Szmigiero 2018-06-29  466  		switch (p[i].pin) {
> 64372f38 Maciej S. Szmigiero 2018-06-29  467  		case CX25840_PIN_DVALID_PRGM0:
> 64372f38 Maciej S. Szmigiero 2018-06-29 @468  			if (p[i].flags & V4L2_SUBDEV_IO_PIN_DISABLE)
> 
> V4L2_SUBDEV_IO_PIN_DISABLE is zero.  It's sometimes used as a bit zero
> BIT(V4L2_SUBDEV_IO_PIN_DISABLE) and presumably that's what is intended
> here.

Good catch, thanks.
Before commit 4eb2f55728abbe ("media: v4l2-subdev: better document IO pin configuration flags")
these identifiers were bit masks, now they are bit numbers.

This wasn't caught in testing since the cxusb driver always passes zero
as flags anyway.

Maciej
