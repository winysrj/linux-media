Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51651 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290AbbIUUjT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 16:39:19 -0400
Date: Mon, 21 Sep 2015 22:38:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javiermartin@by.com.es>
cc: linux-media <linux-media@vger.kernel.org>,
	=?UTF-8?Q?Germ=c3=a1n_Villar?= <german@by.com.es>,
	=?UTF-8?Q?Antonio_P=c3=a9rez_Barrero?= <antonioperez@by.com.es>
Subject: Re: RFC: ov5640 kernel driver.
In-Reply-To: <5600334B.4090507@by.com.es>
Message-ID: <Pine.LNX.4.64.1509212231570.7302@axis700.grange>
References: <5600334B.4090507@by.com.es>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Mon, 21 Sep 2015, Javier Martin wrote:

> Hi,
> we want to a v4l2 driver for the ov5640 sensor from Omnivision.
> 
> AFAIK, there was an attempt in the past to mainline that driver [1] but it
> didn't make it in the end.
> 
> Some people were asking for the code for the ov5640 and the ov5642 to be
> merged [2] as well but IMHO both sensors are not that similar so that it's
> worth a common driver.
> 
> The approach we had in mind so far was creating a new, independent,
> v4l2-subdev driver for the ov5640 with mbus support.
> 
> I've found several sources out there with code for the ov5640 but,
> surprisingly, few attempts to mainline it. I would whether it is just people
> didn't take the effort or there was something wrong with the code.
> 
> Has anyone got some comments/advices on this before we start coding?

AFAICS there are often multiple versions of drivers for various devices in 
multiple github and other repositories. Many of them never even get 
announced to respective mainline-oriented mailing lists, some do get 
submitted once, but as you say - don't make the effort to finalise the 
process. So, I would say, if you can find a driver, that works for you, 
has a suitable licence and code quality, you can submit it to the 
mainline, preserving the author or at least giving them sufficient credit 
if you heavily modify it. I would also at least inform the author(s) and 
ask them if they want to submit the driver themselves.

Others might add more:)

Thanks
Guennadi

> Is anyone
> already working on this and maybe we can collaborate instead of having two
> forks of the same driver?
> 
> Regards,
> Javier.
> 
> [1] https://lwn.net/Articles/470643/
> [2] http://www.spinics.net/lists/linux-omap/msg69611.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
