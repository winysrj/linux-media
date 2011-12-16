Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:52616 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759282Ab1LPJQK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 04:16:10 -0500
Date: Fri, 16 Dec 2011 10:16:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Scott Jiang <scott.jiang.linux@gmail.com>
cc: Javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, saaguirre@ti.com,
	mchehab@infradead.org
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
In-Reply-To: <CAHG8p1AXghgSQNHUQi5V56ROAfS9tOsMRbAMqNogNG0=m7zzkQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1112161014580.6572@axis700.grange>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
 <Pine.LNX.4.64.1112160909470.6572@axis700.grange>
 <CAHG8p1AXghgSQNHUQi5V56ROAfS9tOsMRbAMqNogNG0=m7zzkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 16 Dec 2011, Scott Jiang wrote:

> Hi Guennadi,
> 
> > First question: you probably also want to patch soc_camera_g_input() and
> > soc_camera_enum_input(). But no, I do not know how. The video subdevice
> > operations do not seem to provide a way to query subdevice routing
> > capabilities, so, I've got no idea how we're supposed to support
> > enum_input(). There is a g_input_status() method, but I'm not sure about
> > its semantics. Would it return an error like -EINVAL on an unsupported
> > index?
> >
> static int bcap_enum_input(struct file *file, void *priv,
>                                 struct v4l2_input *input)
> {
>         struct bcap_device *bcap_dev = video_drvdata(file);
>         struct bfin_capture_config *config = bcap_dev->cfg;
>         int ret;
>         u32 status;
> 
>         if (input->index >= config->num_inputs)
>                 return -EINVAL;
> 
>         *input = config->inputs[input->index];
>         /* get input status */
>         ret = v4l2_subdev_call(bcap_dev->sd, video, g_input_status, &status);
>         if (!ret)
>                 input->status = status;
>         return 0;
> }
> 
> How about this implementation? I know it's not for soc, but I post it
> to give my idea.
> Bridge knows the layout, so it doesn't need to query the subdevice.

Where from? AFAIU, we are talking here about subdevice inputs, right? In 
this case about various inputs of the TV decoder. How shall the bridge 
driver know about that?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
