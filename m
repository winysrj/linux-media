Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4280 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbaAFOjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 09:39:12 -0500
Message-ID: <52CAC006.7080907@xs4all.nl>
Date: Mon, 06 Jan 2014 15:39:02 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Tom <Bassai_Dai@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: Add private controls to ctrl_handler
References: <loom.20140106T152825-137@post.gmane.org>
In-Reply-To: <loom.20140106T152825-137@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/06/2014 03:30 PM, Tom wrote:
> Hello,
> 
> I want to add some driver specific ctrls to my ctrl-handler which are not
> defined in the "/include/uapi/linux/v4l2-controls.h".
> I read that I would need the "V4L2_CID_PRIVATE_BASE" to define the new IDs,
> but I don't get how I can add them to my ctrl-handler so that they are
> accessible by calling VIDIOC_S_CTRL. 

Don't use V4L2_CID_PRIVATE_BASE, that doesn't work with the control framework
(for good but somewhat obscure reasons).

Instead use (V4L2_CID_USER_BASE | 0x1000) as the base for your private controls.
If you want to upstream the code, then you should define a range for the private
controls of this driver in v4l2-controls.h. Search for e.g. V4L2_CID_USER_S2255_BASE
in that header to see how it is done.

Regards,

	Hans

> 
> Can someone give me a hint how I can add my own controls to my ctrl-handler?
> 
> what I tried:
> 
> #define V4L2_SENS_TEST1			(V4L2_CID_PRIVATE_BASE + 1)
> #define V4L2_SENS_TEST2			(V4L2_CID_PRIVATE_BASE + 2)
> #define V4L2_SENS_TEST3			(V4L2_CID_PRIVATE_BASE + 3)
> 
> static int ov3640_probe(struct i2c_client *client,
> 			const struct i2c_device_id *id)
> {
> 				.
> 				.
> 				.
> //I can add the standard controls as usual...
> 
> 	v4l2_ctrl_handler_init(&ov3640->ctrl_handler, 19);
> 
> 	v4l2_ctrl_new_std(&ov3640->ctrl_handler, &ov3640_ctrl_ops,
> 			V4L2_CID_BRIGHTNESS, -48, 48, 1, 0);
> 	v4l2_ctrl_new_std(&ov3640->ctrl_handler, &ov3640_ctrl_ops,
> 			V4L2_CID_CONTRAST, -12, 12, 1, 0);
> 	v4l2_ctrl_new_std(&ov3640->ctrl_handler, &ov3640_ctrl_ops,
> 			V4L2_CID_SATURATION, -32, 32, 1, 0);
> 				.
> 				.
> 				.
> //so far so good...
> 
> 	v4l2_ctrl_new_std(&ov3640->ctrl_handler, &ov3640_ctrl_ops,
> 			V4L2_SENS_TEST1, 0, 1, 1, 0);
> 	v4l2_ctrl_new_std(&ov3640->ctrl_handler, &ov3640_ctrl_ops,
> 			V4L2_SENS_TEST2, 0, 1, 1, 0);
> 	v4l2_ctrl_new_std(&ov3640->ctrl_handler, &ov3640_ctrl_ops,
> 			V4L2_SENS_TEST3, 0, 1, 1, 0);
> 
> //but I cannot add these three controls like this. 
> 
> 	if (ov3640->ctrl_handler.error) {
> 		dev_err(&client->dev, "control initialization error %d\n",
> 			ov3640->ctrl_handler.error);
> 		ret = ov3640->ctrl_handler.error;
> 		goto done;
> 	}
> 
> //the ctrl-handler will give me an ERROR back when adding these 3 controls
> 
> }
> 
> static int ov3640_ctrl(struct v4l2_ctrl *ctrl, int command)
> {
> 	struct ov3640 *ov3640 = container_of(ctrl->handler, struct ov3640,
> ctrl_handler);
> 	int ret = 0;
> 
> 	switch (ctrl->id) {
> 	case V4L2_CID_BRIGHTNESS:
> 		ret = ov3640_set_brightness(ov3640, ctrl->val, command);
> 		break;
> 	case V4L2_CID_CONTRAST:
> 		ret = ov3640_set_contrast(ov3640, ctrl->val, command);
> 		break;
> 	case V4L2_CID_SATURATION:
> 		ret = ov3640_set_saturation(ov3640, ctrl->val, command);
> 		break;
> 	case V4L2_SENS_TEST1://!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
> 	case V4L2_SENS_TEST2://!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
> 	case V4L2_SENS_TEST3://!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
> 		ret = ov3640_test(ov3640, ctrl->val, ctrl->id, command);
> 		break;
> 	}
> 
> 	return ret;
> }
> 
> static int ov3640_set_ctrl(struct v4l2_ctrl *ctrl)
> {
> 	int ret;
> 	int command = SET_DATA;
> 
> 	ret = ov3640_ctrl(ctrl, command);
> 	return ret;
> }
> 
> static int ov3640_get_ctrl(struct v4l2_ctrl *ctrl)
> {
> 	int ret;
> 	int command = GET_DATA;
> 
> 	ret = ov3640_ctrl(ctrl, command);
> 	return ret;
> }
> 
> static struct v4l2_ctrl_ops ov3640_ctrl_ops = {
> 	.s_ctrl = ov3640_set_ctrl,
> 	.g_volatile_ctrl = ov3640_get_ctrl,
> };
> 
> Best Regards, Tom
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

