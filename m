Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33916 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750985AbZH0IZd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 04:25:33 -0400
Date: Thu, 27 Aug 2009 10:25:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Pixel format definition on the "image" bus
In-Reply-To: <6d6c955a28219f061dd31af4e0473415.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.0908271017280.4808@axis700.grange>
References: <Pine.LNX.4.64.0908261452460.7670@axis700.grange>   
 <200908270851.27073.hverkuil@xs4all.nl>    <Pine.LNX.4.64.0908270857230.4808@axis700.grange>
 <6d6c955a28219f061dd31af4e0473415.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 27 Aug 2009, Hans Verkuil wrote:

> > Unfortunately, even the current soc-camera approach with its
> > format-enumeration and -conversion API is not enough. As I explained
> > above, there are two ways you can handle source's data: "cooked" and
> > "raw." The "cooked" way is simple - the sink knows exactly this specific
> > format and knows how to deal with it. Every sink has a final number of
> > such natively supported formats, so, that's just a switch-case statement
> > in each sink driver, that is specific to each sink hardware, and that you
> > cannot avoid.
> >
> > It's the "raw" or "pass-through" mode that is difficult. It is used, when
> > the sink does not have any specific knowledge about this format, but can
> > pack data into RAM in some way, or, hopefully, in a number of ways, among
> > which we can choose. The source "knows" what data it is delivering, and,
> > in principle, how this data has to be packed in RAM to provide some
> > meaningful user format. Now, we have to pass this information on to the
> > sink driver to tell it "if you configure the source to deliver the raw
> > format X, and then configure your bus in a way Y and pack the data into
> > RAM in a way Z, you get as RAM user format W." So, my proposal is - during
> > probing, the sink enumerates all raw formats, provided by the source,
> > accepts those formats, that it can process natively ("cooked" mode), and
> > verifies if it can be configured to bus configuration Y and can perform
> > packing Z, if so, it adds format W to the list of supported formats. Do
> > you see an easier way to do this? I'm currently trying to port one driver
> > combination to this scheme, I'll post a patch, hopefully, later today.
> 
> I'm not so keen on attempting to negotiate things that probably are
> impossible to negotiate anyway. (You may have noticed that before :-) )

I bought your argument about subtle image corruption that might be 
difficult to debug back to a wrongly chosen signal polarity and / or 
sensing edge. Now, what's your argument for this one apart from being "not 
so keen?" Being not keen doesn't seem a sufficient argument to me for 
turning platform data into trash-bins.

Example: currently a combination SuperH CEU platform with a OV772x camera 
sensor connected can provide 11 output formats. There are at least two 
such boards currently in the mainline with the same bus configuration. Do 
you want to exactly reproduce these 11 entries in these two boards? What 
about other boards?

> One approach would be to make this mapping part of the platform data that
> is passed to the bridge driver.
> 
> For a 'normal' PCI or USB driver information like this would be contained
> in the bridge driver. Here you have a generic bridge driver intended to
> work with different SoCs, so now that information has to move to the
> platform data. That's the only place where you know exactly how to setup
> these things.
> 
> So you would end up with a list of config items:
> 
> <user fourcc>, <bridge fourcc>, <sensor fourcc>, <bus config>
> 
> And the platform data of each sensor device would have such a list.
> 
> So the bridge driver knows that VIDIOC_ENUMFMT can give <user fourcc> back
> to the user, and if the user selects that, then it has to setup the bridge
> using <bridge fourcc> and the sensor using <sensor fourcc>, and the bus as
> <bus config>.
> 
> This is just a high level view as I don't have time to go into this in
> detail, but I think this is a reasonable approach. It's really no
> different to what the PCI and USB drivers are doing, except formalized for
> the generic case.

Please, give me a valid reason, why this cannot be auto-enumerated.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
