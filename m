Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39736 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752692AbZKLOMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 09:12:05 -0500
Date: Thu, 12 Nov 2009 15:12:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sedji Gaouaou <sedji.gaouaou@atmel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: atmel v4l2 soc driver
In-Reply-To: <4AFC15E6.2000101@atmel.com>
Message-ID: <Pine.LNX.4.64.0911121510250.15708@axis700.grange>
References: <49B789F8.3070906@atmel.com> <Pine.LNX.4.64.0903111100050.4818@axis700.grange>
 <49C7A8DF.3040101@atmel.com> <Pine.LNX.4.64.0903231632020.6370@axis700.grange>
 <49C7B226.6000302@atmel.com> <Pine.LNX.4.64.0903231705080.6370@axis700.grange>
 <49C7B57C.7040809@atmel.com> <Pine.LNX.4.64.0908030909570.4401@axis700.grange>
 <4AFC15E6.2000101@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 12 Nov 2009, Sedji Gaouaou wrote:

> Hi,
> 
> Sorry to answer you so late about the driver.
> I have a working version which is based on 2.6.27. It is using the V4L2 API,
> but not the soc-video.
> I am not able to update it for the time being, even if it is something that we
> want to do.
> Are you still interested by the "old" driver?

Yes, it would be nice to have the latest version of your driver available, 
although I cannot tell when I will find time to do the conversion. So far 
I'm quite loaded with work, so, it won't happen soon. But please do make 
your latest version available, maybe upload it to some site, where 
everyone can download it from and update if you get newer versions?

Thanks
Guennadi

> 
> Regards,
> Sedji
> 
> Guennadi Liakhovetski a écrit :
> > Hi Sedji,
> > 
> > On Mon, 23 Mar 2009, Sedji Gaouaou wrote:
> > 
> > > Well I am confused now...Should I still convert the atmel ISI driver to a
> > > soc
> > > driver?
> > > My concern was not to release a driver for the ov9655, but to have one
> > > which
> > > is working so I could test my atmel-soc driver :)
> > > Because I only have an ov9655 sensor here...
> > 
> > What's the status of the ISI driver porting? Any progress? Or any plans idea
> > when you will be able to work on it? If you have no plans to do the porting
> > in the near future, maybe you could send me your latest patch, so, I could
> > have a look at it and _maybe_ see, if I find time to convert it myself (no
> > promise though)?
> > 
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > 
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
