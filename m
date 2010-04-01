Return-path: <linux-media-owner@vger.kernel.org>
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:49291 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab0DALsm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 07:48:42 -0400
Date: Thu, 1 Apr 2010 13:48:27 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Richard =?iso-8859-15?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Message-ID: <20100401114827.GA6573@gundam.enneenne.com>
References: <20100219174451.GH21778@enneenne.com> <Pine.LNX.4.64.1002192018170.5860@axis700.grange> <20100222160139.GL21778@enneenne.com> <4B8310F1.8070005@pelagicore.com> <20100330140611.GR5937@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100330140611.GR5937@enneenne.com>
Subject: Re: adv7180 as SoC camera device
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 30, 2010 at 04:06:11PM +0200, Rodolfo Giometti wrote:
> On Tue, Feb 23, 2010 at 12:19:13AM +0100, Richard Röjfors wrote:
> > 
> > We use it as a subdev to a driver not yet committed from us. So I think
> > you should extend it, not move it.
> 
> Finally I got something functional... but I'm puzzled to know how I
> can add platform data configuration struct by using the I2C's
> platform_data pointer if it is already used to hold struct
> soc_camera_device... O_o

Here my solution:

static __devinit int adv7180_probe(struct i2c_client *client,
                        const struct i2c_device_id *id)
{
        struct adv7180_state *state;
#if defined(CONFIG_SOC_CAMERA)
        struct soc_camera_device *icd = client->dev.platform_data;
        struct soc_camera_link *icl;
        struct adv7180_platform_data *pdata = NULL;
#else
        struct adv7180_platform_data *pdata =
	client->dev.platform_data;
#endif
        struct v4l2_subdev *sd;
        int i, ret;

        /* Check if the adapter supports the needed features */
        if (!i2c_check_functionality(client->adapter,
	I2C_FUNC_SMBUS_BYTE_DATA))
                return -EIO;

        v4l_info(client, "chip found @ 0x%02x (%s)\n",
                        client->addr << 1, client->adapter->name);

#if defined(CONFIG_SOC_CAMERA)
        if (icd) {
                icl = to_soc_camera_link(icd);
                if (!icl || !icl->priv) {
                        v4l_err(client, "missing platform data!\n");
                        return -EINVAL;
                }
                pdata = icl->priv;

                icd->ops = &adv7180_soc_ops;
                v4l_info(client, "soc-camera support enabled\n");
        }
#endif

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

        if (pdata)
                for (i = 0; pdata[i].reg >= 0; i++) {
                        printk("----> %x %x\n", pdata[i].reg,
			pdata[i].val);
                        ret = i2c_smbus_write_byte_data(client,
                                        pdata[i].reg, pdata[i].val);
                        if (ret < 0)
                                goto err_unreg_subdev;
                }

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
