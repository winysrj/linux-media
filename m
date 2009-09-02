Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:2216 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZIBNu0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Sep 2009 09:50:26 -0400
Message-ID: <3747ed57da74762bdc7c7bda3cad06ea.squirrel@webmail.xs4all.nl>
In-Reply-To: <Pine.LNX.4.64.0909021416520.6326@axis700.grange>
References: <Pine.LNX.4.64.0909021416520.6326@axis700.grange>
Date: Wed, 2 Sep 2009 15:50:19 +0200
Subject: Re: [PATCH 0/3] image-bus API
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Paulius Zaleckas" <paulius.zaleckas@teltonika.lt>,
	"Robert Jarzmik" <robert.jarzmik@free.fr>,
	"Kuninori Morimoto" <morimoto.kuninori@renesas.com>,
	"Laurent Pinchart" <laurent.pinchart@skynet.be>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi all
>
> Now that we definitely know on the OMAP 3 example, that a parameter like
> "packing" is indeed needed to fully describe video on-the-bus data, I
> haven't heard any more objections against my proposed API, so, this
> version could well be for inclusion.

A bit too optimistic I am afraid. I simply haven't had the time to look at
this in detail :-(

I fear that it won't be until the weekend of September 12th before I have
the time to sit down and fully research this.

Regards,

         Hans

> Of course, if there are improvement
> suggestions, we can address them. I am CC-ing people, that took part in
> discussing the RFC for this API (sent exactly a week ago:-)), and also
> authors of drivers and systems that I cannot test myself. Specifically, I
> only compile-tested the mx1_camera, and mt9m111 drivers, also would be
> good to test on the ap325rxa SuperH platform. Notice, it looks like the
> soc_camera_platform driver is currently broken, I am open for suggestions
> regarding what we should do with it - deprecate and schedule for removal,
> mark as broken, or fix:-)
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

