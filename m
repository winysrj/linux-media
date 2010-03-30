Return-path: <linux-media-owner@vger.kernel.org>
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:52551 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab0C3Pmp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Mar 2010 11:42:45 -0400
Date: Tue, 30 Mar 2010 17:42:35 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Richard =?iso-8859-15?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Message-ID: <20100330154235.GU5937@enneenne.com>
References: <20100219174451.GH21778@enneenne.com>
 <Pine.LNX.4.64.1002192018170.5860@axis700.grange>
 <20100222160139.GL21778@enneenne.com>
 <4B8310F1.8070005@pelagicore.com>
 <20100330140611.GR5937@enneenne.com>
 <Pine.LNX.4.64.1003301638090.6963@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.1003301638090.6963@axis700.grange>
Subject: Re: adv7180 as SoC camera device
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 30, 2010 at 04:40:17PM +0200, Guennadi Liakhovetski wrote:
> On Tue, 30 Mar 2010, Rodolfo Giometti wrote:
> 
> > On Tue, Feb 23, 2010 at 12:19:13AM +0100, Richard Röjfors wrote:
> > > 
> > > We use it as a subdev to a driver not yet committed from us. So I think
> > > you should extend it, not move it.
> > 
> > Finally I got something functional... but I'm puzzled to know how I
> > can add platform data configuration struct by using the I2C's
> > platform_data pointer if it is already used to hold struct
> > soc_camera_device... O_o
> 
> As usual, looking at existing examples helps, e.g., in ov772x:
> 
> 	priv->info = icl->priv;
> 
> i.e., icl->priv is where you pass subdevice-driver specific data with 
> the soc-camera API.

This driver was developed as v4l2-sub device and I just add the
soc-camera support.

Doing what are you suggesting is not compatible with the v4l2-sub
device support, in fact the I2C platform_data is used to know if the
driver must enable soc-camera or not...

Look the code:

   static __devinit int adv7180_probe(struct i2c_client *client,
                           const struct i2c_device_id *id)
   {
           struct adv7180_state *state;
           struct soc_camera_device *icd = client->dev.platform_data;

icd is set as client->dev.platform_data. This can be use for normal
I2C devices to hold custom platform_data initialization.

           struct soc_camera_link *icl;
           struct adv7180_platform_data *pdata = NULL;
           struct v4l2_subdev *sd;
           int ret;

           /* Check if the adapter supports the needed features */
           if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
                   return -EIO;

           v4l_info(client, "chip found @ 0x%02x (%s)\n",
                           client->addr << 1, client->adapter->name);

           if (icd) {

If the icd is set we assume it holds a soc-camera struct.

                   icl = to_soc_camera_link(icd);
                   if (!icl || !icl->priv) {
                           v4l_err(client, "missing platform data!\n");
                           return -EINVAL;
                   }

                   icd->ops = &adv7180_soc_ops;

If soc-camera is defined we set some info in order to enable it...

                   v4l_info(client, "soc-camera support enabled\n");
           }
...otherwise the driver works in the old way.

           state = kzalloc(sizeof(struct adv7180_state), GFP_KERNEL);
           if (state == NULL) {
                   ret = -ENOMEM;
                   goto err;
           }

           state->irq = client->irq;
           INIT_WORK(&state->work, adv7180_work);
           mutex_init(&state->mutex);
           state->autodetect = true;
           sd = &state->sd;
           v4l2_i2c_subdev_init(sd, client, &adv7180_ops);

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
