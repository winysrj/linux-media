Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:61243 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab2JKWNR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 18:13:17 -0400
Date: Fri, 12 Oct 2012 00:13:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dmitry Lavnikevich <haff@midgard.by>
cc: linux-media@vger.kernel.org
Subject: Re: SoC camera host drivers
In-Reply-To: <CAJ4uU1Bda04GDDwXYW9OMewbR1nTQtxZihy7_1r3FnXJTkxVsQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1210120006150.10000@axis700.grange>
References: <CAJ4uU1Dt+1ixM-E9BhdeguNQ3QJMHvUckCm7OJeraH19LpSx3g@mail.gmail.com>
 <CAJ4uU1Bda04GDDwXYW9OMewbR1nTQtxZihy7_1r3FnXJTkxVsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitry

On Thu, 11 Oct 2012, Dmitry Lavnikevich wrote:

> Hello!
> 
> I'm trying to implement camera support for my i.MX6 board and cannot
> understand a couple of (it seems) simple things according to how it
> all must work.
> 
> My camera is mt9m001 and i can perfectly find and use it's camera
> driver. But as far as I understand, host driver must be loaded too...
> and there is a very few of them. I can find host drivers for
> surprisingly few platforms like pxa_camera, mx1_camera, mx2_camera and
> a few others. But there is no mx6 or something for it. And i cannot
> understand why. Is it means that needed driver just wasn't implemented
> yet and I must write it on my own, or I don't understand something
> essential?

I'm not sure about the state of i.MX6, but have a look at 
drivers/media/platform/coda.c. It is not using soc-camera, and I don't 
seem to find any examples of board files, using that driver... And if you 
need mt9m001, which is (originally) an soc-camera driver, it will have to 
be slightly adjusted to work with other hosts.

Thanks
Guennadi

> Because I can see in kernel meny board specific source files where
> different SoC cameras are enabled but at the same time I cannot find
> needed host drivers. For instance I see in
> arch/arm/mach-mx6/board-mx6q_arm2.c enabled soc camera ov5640 but
> again i cannot find a thing about needed mx6 host driver. Is that
> means that this board camera actually cannot be used because of
> absence of needed host driver or am I missing something?
> 
> Best regards,
> Lavnikevich Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
