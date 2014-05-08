Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:51726 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaEHVBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 May 2014 17:01:45 -0400
Date: Thu, 8 May 2014 23:01:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marcio Campos de Lima <marcio@netopen.com.br>
cc: linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: s_ctrl V4l2 device driver does not work
In-Reply-To: <E916BA02-89F5-4E34-96A5-1D3EE8F944CF@netopen.com.br>
Message-ID: <Pine.LNX.4.64.1405082259340.14834@axis700.grange>
References: <B43D69CB-FE7A-4168-B203-02A7934215F4@netopen.com.br>
 <Pine.LNX.4.64.1405082211240.14834@axis700.grange>
 <E916BA02-89F5-4E34-96A5-1D3EE8F944CF@netopen.com.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 8 May 2014, Marcio Campos de Lima wrote:

> Hi Guennadi
> Thank you very much for your answer.
> The driver is a modified OV5642.c for the Omnivision OV5642 sensor. The platform is a custom AT91SAM9M10 board with a camera paralell interface.
> the driver is working quite well (capturing images) apart the set control interface.

So, you're using the atmel-isi camera _host_ driver.

> Unfortunately I cannot move to the most current kernel now.

I don't find VIDIOC_AVANCA_ZOOM in the mainline kernel, it seems to be a 
part of your modification, so, I don't think I can help you, sorry.

Thanks
Guennadi

> Thanks again
> Regards
> Marcio
> Em 08/05/2014, �(s) 17:14, Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:
> 
> > Hi Marcio,
> > 
> > Firstly, please direct all V4L related questions to the linux-media list 
> > (added to CC), secondly, your problem will have much better chances to 
> > attract attention if you use a current kernel, thirdly, please, specify 
> > which camera host driver / which ARM platform you're dealing with.
> > 
> > Thanks
> > Guennadi
> > 
> > On Thu, 8 May 2014, Marcio Campos de Lima wrote:
> > 
> >> Hi
> >> 
> >> Can anybody tell me why the set control function is not working in Linux 3.6.9? Thanks.
> >> 
> >> �� APPLICATION CALL ��
> >> struct v4l2_control controle;
> >>    controle.id = VIDIOC_AVANCA_ZOOM;
> >>    controle.value = time;
> >>    if (-1 == xioctl(fd_camera, VIDIOC_S_CTRL,&controle))
> >> 	{
> >> 	printf ("%s erro\n",__FUNCTION__);
> >> 	perror ("erro iotcl");
> >> 	}
> >> 
> >> The ioctl call returns with invalid argument. It is amazing because the first time the ioctl is called it is executed ok. Then no more call is allowed and return the invalid 
> >> 
> >> below is the device driver  code I think may be relevant.
> >> 
> >>  v4l2_ctrl_handler_init(&priv->ctrls, ARRAY_SIZE(ov5642_ctrls));
> >>    printk ("handler_init\n");
> >>    v4l2_ctrl_new_std(&priv->ctrls, &ov5642_ctrl_ops,V4L2_CID_ZOOM_RELATIVE, -1000, 1000, 1, 500);
> >>    v4l2_ctrl_new_std(&priv->ctrls, &ov5642_ctrl_ops,V4L2_CID_FLASH_STROBE, -100, 100, 1, 5);
> >> 
> >> 
> >>    priv->subdev.ctrl_handler=&priv->ctrls;
> >>    v4l2_i2c_subdev_init(&priv->subdev, client, &ov5642_subdev_ops);
> >>    return ov5642_video_probe(client);
> >> 
> >> static int ov5642_s_ctrl(struct v4l2_ctrl *ctrl)
> >> {
> >> 	struct ov5642 *ov5642 =
> >> 			container_of(ctrl->handler, struct ov5642, ctrls);
> >> 	struct i2c_client *client = v4l2_get_subdevdata(&ov5642->subdev);
> >> 	u16 data;
> >> 	int ret;
> >> 	printk ("%s: id=%08x val=%d\n",__FUNCTION__, ctrl->id, ctrl->val);
> >> 	switch (ctrl->id) {
> >> 	case V4L2_CID_DO_WHITE_BALANCE:
> >> 		ov5640_set_wb_oem(client, ctrl->val);
> >> 		break;
> >> 	case V4L2_CID_EXPOSURE:
> >> 
> >> 		break;
> >> 	case V4L2_CID_GAIN:
> >> 		/* Gain is controlled by 2 analog stages and a digital stage.
> >> 		 * Valid values for the 3 stages are
> >> 		 *
> >> 		 * Stage                Min     Max     Step
> >> 		 * ------------------------------------------
> >> 		 * First analog stage   x1      x2      1
> >> 		 * Second analog stage  x1      x4      0.125
> >> 		 * Digital stage        x1      x16     0.125
> >> 		 *
> >> 		 * To minimize noise, the gain stages should be used in the
> >> 		 * second analog stage, first analog stage, digital stage order.
> >> 		 * Gain from a previous stage should be pushed to its maximum
> >> 		 * value before the next stage is used.
> >> 		 */
> >> 		if (ctrl->val <= 32) {
> >> 			data = ctrl->val;
> >> 		} else if (ctrl->val <= 64) {
> >> 			ctrl->val &= ~1;
> >> 			data = (1 << 6) | (ctrl->val >> 1);
> >> 		} else {
> >> 			ctrl->val &= ~7;
> >> 			data = ((ctrl->val - 64) << 5) | (1 << 6) | 32;
> >> 		}
> >> 		break;
> >> 	case V4L2_CID_ZOOM_RELATIVE:
> >> 		if (ctrl->val>0)
> >> 			avanca_zoom(sysPriv.v4l2_int_device, ctrl->val);
> >> 		else
> >> 			recua_zoom(sysPriv.v4l2_int_device, ctrl->val);
> >> 
> >> 		break;
> >> 	case V4L2_CID_BRIGHTNESS:
> >> 		 ov5640_set_brightness(client, ctrl->val);
> >> 		 break;
> >> 	case V4L2_CID_CONTRAST:
> >> 		ov5640_set_contrast(client, ctrl->val);
> >> 		break;
> >> 	case V4L2_CID_FLASH_STROBE:
> >> 		ativa_flash (sysPriv.v4l2_int_device, ctrl->val);
> >> 		break;
> >> 	case V4L2_CID_VFLIP:
> >> 
> >> 	case V4L2_CID_TEST_PATTERN:
> >> 
> >> 
> >> 
> >> 	case V4L2_CID_BLC_AUTO:
> >> 
> >> 	case V4L2_CID_BLC_TARGET_LEVEL:
> >> 
> >> 	case V4L2_CID_BLC_ANALOG_OFFSET:
> >> 
> >> 	case V4L2_CID_BLC_DIGITAL_OFFSET:
> >> 		return 1;
> >> 			}
> >> 
> >> 	return 0;
> >> }
> >> 
> >> static struct v4l2_ctrl_ops ov5642_ctrl_ops = {
> >> 	.s_ctrl = ov5642_s_ctrl,
> >> };
> >> 
> >> 
> >> _______________________________________________
> >> linux-arm-kernel mailing list
> >> linux-arm-kernel@lists.infradead.org
> >> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> >> 
> > 
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
