Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35478 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756358Ab0C3OkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Mar 2010 10:40:09 -0400
Date: Tue, 30 Mar 2010 16:40:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Richard =?iso-8859-15?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: adv7180 as SoC camera device
In-Reply-To: <20100330140611.GR5937@enneenne.com>
Message-ID: <Pine.LNX.4.64.1003301638090.6963@axis700.grange>
References: <20100219174451.GH21778@enneenne.com> <Pine.LNX.4.64.1002192018170.5860@axis700.grange>
 <20100222160139.GL21778@enneenne.com> <4B8310F1.8070005@pelagicore.com>
 <20100330140611.GR5937@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 30 Mar 2010, Rodolfo Giometti wrote:

> On Tue, Feb 23, 2010 at 12:19:13AM +0100, Richard Röjfors wrote:
> > 
> > We use it as a subdev to a driver not yet committed from us. So I think
> > you should extend it, not move it.
> 
> Finally I got something functional... but I'm puzzled to know how I
> can add platform data configuration struct by using the I2C's
> platform_data pointer if it is already used to hold struct
> soc_camera_device... O_o

As usual, looking at existing examples helps, e.g., in ov772x:

	priv->info = icl->priv;

i.e., icl->priv is where you pass subdevice-driver specific data with 
the soc-camera API.

> In fact my probe function looks like:
> 
> static __devinit int adv7180_probe(struct i2c_client *client,
>                         const struct i2c_device_id *id)
> {
>         struct adv7180_state *state;
>         struct soc_camera_device *icd = client->dev.platform_data;
>         struct soc_camera_link *icl;
>         struct v4l2_subdev *sd;
>         int ret;
> 
>         /* Check if the adapter supports the needed features */
>         if (!i2c_check_functionality(client->adapter,
> 	I2C_FUNC_SMBUS_BYTE_DATA))
>                 return -EIO;
> 
>         v4l_info(client, "chip found @ 0x%02x (%s)\n",
>                         client->addr << 1, client->adapter->name);
> 
>         if (icd) {
>                 icl = to_soc_camera_link(icd);
>                 if (!icl)
>                         return -EINVAL;
> 
>                 icd->ops = &adv7180_soc_ops;
>                 v4l_info(client, "soc-camera support enabled\n");
>         } else
>                 pdata = client->dev.platform_data;

This is a complicated way to say

		pdata = NULL;

Thanks
Guennadi

> 
>         state = kzalloc(sizeof(struct adv7180_state), GFP_KERNEL);
>         if (state == NULL) {
>                 ret = -ENOMEM;
>                 goto err;
>         }
> 
>         state->irq = client->irq;
>         INIT_WORK(&state->work, adv7180_work);
>         mutex_init(&state->mutex);
>         state->autodetect = true;
>         sd = &state->sd;
>         v4l2_i2c_subdev_init(sd, client, &adv7180_ops);
> 	...
> 
> Thanks in advance,
> 
> Rodolfo
> 
> -- 
> 
> GNU/Linux Solutions                  e-mail: giometti@enneenne.com
> Linux Device Driver                          giometti@linux.it
> Embedded Systems                     phone:  +39 349 2432127
> UNIX programming                     skype:  rodolfo.giometti
> Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
> 

---
Guennadi Liakhovetski
