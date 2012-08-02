Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36540 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2HBULi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 16:11:38 -0400
Received: by bkwj10 with SMTP id j10so4420769bkw.19
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2012 13:11:37 -0700 (PDT)
Message-ID: <501ADEF6.1080901@gmail.com>
Date: Thu, 02 Aug 2012 22:11:34 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org
Subject: Re: [PATH v3 0/2] Add v4l2 subdev driver for S5K4ECGX sensor with
 embedded SoC ISP
References: <1343914971-23007-1-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1343914971-23007-1-git-send-email-sangwook.lee@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sangwook,

On 08/02/2012 03:42 PM, Sangwook Lee wrote:
> The following 2 patches add driver for S5K4ECGX sensor with embedded ISP SoC,
> and minor v4l2 control API enhancement. S5K4ECGX is 5M CMOS Image sensor from Samsung
> 
> Changes since v2:
> - added GPIO (reset/stby) and regulators
> - updated I2C read/write, based on s5k6aa datasheet
> - fixed set_fmt errors
> - reduced register tables a bit
> - removed vmalloc

It looks like a great improvement, well done! Thanks!

In the S5K4CAGX sensor datasheet, that can be found on the internet,
there is 0x0000...0x002E registers description, which look very much
same as in S5K6AAFX case and likely is also valid for S5K4CAGX.

My second thought was, if we won't be able to get rid of those hundreds
of initial register values, to convert them to regular firmware blob.
And add regular firmware handling at the driver. I know it may sound
not standard but imagine dozens of such sensor drivers coexisting in
the mainline kernel. The source code would have been mainly register
address/value arrays...

What do you think about converting s5k4ecgx_img_regs arrays (it has
over 2700 entries) to a firmware file and adding some simple parser
to the driver ? Then we would have the problem solved in most part.

Regarding various preview resolution set up, the difference in all
those s5k4ecgx_*_preview[] arrays is rather small, only register
values differ, e.g. for 640x480 and 720x480 there is only 8 different
entries:

$ diff -a s5k4ec_640.txt s5k4ec_720.txt 
1c1
< static const struct regval_list s5k4ecgx_640_preview[] = {
---
> static const struct regval_list s5k4ecgx_720_preview[] = {
3c3
< 	{ 0x70000252, 0x0780 },
---
> 	{ 0x70000252, 0x06a8 },
5c5
< 	{ 0x70000256, 0x000c },
---
> 	{ 0x70000256, 0x0078 },
7c7
< 	{ 0x7000025a, 0x0780 },
---
> 	{ 0x7000025a, 0x06a8 },
9c9
< 	{ 0x7000025e, 0x000c },
---
> 	{ 0x7000025e, 0x0078 },
11c11
< 	{ 0x70000496, 0x0780 },
---
> 	{ 0x70000496, 0x06a8 },
15c15
< 	{ 0x7000049e, 0x0780 },
---
> 	{ 0x7000049e, 0x06a8 },
21c21
< 	{ 0x700002a6, 0x0280 },
---
> 	{ 0x700002a6, 0x02d0 },
28c28
< 	{ 0x700002c4, 0x014a },
---
> 	{ 0x700002c4, 0x014d },

I've found S5K4ECGX sensor datasheet on internet (Rev 0.07), and on a quick
look the description of most of registers from those tables could be found 
there.

Could you please try to implement a function that replaces those tables, 
based s5k6aa_set_prev_config() and s5k6aa_set_output_framefmt() ?

Regards,
Sylwester
