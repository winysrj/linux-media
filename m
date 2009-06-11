Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55734 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752200AbZFKMQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 08:16:47 -0400
Date: Thu, 11 Jun 2009 14:16:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 3/4] soc-camera: add support for camera-host controls
In-Reply-To: <5e9665e10906110410w7893e016g6e35742c9a55889d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0906111413250.5625@axis700.grange>
References: <Pine.LNX.4.64.0906101549160.4817@axis700.grange>
 <Pine.LNX.4.64.0906101604420.4817@axis700.grange>
 <5e9665e10906110410w7893e016g6e35742c9a55889d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 11 Jun 2009, Dongsoo, Nathaniel Kim wrote:

> Hello Guennadi,
> 
> It's a very interesting patch. Actually some camera interfaces support
> for various image effects and I was wondering how to use them in SoC
> camera subsystem.
> 
> But here is a question. Is it possible to make a choice with the same
> CID between icd and ici? I mean, if both of camera interface and
> camera device are supporting for same CID how can user select any of
> them to use? Sometimes, some image effects supported by camera
> interface are not good so I want to use the same effect supported by
> external camera ISP device.
> 
> I think, it might be possible but I can't see how.

> > @@ -681,9 +698,16 @@ static int soc_camera_s_ctrl(struct file *file, void *priv,
> >        struct soc_camera_file *icf = file->private_data;
> >        struct soc_camera_device *icd = icf->icd;
> >        struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> > +       int ret;
> >
> >        WARN_ON(priv != file->private_data);
> >
> > +       if (ici->ops->set_ctrl) {
> > +               ret = ici->ops->set_ctrl(icd, ctrl);
> > +               if (ret != -ENOIOCTLCMD)
> > +                       return ret;
> > +       }
> > +
> >        return v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, core, s_ctrl, ctrl);
> >  }

Should be easy to see in the patch. Host's s_ctrl is called first. It can 
return -ENOIOCTLCMD then sensor's control will be called too. Ot the host 
may choose to call sensor's control itself, which, however, is 
discouraged.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
