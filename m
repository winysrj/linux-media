Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53918 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab2EGVZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2012 17:25:45 -0400
Date: Mon, 7 May 2012 23:25:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Aguirre, Sergio" <saaguirre@ti.com>
cc: Sriram V <vshrirama@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Android Support for camera?
In-Reply-To: <CAKnK67Qdte8qJ9L18OL2ft=YaF4YEAD-5rTP_bk7+_nQAn4u+A@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1205072321530.3564@axis700.grange>
References: <CAH9_wRP4+hzFpCdcZWmyyTZpTTFi+9wyTJxX2vPd+3r0QNhLkA@mail.gmail.com>
 <CAKnK67Qdte8qJ9L18OL2ft=YaF4YEAD-5rTP_bk7+_nQAn4u+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio

On Mon, 7 May 2012, Aguirre, Sergio wrote:

> Hi Sriram,
> 
> On Mon, May 7, 2012 at 10:33 AM, Sriram V <vshrirama@gmail.com> wrote:
> > Hi Sergio,
> >  I understand that you are working on providing Android HAL Support
> > for camera on omap4.
> 
> That's right. Not an active task at the moment, due to some other
> stuff going on,
> but yes, I have that task pending to do.
> 
> >  Were you able to capture and record?
> 
> Well, I'm trying to take these patches as a reference:
> 
> http://review.omapzoom.org/#/q/project:platform/hardware/ti/omap4xxx+topic:usbcamera,n,z
> 
> Which are implementing V4L2 camera support for the CameraHAL,
> currently tested with
> the UVC camera driver only.

I've implemented a (pretty basic so far) V4L2 camera HAL for android 
(ICS), patche submission is pending legal clarifications... I hope to 
manage to push them into the upstream android, after which they shall 
become available to all platforms. I've implemented the HAL as a 
platform-agnostic library in C with a minimal (and naive;-)) C++ glue. I'm 
sure, those patches will need some improvements, but I'd be happy, if they 
could be taken as a basis.

Thanks
Guennadi

> So, I need to set the IOCTLs to program the omap4iss media controller
> device, to set a
> usecase, and start preview.
> 
> I'll keep you posted.
> 
> Regards,
> Sergio
> 
> >
> >  --
> > Regards,
> > Sriram

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
