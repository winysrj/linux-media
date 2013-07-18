Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:63880 "EHLO
	relmlor4.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab3GRJmj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 05:42:39 -0400
Received: from relmlir4.idc.renesas.com ([10.200.68.154])
 by relmlor4.idc.renesas.com ( SJSMS)
 with ESMTP id <0MQ4000YDLN1GO40@relmlor4.idc.renesas.com> for
 linux-media@vger.kernel.org; Thu, 18 Jul 2013 18:42:37 +0900 (JST)
Received: from relmlac1.idc.renesas.com ([10.200.69.21])
 by relmlir4.idc.renesas.com ( SJSMS)
 with ESMTP id <0MQ400IWZLN11990@relmlir4.idc.renesas.com> for
 linux-media@vger.kernel.org; Thu, 18 Jul 2013 18:42:37 +0900 (JST)
In-reply-to: <Pine.LNX.4.64.1307181120400.15796@axis700.grange>
References: <CAGGh5h1btafaMoaB89RBND2L8+Zg767HW3+hKG7Xcq2fsEN6Ew@mail.gmail.com>
 <1370423495-16784-1-git-send-email-phil.edworthy@renesas.com>
 <Pine.LNX.4.64.1307141216310.9479@axis700.grange>
 <OFA3A542CD.036B9760-ON80257BAC.0030962D-80257BAC.00327F73@eu.necel.com>
 <Pine.LNX.4.64.1307181120400.15796@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-version: 1.0
From: phil.edworthy@renesas.com
Message-id: <OFB4EA1129.D62AE37B-ON80257BAC.0034B22B-80257BAC.003553C0@eu.necel.com>
Date: Thu, 18 Jul 2013 10:42:28 +0100
Subject: Re: [PATCH v3] ov10635: Add OmniVision ov10635 SoC camera driver
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

> > There is one issue with setting the camera to achieve different 
framerate. 
> > The camera can work at up to 60fps with lower resolutions, i.e. when 
> > vertical sub-sampling is used. However, the API uses separate 
functions 
> > for changing resolution and framerate. So, userspace could use a low 
> > resolution, high framerate setting, then attempt to use a high 
resolution, 
> > low framerate setting. Clearly, it's possible for userspace to call 
s_fmt 
> > and s_parm in a way that attempts to set high resolution with the old 
> > (high) framerate. In this case, a check for valid settings will fail.
> > 
> > Is this a generally known issue and userspace works round it?
> 
> It is generally known, that not all ioctl() settings can be combined, 
yes. 
> E.g. a driver can support a range of cropping values and multiple 
formats, 
> but not every format can be used with every cropping rectangle. So, if 
you 
> first set a format and then an incompatible cropping or vice versa, one 
of 
> ioctl()s will either fail or adjust parameters as close to the original 
> request as possible. This has been discussed multiple times, ideas were 
> expressed to create a recommended or even a compulsory ioctl() order, 
but 
> I'm not sure how far this has come. I'm sure other developers on the 
list 
> will have more info to this topic.

Thanks for the info.

On a similar note, cameras often need quite long periods after setting 
registers before they take hold. Currently this driver will change the 
registers, and delay, for both calls to s_parm and s_fmt. Is there a way 
to avoid this?

Thanks
Phil
