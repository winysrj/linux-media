Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-m05.mx.aol.com ([64.12.143.79]:35189 "EHLO
	omr-m05.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3JTSLb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Oct 2013 14:11:31 -0400
Message-ID: <52641CC7.2000302@netscape.net>
Date: Sun, 20 Oct 2013 15:11:19 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Nicol=E1s_Sugino?= <nsugino@3way.com.ar>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] cx23885: Add radio support for MyGica x8507
References: <CAFjMtCmv+ZvbsuQkFMZz6kt5btZegSArZtWYFF5gKjn1xXPnJQ@mail.gmail.com>
In-Reply-To: <CAFjMtCmv+ZvbsuQkFMZz6kt5btZegSArZtWYFF5gKjn1xXPnJQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolás

El 18/10/13 17:47, Nicolás Sugino escribió:
>   From: Sugino Nicolas
>   Date: Fri, 18 Oct 2013 17:37:00 -0300
>   Subject: [PATCH] cx23885: Add radio support for MyGica x8507
>
> This patch allows radio capture for the cx23885 driver with the MyGica
> x8507 card
>
> diff -rcNP a/drivers/media/pci/cx23885/cx23885-cards.c
> b/drivers/media/pci/cx23885/cx23885-cards.c
> *** a/drivers/media/pci/cx23885/cx23885-cards.c 2013-10-18
> 17:17:43.257083061 -0300
> --- b/drivers/media/pci/cx23885/cx23885-cards.c 2013-10-18
> 16:10:04.124085546 -0300
> ***************
> *** 531,536 ****
> --- 541,548 ----
>    .name = "Mygica X8502/X8507 ISDB-T",
>    .tuner_type = TUNER_XC5000,
>    .tuner_addr = 0x61,
> + .radio_type = TUNER_XC5000,
> + .radio_addr = 0x61,
>    .tuner_bus = 1,
>    .porta = CX23885_ANALOG_VIDEO,
>    .portb = CX23885_MPEG_DVB,
> ***************
> *** 559,564 ****
> --- 571,580 ----
>    CX25840_VIN7_CH3,
>    .amux   = CX25840_AUDIO7,
>    },
> + {
> + .type   = CX23885_RADIO,
> + .amux= CX25840_AUDIO8,
> + },
>    },
>    },
>    [CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL] = {
> diff -rcNP a/drivers/media/pci/cx23885/cx23885-dvb.c
> b/drivers/media/pci/cx23885/cx23885-dvb.c
> *** a/drivers/media/pci/cx23885/cx23885-dvb.c 2013-10-18
> 17:17:43.281083064 -0300
> --- b/drivers/media/pci/cx23885/cx23885-dvb.c 2013-10-18
> 16:01:10.171036171 -0300
> ***************
> *** 500,505 ****
> --- 505,511 ----
>    static struct xc5000_config mygica_x8507_xc5000_config = {
>    .i2c_address = 0x61,
>    .if_khz = 4000,
> + .radio_input = XC5000_RADIO_FM1,
>    };
>
>    static struct stv090x_config prof_8000_stv090x_config = {
> diff -rcNP a/drivers/media/pci/cx23885/cx23885-video.c
> b/drivers/media/pci/cx23885/cx23885-video.c
> *** a/drivers/media/pci/cx23885/cx23885-video.c 2013-10-18
> 17:17:43.288083064 -0300
> --- b/drivers/media/pci/cx23885/cx23885-video.c 2013-10-18
> 17:01:53.787051023 -0300
> ***************
> *** 904,909 ****
> --- 904,916 ----
>    sizeof(struct cx23885_buffer),
>    fh, NULL);
>
> + if(dev->board == CX23885_BOARD_MYGICA_X8507) {
> + if (fh->radio) {
> + dprintk(1,"video_open: setting radio device\n");
> + call_all(dev, tuner, s_radio);
> + }
> + }
>
>    dprintk(1, "post videobuf_queue_init()\n");
>
> ***************
> *** 1634,1639 ****
> --- 1641,1746 ----
>    }
>
>
> + static int radio_querycap (struct file *file, void  *priv,
> + struct v4l2_capability *cap)
> + {
> + struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
> +
> + strcpy(cap->driver, "cx23885");
> + strlcpy(cap->card, cx23885_boards[dev->board].name, sizeof(cap->card));
> + sprintf(cap->bus_info,"PCIe:%s", pci_name(dev->pci));
> + cap->capabilities = V4L2_CAP_TUNER;
> + return 0;
> + }
> +
> + static int radio_g_tuner (struct file *file, void *priv,
> + struct v4l2_tuner *t)
> + {
> + struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
> +
> + if (unlikely(t->index > 0))
> + return -EINVAL;
> +
> + strcpy(t->name, "Radio");
> + t->type = V4L2_TUNER_RADIO;
> +
> + call_all(dev, tuner, g_tuner, t);
> + return 0;
> + }
> +
> + static int radio_enum_input (struct file *file, void *priv,
> + struct v4l2_input *i)
> + {
> + if (i->index != 0)
> + return -EINVAL;
> + strcpy(i->name,"Radio");
> + i->type = V4L2_INPUT_TYPE_TUNER;
> +
> + return 0;
> + }
> +
> + static int radio_g_audio (struct file *file, void *priv, struct v4l2_audio *a)
> + {
> + if (unlikely(a->index))
> + return -EINVAL;
> +
> + strcpy(a->name,"Radio");
> + return 0;
> + }
> +
> + /* FIXME: Should add a standard for radio */
> + static int radio_s_tuner (struct file *file, void *priv,
> + struct v4l2_tuner *t)
> + {
> + struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
> +
> + if (0 != t->index)
> + return -EINVAL;
> +
> + call_all(dev, tuner, s_tuner, t);
> +
> + return 0;
> + }
> +
> + static int radio_s_audio (struct file *file, void *fh,
> +  struct v4l2_audio *a)
> + {
> + return 0;
> + }
> +
> + static int radio_s_input (struct file *file, void *fh, unsigned int i)
> + {
> + return 0;
> + }
> +
> + static int radio_queryctrl (struct file *file, void *priv,
> +    struct v4l2_queryctrl *c)
> + {
> + int i;
> +
> + if (c->id < V4L2_CID_BASE ||
> + c->id >= V4L2_CID_LASTP1)
> + return -EINVAL;
> + if (c->id == V4L2_CID_AUDIO_MUTE ||
> + c->id == V4L2_CID_AUDIO_VOLUME ||
> + c->id == V4L2_CID_AUDIO_BALANCE) {
> + for (i = 0; i < CX23885_CTLS; i++) {
> + if (cx23885_ctls[i].v.id == c->id)
> + break;
> + }
> + if (i == CX23885_CTLS) {
> + *c = no_ctl;
> + return 0;
> + }
> + *c = cx23885_ctls[i].v;
> + } else
> + *c = no_ctl;
> + return 0;
> + }
> +
> + /* ----------------------------------------------------------- */
>
>    static void cx23885_vid_timeout(unsigned long data)
>    {
> ***************
> *** 1774,1779 ****
> --- 1881,1906 ----
>    .tvnorms              = CX23885_NORMS,
>    };
>
> + static const struct v4l2_ioctl_ops radio_ioctl_ops = {
> + .vidioc_querycap      = radio_querycap,
> + .vidioc_g_tuner       = radio_g_tuner,
> + .vidioc_enum_input    = radio_enum_input,
> + .vidioc_g_audio       = radio_g_audio,
> + .vidioc_s_tuner       = radio_s_tuner,
> + .vidioc_s_audio       = radio_s_audio,
> + .vidioc_s_input       = radio_s_input,
> + .vidioc_queryctrl     = radio_queryctrl,
> + .vidioc_g_ctrl        = vidioc_g_ctrl,
> + .vidioc_s_ctrl        = vidioc_s_ctrl,
> + .vidioc_g_frequency   = vidioc_g_frequency,
> + .vidioc_s_frequency   = vidioc_s_frequency,
> + #ifdef CONFIG_VIDEO_ADV_DEBUG
> + .vidioc_g_register    = cx23885_g_register,
> + .vidioc_s_register    = cx23885_s_register,
> + #endif
> + };
> +
>    static const struct v4l2_file_operations radio_fops = {
>    .owner         = THIS_MODULE,
>    .open          = video_open,
> ***************
> *** 1781,1792 ****
> --- 1908,1932 ----
>    .ioctl         = video_ioctl2,
>    };
>
> + static struct video_device cx23885_radio_template = {
> + .name                 = "cx23885-radio",
> + .fops                 = &radio_fops,
> + .ioctl_ops            = &radio_ioctl_ops,
> + };
> +
>
>    void cx23885_video_unregister(struct cx23885_dev *dev)
>    {
>    dprintk(1, "%s()\n", __func__);
>    cx23885_irq_remove(dev, 0x01);
>
> + if (dev->radio_dev) {
> + if (video_is_registered(dev->radio_dev))
> + video_unregister_device(dev->radio_dev);
> + else
> + video_device_release(dev->radio_dev);
> + dev->radio_dev = NULL;
> + }
>    if (dev->vbi_dev) {
>    if (video_is_registered(dev->vbi_dev))
>    video_unregister_device(dev->vbi_dev);
> ***************
> *** 1858,1864 ****
>    struct tuner_setup tun_setup;
>
>    memset(&tun_setup, 0, sizeof(tun_setup));
> ! tun_setup.mode_mask = T_ANALOG_TV;
>    tun_setup.type = dev->tuner_type;
>    tun_setup.addr = v4l2_i2c_subdev_addr(sd);
>    tun_setup.tuner_callback = cx23885_tuner_callback;
> --- 1998,2004 ----
>    struct tuner_setup tun_setup;
>
>    memset(&tun_setup, 0, sizeof(tun_setup));
> ! tun_setup.mode_mask = T_ANALOG_TV | T_RADIO;
>    tun_setup.type = dev->tuner_type;
>    tun_setup.addr = v4l2_i2c_subdev_addr(sd);
>    tun_setup.tuner_callback = cx23885_tuner_callback;
> ***************
> *** 1917,1922 ****
> --- 2057,2075 ----
>    printk(KERN_INFO "%s: registered device %s\n",
>          dev->name, video_device_node_name(dev->vbi_dev));
>
> + dev->radio_dev = cx23885_vdev_init(dev, dev->pci,
> + &cx23885_radio_template, "radio");
> + err = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
> +    radio_nr[dev->nr]);
> + if (err < 0) {
> + printk(KERN_INFO "%s: can't register radio device\n",
> + dev->name);
> + goto fail_unreg;
> + }
> + printk(KERN_INFO "%s: registered device %s\n",
> +       dev->name, video_device_node_name(dev->radio_dev));
> +
> +
>    /* Register ALSA audio device */
>    dev->audio_dev = cx23885_audio_register(dev);
>
>
> Regards,
>
> Nicolas
>

The patch has sent broken spaces, so that it becomes difficult to 
understand.

For the lines that I have seen, these lines of code are the same as 
Miroslav Slugen wrote in "CX23885: Add basic support analog Radio" and 
the answer that I've done (https://linuxtv.org/patch/20329 /).
What are the differences between the patches sent by Miroslav Slugen and 
me? Does it solve the problems I have raised for this board in particular?

Regards

Alfredo
