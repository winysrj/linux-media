Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40062 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932679AbeCEHVU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2018 02:21:20 -0500
Date: Mon, 5 Mar 2018 10:21:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: jacopo+renesas@jmondi.org, linux-media@vger.kernel.org
Subject: Re: [bug report] media: i2c: Copy tw9910 soc_camera sensor driver
Message-ID: <20180305072109.xl446yralwhapdap@mwanda>
References: <20180301095954.GA12656@mwanda>
 <20180302142016.GG4023@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180302142016.GG4023@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 02, 2018 at 03:20:16PM +0100, jacopo mondi wrote:
> Hi Dan,
> 
> On Thu, Mar 01, 2018 at 12:59:54PM +0300, Dan Carpenter wrote:
> > [ I know you're just copying files, but you might have a fix for these
> >   since you're looking at the code.  - dan ]
> 
> According to the static analyzer I should simply substitute all those
> expressions with 0s.

I really try not to print warnings for stuff which is just white space
complaints like that.  For example, Smatch ignores inconsistent NULL
checking if every caller passes non-NULL parameters or Smatch ignores
comparing unsigned with zero if it's just clamping to between zero and
max.

> I would instead keep them for sake of readability
> and accordance with register description in the video decoder manual.
> 
> Thanks
>    j
> 

[ snip ]

> >    511  static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
> >    512  {
> >    513          struct i2c_client *client = v4l2_get_subdevdata(sd);
> >    514          struct tw9910_priv *priv = to_tw9910(client);
> >    515          const unsigned int hact = 720;
> >    516          const unsigned int hdelay = 15;
> >                                    ^^^^^^^^^^^
> >    517          unsigned int vact;
> >    518          unsigned int vdelay;
> >    519          int ret;
> >    520
> >    521          if (!(norm & (V4L2_STD_NTSC | V4L2_STD_PAL)))
> >    522                  return -EINVAL;
> >    523
> >    524          priv->norm = norm;
> >    525          if (norm & V4L2_STD_525_60) {
> >    526                  vact = 240;
> >    527                  vdelay = 18;
> >    528                  ret = tw9910_mask_set(client, VVBI, 0x10, 0x10);
> >    529          } else {
> >    530                  vact = 288;
> >    531                  vdelay = 24;
> >    532                  ret = tw9910_mask_set(client, VVBI, 0x10, 0x00);
> >    533          }
> >    534          if (!ret)
> >    535                  ret = i2c_smbus_write_byte_data(client, CROP_HI,
> >    536                                                  ((vdelay >> 2) & 0xc0) |
> >    537                          ((vact >> 4) & 0x30) |
> >    538                          ((hdelay >> 6) & 0x0c) |
> >                                   ^^^^^^^^^^^
> > 15 >> 6 is zero.
> >
> >    539                          ((hact >> 8) & 0x03));

I looked at the spec and it seems to me that we should doing something
like:

	(((vdelay >> 8) & 0x3) << 6) |
	(((vact >> 8) & 0x3) << 4) |
	(((hedelay >> 8) & 0x3) << 2) |
	((hact >> 8) & 0x03);


But this is the first time I've looked and it and I can't even be sure
I'm looking in the right place.

regards,
dan carpenter
