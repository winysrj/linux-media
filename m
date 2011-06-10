Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:62135 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab1FJJQc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 05:16:32 -0400
Date: Fri, 10 Jun 2011 11:16:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kassey Lee <kassey1216@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	laurent.pinchart@ideasonboard.com, leiwen@marvell.com,
	qingx@marvell.com
Subject: Re: soc_camera_set_fmt in soc_camera_open
In-Reply-To: <BANLkTinQ0bDt-9f53fkfiUo1u26ahPsO-w@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1106101114120.12671@axis700.grange>
References: <BANLkTikg_MqmbL_7d2SY7zVALbm447b4Mw@mail.gmail.com>
 <BANLkTinQ0bDt-9f53fkfiUo1u26ahPsO-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 10 Jun 2011, Kassey Lee wrote:

> hi, Guennadi:
> 
>           in drivers/media/video/soc_camera.c
> static int soc_camera_open(struct file *file)
> 
> it will call soc_camera_set_fmt to configure the sensor and host controller.
> for sensor, this means it will trigger download setting, this may take quite
> time through i2c or SPI.
> I complain about this, because after we open,  request, s_param, S_FMT,
> DQBUF,
> in S_FMT, we will download the setting again.
> 
> how do you think ?

If it's a concern for you, you might consider moving most of your sensor 
set up from .s_(mbus_)fmt() to .s_stream(). Would that solve your problem?

Thanks
Guennadi

> 
> 
>                /*
>                 * Try to configure with default parameters. Notice: this is
> the
>                 * very first open, so, we cannot race against other calls,
>                 * apart from someone else calling open() simultaneously, but
>                 * .video_lock is protecting us against it.
>                 */
>                ret = soc_camera_set_fmt(icd, &f);
>                if (ret < 0)
>                        goto esfmt;
> 
> -- 
> Best regards
> Kassey
> Application Processor Systems Engineering, Marvell Technology Group Ltd.
> Shanghai, China.
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
