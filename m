Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59581 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758719Ab0DBHGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 03:06:16 -0400
Date: Fri, 2 Apr 2010 09:06:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Richard =?iso-8859-15?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: adv7180 as SoC camera device
In-Reply-To: <20100330154235.GU5937@enneenne.com>
Message-ID: <Pine.LNX.4.64.1004020900010.24014@axis700.grange>
References: <20100219174451.GH21778@enneenne.com> <Pine.LNX.4.64.1002192018170.5860@axis700.grange>
 <20100222160139.GL21778@enneenne.com> <4B8310F1.8070005@pelagicore.com>
 <20100330140611.GR5937@enneenne.com> <Pine.LNX.4.64.1003301638090.6963@axis700.grange>
 <20100330154235.GU5937@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 30 Mar 2010, Rodolfo Giometti wrote:

> On Tue, Mar 30, 2010 at 04:40:17PM +0200, Guennadi Liakhovetski wrote:
> > On Tue, 30 Mar 2010, Rodolfo Giometti wrote:
> > 
> > > On Tue, Feb 23, 2010 at 12:19:13AM +0100, Richard Röjfors wrote:
> > > > 
> > > > We use it as a subdev to a driver not yet committed from us. So I think
> > > > you should extend it, not move it.
> > > 
> > > Finally I got something functional... but I'm puzzled to know how I
> > > can add platform data configuration struct by using the I2C's
> > > platform_data pointer if it is already used to hold struct
> > > soc_camera_device... O_o
> > 
> > As usual, looking at existing examples helps, e.g., in ov772x:
> > 
> > 	priv->info = icl->priv;
> > 
> > i.e., icl->priv is where you pass subdevice-driver specific data with 
> > the soc-camera API.
> 
> This driver was developed as v4l2-sub device and I just add the
> soc-camera support.
> 
> Doing what are you suggesting is not compatible with the v4l2-sub
> device support, in fact the I2C platform_data is used to know if the
> driver must enable soc-camera or not...

Yes, this is a known limitation, I have tried to discuss this on this ML 
in the past to get some reasonable solution for this, i.e., to standardise 
the use of the platform-data pointer. However, this hasn't worked until 
now. Maybe we manage it this time. So, what we would need is some standard 
optional struct, to which platform-data may point. If it is not NULL, then 
there could be either a "priv" member, that we would then use for 
soc-camera specific data, or we could embed that common struct in an 
soc-camera specific one. I would prefer a priv pointer.

> 
> Look the code:
> 
>    static __devinit int adv7180_probe(struct i2c_client *client,
>                            const struct i2c_device_id *id)
>    {
>            struct adv7180_state *state;
>            struct soc_camera_device *icd = client->dev.platform_data;
> 
> icd is set as client->dev.platform_data. This can be use for normal
> I2C devices to hold custom platform_data initialization.
> 
>            struct soc_camera_link *icl;
>            struct adv7180_platform_data *pdata = NULL;
>            struct v4l2_subdev *sd;
>            int ret;
> 
>            /* Check if the adapter supports the needed features */
>            if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
>                    return -EIO;
> 
>            v4l_info(client, "chip found @ 0x%02x (%s)\n",
>                            client->addr << 1, client->adapter->name);
> 
>            if (icd) {
> 
> If the icd is set we assume it holds a soc-camera struct.
> 
>                    icl = to_soc_camera_link(icd);
>                    if (!icl || !icl->priv) {
>                            v4l_err(client, "missing platform data!\n");
>                            return -EINVAL;
>                    }
> 
>                    icd->ops = &adv7180_soc_ops;
> 
> If soc-camera is defined we set some info in order to enable it...
> 
>                    v4l_info(client, "soc-camera support enabled\n");
>            }
> ...otherwise the driver works in the old way.

Exactly, now we just have to standardise the use of 
client->dev.platform_data for v4l(2) I2C devices.

> 
>            state = kzalloc(sizeof(struct adv7180_state), GFP_KERNEL);
>            if (state == NULL) {
>                    ret = -ENOMEM;
>                    goto err;
>            }
> 
>            state->irq = client->irq;
>            INIT_WORK(&state->work, adv7180_work);
>            mutex_init(&state->mutex);
>            state->autodetect = true;
>            sd = &state->sd;
>            v4l2_i2c_subdev_init(sd, client, &adv7180_ops);
> 
> Ciao,
> 
> Rodolfo

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
