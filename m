Return-path: <linux-media-owner@vger.kernel.org>
Received: from hm1831-22.locaweb.com.br ([189.126.112.42]:4499 "EHLO
	hm1831-22.locaweb.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaEIOe0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 10:34:26 -0400
Received: from mcbain0008.correio.pw (189.126.112.84) by hm1831-34.locaweb.com.br (PowerMTA(TM) v3.5r15) id hdjjn212li85 for <linux-media@vger.kernel.org>; Fri, 9 May 2014 11:13:39 -0300 (envelope-from <marcio@netopen.com.br>)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: s_ctrl V4l2 device driver does not work
From: Marcio Campos de Lima <marcio@netopen.com.br>
In-Reply-To: <536CD2AA.4040108@xs4all.nl>
Date: Fri, 9 May 2014 11:13:35 -0300
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <ABC107BF-BC7E-4AE6-8824-828BFF79493E@netopen.com.br>
References: <B43D69CB-FE7A-4168-B203-02A7934215F4@netopen.com.br> <Pine.LNX.4.64.1405082211240.14834@axis700.grange> <E916BA02-89F5-4E34-96A5-1D3EE8F944CF@netopen.com.br> <Pine.LNX.4.64.1405082259340.14834@axis700.grange> <5869970E-84C8-4159-99EB-8C5D63AE72C9@netopen.com.br> <536CD2AA.4040108@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

Thanks a lot for your attention.
I managed to find the source of the problem in the following code
v4l2_ctrl_new_std(&priv->ctrls, &ov5642_ctrl_ops,V4L2_CID_ZOOM_RELATIVE, -1000, 1000, 1, 500)
v4l2_ctrl_new_std(&priv->ctrls, &ov5642_ctrl_ops,V4L2_CID_FLASH_STROBE, -100, 100, 1, 5);
 
The range of the maximum and minimum values for both v4l2_ctrl_new_std were not corrected. I fixed that and the driver is working fine now.
I am not sure for the most updated version of the Kernel but the return code for the ioctl should be more specific than it is now (Invalid argument).

I havent sent the entire code only because there so many things that are not relevant that I thought that would not be helpfull.

Thanks all of you for the help.
Best regards
MArcio


Em 09/05/2014, �(s) 10:05, Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 05/08/2014 11:30 PM, Marcio Campos de Lima wrote:
>> I have also tried these settings
>> 
>> #define VIDIOC_AVANCA_ZOOM	(0x009a0000|0x900)+14
>> #define VIDIOC_RECUA_ZOOM	(0x009a0000|0x900)+14
> 
> All controls must have unique IDs, which is clearly not the case for these
> two ZOOM controls.
> 
> You say you have problems with setting AVANCA_ZOOM, but you don't provide
> the code in s_ctrl that actually handles that control, so that makes it
> impossible to tell what's going on.
> 
> In addition I see a 'return 1' in s_ctrl, which makes no sense since return
> codes from s_ctrl must either be 0 (for success) or negative (for error codes).
> 
> You really need to give more info (post the entire source?) if you want help.
> 
> Regards,
> 
> 	Hans
> 
>> #define VIDIOC_ATIVA_FLASH	(0x009a0000|0x900)+3
>> #define VIDIOC_WHITE_BALANCE	(0x009a0000|0x900)+13
>> 
>> Em 08/05/2014, �(s) 18:01, Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:
>> 
>>> On Thu, 8 May 2014, Marcio Campos de Lima wrote:
>>> 
>>>> Hi Guennadi
>>>> Thank you very much for your answer.
>>>> The driver is a modified OV5642.c for the Omnivision OV5642 sensor. The platform is a custom AT91SAM9M10 board with a camera paralell interface.
>>>> the driver is working quite well (capturing images) apart the set control interface.
>>> 
>>> So, you're using the atmel-isi camera _host_ driver.
>>> 
>>>> Unfortunately I cannot move to the most current kernel now.
>>> 
>>> I don't find VIDIOC_AVANCA_ZOOM in the mainline kernel, it seems to be a 
>>> part of your modification, so, I don't think I can help you, sorry.
>>> 
>>> Thanks
>>> Guennadi
>>> 
>>>> Thanks again
>>>> Regards
>>>> Marcio
>>>> Em 08/05/2014, �(s) 17:14, Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:
>>>> 
>>>>> Hi Marcio,
>>>>> 
>>>>> Firstly, please direct all V4L related questions to the linux-media list 
>>>>> (added to CC), secondly, your problem will have much better chances to 
>>>>> attract attention if you use a current kernel, thirdly, please, specify 
>>>>> which camera host driver / which ARM platform you're dealing with.
>>>>> 
>>>>> Thanks
>>>>> Guennadi
>>>>> 
>>>>> On Thu, 8 May 2014, Marcio Campos de Lima wrote:
>>>>> 
>>>>>> Hi
>>>>>> 
>>>>>> Can anybody tell me why the set control function is not working in Linux 3.6.9? Thanks.
>>>>>> 
>>>>>> �� APPLICATION CALL ��
>>>>>> struct v4l2_control controle;
>>>>>>  controle.id = VIDIOC_AVANCA_ZOOM;
>>>>>>  controle.value = time;
>>>>>>  if (-1 == xioctl(fd_camera, VIDIOC_S_CTRL,&controle))
>>>>>> 	{
>>>>>> 	printf ("%s erro\n",__FUNCTION__);
>>>>>> 	perror ("erro iotcl");
>>>>>> 	}
>>>>>> 
>>>>>> The ioctl call returns with invalid argument. It is amazing because the first time the ioctl is called it is executed ok. Then no more call is allowed and return the invalid 
>>>>>> 
>>>>>> below is the device driver  code I think may be relevant.
>>>>>> 
>>>>>> v4l2_ctrl_handler_init(&priv->ctrls, ARRAY_SIZE(ov5642_ctrls));
>>>>>>  printk ("handler_init\n");
>>>>>>  v4l2_ctrl_new_std(&priv->ctrls, &ov5642_ctrl_ops,V4L2_CID_ZOOM_RELATIVE, -1000, 1000, 1, 500);
>>>>>>  v4l2_ctrl_new_std(&priv->ctrls, &ov5642_ctrl_ops,V4L2_CID_FLASH_STROBE, -100, 100, 1, 5);
>>>>>> 
>>>>>> 
>>>>>>  priv->subdev.ctrl_handler=&priv->ctrls;
>>>>>>  v4l2_i2c_subdev_init(&priv->subdev, client, &ov5642_subdev_ops);
>>>>>>  return ov5642_video_probe(client);
>>>>>> 
>>>>>> static int ov5642_s_ctrl(struct v4l2_ctrl *ctrl)
>>>>>> {
>>>>>> 	struct ov5642 *ov5642 =
>>>>>> 			container_of(ctrl->handler, struct ov5642, ctrls);
>>>>>> 	struct i2c_client *client = v4l2_get_subdevdata(&ov5642->subdev);
>>>>>> 	u16 data;
>>>>>> 	int ret;
>>>>>> 	printk ("%s: id=%08x val=%d\n",__FUNCTION__, ctrl->id, ctrl->val);
>>>>>> 	switch (ctrl->id) {
>>>>>> 	case V4L2_CID_DO_WHITE_BALANCE:
>>>>>> 		ov5640_set_wb_oem(client, ctrl->val);
>>>>>> 		break;
>>>>>> 	case V4L2_CID_EXPOSURE:
>>>>>> 
>>>>>> 		break;
>>>>>> 	case V4L2_CID_GAIN:
>>>>>> 		/* Gain is controlled by 2 analog stages and a digital stage.
>>>>>> 		 * Valid values for the 3 stages are
>>>>>> 		 *
>>>>>> 		 * Stage                Min     Max     Step
>>>>>> 		 * ------------------------------------------
>>>>>> 		 * First analog stage   x1      x2      1
>>>>>> 		 * Second analog stage  x1      x4      0.125
>>>>>> 		 * Digital stage        x1      x16     0.125
>>>>>> 		 *
>>>>>> 		 * To minimize noise, the gain stages should be used in the
>>>>>> 		 * second analog stage, first analog stage, digital stage order.
>>>>>> 		 * Gain from a previous stage should be pushed to its maximum
>>>>>> 		 * value before the next stage is used.
>>>>>> 		 */
>>>>>> 		if (ctrl->val <= 32) {
>>>>>> 			data = ctrl->val;
>>>>>> 		} else if (ctrl->val <= 64) {
>>>>>> 			ctrl->val &= ~1;
>>>>>> 			data = (1 << 6) | (ctrl->val >> 1);
>>>>>> 		} else {
>>>>>> 			ctrl->val &= ~7;
>>>>>> 			data = ((ctrl->val - 64) << 5) | (1 << 6) | 32;
>>>>>> 		}
>>>>>> 		break;
>>>>>> 	case V4L2_CID_ZOOM_RELATIVE:
>>>>>> 		if (ctrl->val>0)
>>>>>> 			avanca_zoom(sysPriv.v4l2_int_device, ctrl->val);
>>>>>> 		else
>>>>>> 			recua_zoom(sysPriv.v4l2_int_device, ctrl->val);
>>>>>> 
>>>>>> 		break;
>>>>>> 	case V4L2_CID_BRIGHTNESS:
>>>>>> 		 ov5640_set_brightness(client, ctrl->val);
>>>>>> 		 break;
>>>>>> 	case V4L2_CID_CONTRAST:
>>>>>> 		ov5640_set_contrast(client, ctrl->val);
>>>>>> 		break;
>>>>>> 	case V4L2_CID_FLASH_STROBE:
>>>>>> 		ativa_flash (sysPriv.v4l2_int_device, ctrl->val);
>>>>>> 		break;
>>>>>> 	case V4L2_CID_VFLIP:
>>>>>> 
>>>>>> 	case V4L2_CID_TEST_PATTERN:
>>>>>> 
>>>>>> 
>>>>>> 
>>>>>> 	case V4L2_CID_BLC_AUTO:
>>>>>> 
>>>>>> 	case V4L2_CID_BLC_TARGET_LEVEL:
>>>>>> 
>>>>>> 	case V4L2_CID_BLC_ANALOG_OFFSET:
>>>>>> 
>>>>>> 	case V4L2_CID_BLC_DIGITAL_OFFSET:
>>>>>> 		return 1;
>>>>>> 			}
>>>>>> 
>>>>>> 	return 0;
>>>>>> }
>>>>>> 
>>>>>> static struct v4l2_ctrl_ops ov5642_ctrl_ops = {
>>>>>> 	.s_ctrl = ov5642_s_ctrl,
>>>>>> };
>>>>>> 
>>>>>> 
>>>>>> _______________________________________________
>>>>>> linux-arm-kernel mailing list
>>>>>> linux-arm-kernel@lists.infradead.org
>>>>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>>>>> 
>>>>> 
>>>>> ---
>>>>> Guennadi Liakhovetski, Ph.D.
>>>>> Freelance Open-Source Software Developer
>>>>> http://www.open-technology.de/
>>>> 
>>> 
>>> ---
>>> Guennadi Liakhovetski, Ph.D.
>>> Freelance Open-Source Software Developer
>>> http://www.open-technology.de/
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> 

