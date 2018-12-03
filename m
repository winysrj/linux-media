Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34800 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbeLCKl1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 05:41:27 -0500
Date: Mon, 3 Dec 2018 13:42:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild@01.org, Lubomir Rintel <lkundrak@v3.sk>
Cc: kbuild-all@01.org, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>
Subject: Re: [PATCH 3/6] media: ov2659: get rid of extra ifdefs
Message-ID: <20181203104228.GC3073@unbuntlaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128171918.160643-4-lkundrak@v3.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lubomir,

url:    https://github.com/0day-ci/linux/commits/Lubomir-Rintel/media-don-t-ifdef-v4l2_subdev_get_try_format-any-more/20181129-205631
base:   git://linuxtv.org/media_tree.git master

smatch warnings:
drivers/media/i2c/ov2659.c:1157 ov2659_set_fmt() warn: inconsistent returns 'mutex:&ov2659->lock'.
  Locked on:   line 1129
  Unlocked on: line 1119

# https://github.com/0day-ci/linux/commit/ceed6707bbb8d34fa04448a9eaf77a574dae59a8
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout ceed6707bbb8d34fa04448a9eaf77a574dae59a8
vim +1157 drivers/media/i2c/ov2659.c

c4c0283a Benoit Parrot  2015-03-20  1098  
c4c0283a Benoit Parrot  2015-03-20  1099  static int ov2659_set_fmt(struct v4l2_subdev *sd,
c4c0283a Benoit Parrot  2015-03-20  1100  			  struct v4l2_subdev_pad_config *cfg,
c4c0283a Benoit Parrot  2015-03-20  1101  			  struct v4l2_subdev_format *fmt)
c4c0283a Benoit Parrot  2015-03-20  1102  {
c4c0283a Benoit Parrot  2015-03-20  1103  	struct i2c_client *client = v4l2_get_subdevdata(sd);
5f5859d1 Dan Carpenter  2015-04-15  1104  	int index = ARRAY_SIZE(ov2659_formats);
c4c0283a Benoit Parrot  2015-03-20  1105  	struct v4l2_mbus_framefmt *mf = &fmt->format;
c4c0283a Benoit Parrot  2015-03-20  1106  	const struct ov2659_framesize *size = NULL;
c4c0283a Benoit Parrot  2015-03-20  1107  	struct ov2659 *ov2659 = to_ov2659(sd);
c4c0283a Benoit Parrot  2015-03-20  1108  	int ret = 0;
c4c0283a Benoit Parrot  2015-03-20  1109  
c4c0283a Benoit Parrot  2015-03-20  1110  	dev_dbg(&client->dev, "ov2659_set_fmt\n");
c4c0283a Benoit Parrot  2015-03-20  1111  
c4c0283a Benoit Parrot  2015-03-20  1112  	__ov2659_try_frame_size(mf, &size);
c4c0283a Benoit Parrot  2015-03-20  1113  
c4c0283a Benoit Parrot  2015-03-20  1114  	while (--index >= 0)
c4c0283a Benoit Parrot  2015-03-20  1115  		if (ov2659_formats[index].code == mf->code)
c4c0283a Benoit Parrot  2015-03-20  1116  			break;
c4c0283a Benoit Parrot  2015-03-20  1117  
c4c0283a Benoit Parrot  2015-03-20  1118  	if (index < 0)
c4c0283a Benoit Parrot  2015-03-20  1119  		return -EINVAL;
c4c0283a Benoit Parrot  2015-03-20  1120  
c4c0283a Benoit Parrot  2015-03-20  1121  	mf->colorspace = V4L2_COLORSPACE_SRGB;
c4c0283a Benoit Parrot  2015-03-20  1122  	mf->field = V4L2_FIELD_NONE;
c4c0283a Benoit Parrot  2015-03-20  1123  
c4c0283a Benoit Parrot  2015-03-20  1124  	mutex_lock(&ov2659->lock);
c4c0283a Benoit Parrot  2015-03-20  1125  
c4c0283a Benoit Parrot  2015-03-20  1126  	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
c4c0283a Benoit Parrot  2015-03-20  1127  		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
ceed6707 Lubomir Rintel 2018-11-28  1128  		if (IS_ERR(mf))
ceed6707 Lubomir Rintel 2018-11-28  1129  			return PTR_ERR(mf);
                                                                ^^^^^^^^^^^^^^^^^^
goto unlock;

c4c0283a Benoit Parrot  2015-03-20  1130  		*mf = fmt->format;
c4c0283a Benoit Parrot  2015-03-20  1131  	} else {
c4c0283a Benoit Parrot  2015-03-20  1132  		s64 val;
c4c0283a Benoit Parrot  2015-03-20  1133  
c4c0283a Benoit Parrot  2015-03-20  1134  		if (ov2659->streaming) {
c4c0283a Benoit Parrot  2015-03-20  1135  			mutex_unlock(&ov2659->lock);
c4c0283a Benoit Parrot  2015-03-20  1136  			return -EBUSY;
c4c0283a Benoit Parrot  2015-03-20  1137  		}
c4c0283a Benoit Parrot  2015-03-20  1138  
c4c0283a Benoit Parrot  2015-03-20  1139  		ov2659->frame_size = size;
c4c0283a Benoit Parrot  2015-03-20  1140  		ov2659->format = fmt->format;
c4c0283a Benoit Parrot  2015-03-20  1141  		ov2659->format_ctrl_regs =
c4c0283a Benoit Parrot  2015-03-20  1142  			ov2659_formats[index].format_ctrl_regs;
c4c0283a Benoit Parrot  2015-03-20  1143  
c4c0283a Benoit Parrot  2015-03-20  1144  		if (ov2659->format.code != MEDIA_BUS_FMT_SBGGR8_1X8)
c4c0283a Benoit Parrot  2015-03-20  1145  			val = ov2659->pdata->link_frequency / 2;
c4c0283a Benoit Parrot  2015-03-20  1146  		else
c4c0283a Benoit Parrot  2015-03-20  1147  			val = ov2659->pdata->link_frequency;
c4c0283a Benoit Parrot  2015-03-20  1148  
c4c0283a Benoit Parrot  2015-03-20  1149  		ret = v4l2_ctrl_s_ctrl_int64(ov2659->link_frequency, val);
c4c0283a Benoit Parrot  2015-03-20  1150  		if (ret < 0)
c4c0283a Benoit Parrot  2015-03-20  1151  			dev_warn(&client->dev,
c4c0283a Benoit Parrot  2015-03-20  1152  				 "failed to set link_frequency rate (%d)\n",
c4c0283a Benoit Parrot  2015-03-20  1153  				 ret);
c4c0283a Benoit Parrot  2015-03-20  1154  	}
c4c0283a Benoit Parrot  2015-03-20  1155  
c4c0283a Benoit Parrot  2015-03-20  1156  	mutex_unlock(&ov2659->lock);
c4c0283a Benoit Parrot  2015-03-20 @1157  	return ret;
c4c0283a Benoit Parrot  2015-03-20  1158  }
c4c0283a Benoit Parrot  2015-03-20  1159  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
