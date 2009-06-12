Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f187.google.com ([209.85.216.187]:38137 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbZFLHD4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 03:03:56 -0400
Received: by mail-px0-f187.google.com with SMTP id 17so475823pxi.33
        for <linux-media@vger.kernel.org>; Fri, 12 Jun 2009 00:03:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0906120820450.4843@axis700.grange>
References: <Pine.LNX.4.64.0906101549160.4817@axis700.grange>
	 <Pine.LNX.4.64.0906101604420.4817@axis700.grange>
	 <5e9665e10906110410w7893e016g6e35742c9a55889d@mail.gmail.com>
	 <Pine.LNX.4.64.0906111413250.5625@axis700.grange>
	 <5e9665e10906111853w1af3aec9wcf647a280d3635e7@mail.gmail.com>
	 <Pine.LNX.4.64.0906120820450.4843@axis700.grange>
Date: Fri, 12 Jun 2009 16:03:59 +0900
Message-ID: <5e9665e10906120003w3f031c6ic90c79427603f4d2@mail.gmail.com>
Subject: Re: [PATCH 3/4] soc-camera: add support for camera-host controls
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 12, 2009 at 3:30 PM, Guennadi
Liakhovetski<g.liakhovetski@gmx.de> wrote:
> On Fri, 12 Jun 2009, Dongsoo, Nathaniel Kim wrote:
>
>> Hello Guennadi,
>>
>> So let's assume that camera interface device can process
>> V4L2_CID_SHARPNESS and even external camera device can process that,
>> then according to your patch both of camera interface and external
>> camera device can be issued to process V4L2_CID_SHARPNESS which I
>> guess will make image sharpened twice. Am I getting the patch right?
>
> Please, do not top-post!

Sorry for top-posting. just forgot the netiquette.

>
> I am sorry, is it really so difficult to understand
>
>> >> > +               ret = ici->ops->set_ctrl(icd, ctrl);
>> >> > +               if (ret != -ENOIOCTLCMD)
>> >> > +                       return ret;
>
> which means just one thing: the camera host (interface if you like) driver
> decides, whether it wants client's control to be called, in which case it
> has to return -ENOIOCTLCMD, or it returns any other code (0 or a negative
> error code), then the client will not be called.
>

yes I understand what you intended. but what I wanted to tell you was
with this way, user should modify the camera host driver if they want
to make camera host to return -ENOIOCTLCMD.

>> If I'm getting right, it might be better to give user make a choice
>> through platform data or some sort of variable which can make a choice
>> between camera interface and camera device to process the CID. It
>> could be just in aspect of manufacturer mind, we do love to make a
>> choice between same features in different devices in easy way. So
>> never mind if my idea is not helpful making your driver elegant :-)
>
> So far it seems too much to me. Let's wait until we get a case where it
> really makes sense for platform code to decide who processes certain
> controls. I think giving the host driver the power to decide should be ok
> for now.
>

I totally understand. you are already doing a great job. I won't push you.
Cheers,

Nate

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
