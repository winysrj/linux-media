Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35846 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753423AbeBSSmr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 13:42:47 -0500
Date: Mon, 19 Feb 2018 15:42:42 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [bug report] V4L/DVB (3420): Added iocls to configure VBI on
 tvp5150
Message-ID: <20180219154242.2e288022@vento.lan>
In-Reply-To: <20180219142751.GA10113@mwanda>
References: <20180219142751.GA10113@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 19 Feb 2018 17:27:52 +0300
Dan Carpenter <dan.carpenter@oracle.com> escreveu:

> [ This is obviously ancient code.  It's probably fine.  I've just been
>   going through all array overflow warnings recently.  - dan ]
> 
> Hello Mauro Carvalho Chehab,
> 
> The patch 12db56071b47: "V4L/DVB (3420): Added iocls to configure VBI
> on tvp5150" from Jan 23, 2006, leads to the following static checker
> warning:
> 
> 	drivers/media/i2c/tvp5150.c:730 tvp5150_get_vbi()
> 	error: buffer overflow 'regs' 5 <= 14
> 
> drivers/media/i2c/tvp5150.c
>    699  static int tvp5150_get_vbi(struct v4l2_subdev *sd,
>    700                          const struct i2c_vbi_ram_value *regs, int line)
>    701  {
>    702          struct tvp5150 *decoder = to_tvp5150(sd);
>    703          v4l2_std_id std = decoder->norm;
>    704          u8 reg;
>    705          int pos, type = 0;
>    706          int i, ret = 0;
>    707  
>    708          if (std == V4L2_STD_ALL) {
>    709                  dev_err(sd->dev, "VBI can't be configured without knowing number of lines\n");
>    710                  return 0;
>    711          } else if (std & V4L2_STD_625_50) {
>    712                  /* Don't follow NTSC Line number convension */
>    713                  line += 3;
>    714          }
>    715  
>    716          if (line < 6 || line > 27)
>    717                  return 0;
>    718  
>    719          reg = ((line - 6) << 1) + TVP5150_LINE_MODE_INI;
>    720  
>    721          for (i = 0; i <= 1; i++) {
>    722                  ret = tvp5150_read(sd, reg + i);
>    723                  if (ret < 0) {
>    724                          dev_err(sd->dev, "%s: failed with error = %d\n",
>    725                                   __func__, ret);
>    726                          return 0;
>    727                  }
>    728                  pos = ret & 0x0f;
>    729                  if (pos < 0x0f)
>                             ^^^^^^^^^^
> Smatch thinks this implies pos can be 0-14.
> 
>    730                          type |= regs[pos].type.vbi_type;
>                                         ^^^^^^^^^
> This array only has 5 elements.
> 
>    731          }
>    732  
>    733          return type;
>    734  }

Nice catch! This is indeed a bug. The fact is that no caller drivers
currently use the sliced VBI API. Due to that, in practice, this shouldn't
be causing any harm.

Yet, better to fix it. IMHO, the better fix would be a patch like the
one below.

Regards,

Thanks,
Mauro
