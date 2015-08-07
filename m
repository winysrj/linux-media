Return-path: <linux-media-owner@vger.kernel.org>
Received: from hl140.dinaserver.com ([82.98.160.94]:54046 "EHLO
	hl140.dinaserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbbHGLEV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2015 07:04:21 -0400
Received: from [192.168.2.27] (5.Red-212-170-183.staticIP.rima-tde.net [212.170.183.5])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by hl140.dinaserver.com (Postfix) with ESMTPSA id 7FBBF4964B3F
	for <linux-media@vger.kernel.org>; Fri,  7 Aug 2015 13:04:14 +0200 (CEST)
Message-ID: <55C490AD.1010904@by.com.es>
Date: Fri, 07 Aug 2015 13:04:13 +0200
From: Javier Martin <javiermartin@by.com.es>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Re: imx-drm: Color issues scanning out YUV420 frames through the
 overlay plane.
References: <55C45D72.1030204@by.com.es>
In-Reply-To: <55C45D72.1030204@by.com.es>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for sending this to the wrong list.

On 07/08/15 09:25, Javier Martin wrote:
> Hi,
> I am using mainline kernel 4.1 and I was writing a small application
> that uses double buffering to read YUV420 frames from a file at 30fps
> and displays them using the overlay plane in the imx-drm driver.
>
> The first issue I noticed is that the image was green so I had to apply
> the following patches to make the U and V components be scanned out
> properly:
>
> http://lists.freedesktop.org/archives/dri-devel/2014-October/071052.html
> http://lists.freedesktop.org/archives/dri-devel/2014-October/071025.html
> http://lists.freedesktop.org/archives/dri-devel/2014-October/071048.html
>
> The thing is that, even after applying the 3 patches above, colors are a
> bit strange. They seem about right but there are some artifacts, like a
> saturation effect that spoils the image. You can see some snapshots here
> to see what I am talking about:
> https://imageshack.com/i/f0nAM5Xbj
> https://imageshack.com/i/hl7bZMNjj
> https://imageshack.com/i/eyRjURxRj
>
> And the original video is the first one in this page:
> http://media.xiph.org/video/derf/
>
> On the other hand, colors in the primary plane using the fbdev interface
> and RGB look correct.
>
> Has anyone seen something similar or is YUV420 working fine for you?
>
> Regards,
> Javier.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


