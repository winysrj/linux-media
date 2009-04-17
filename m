Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:23160 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbZDQHuh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 03:50:37 -0400
Received: by rv-out-0506.google.com with SMTP id f9so803384rvb.1
        for <linux-media@vger.kernel.org>; Fri, 17 Apr 2009 00:50:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0904170941540.5119@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
	 <5e9665e10904170029g56c0be23i9116c28b4a723314@mail.gmail.com>
	 <Pine.LNX.4.64.0904170941540.5119@axis700.grange>
Date: Fri, 17 Apr 2009 16:50:35 +0900
Message-ID: <5e9665e10904170050l2a50b8dawa9753e9379ad4f4b@mail.gmail.com>
Subject: Re: [PATCH 0/5] soc-camera: convert to platform device
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 17, 2009 at 4:48 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Fri, 17 Apr 2009, Dongsoo, Nathaniel Kim wrote:
>
>> I've got one more thing to ask.
>> Is SoC camera framework supporting for selecting video standards
>> between camera interface and external camera module? I mean ITU-R BT
>> 601 and 656 things.
>> Or any different way that I'm not aware is supported?
>
> I thought someone did it already, maybe there were some patches that
> didn't make it in yet, cannot find ATM. In any case, we do have a pretty
> advanced (!:-)) bus parameter negotiation infrastructure, so, you would
> just have a couple more SOCAM_* flags, like SOCAM_BT601, SOCAM_BT656 or
> similar and use them to configure your host-camera link, depending upon
> their capabilities and platform flags. See for example how SOCAM_MASTER /
> SOCAM_SLAVE is selected. Also don't forget to extend the
> soc_camera_bus_param_compatible() function.

Pretty cool! I didn't realize that.
Cheers

>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
>



-- 
========================================================
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
