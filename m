Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41878 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752700AbeDKSQD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 14:16:03 -0400
Subject: Re: a 4.16 kernel with Debian 9.4 "stretch" causes a log explosion
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Edgar Thier <info@edgarthier.net>
References: <alpine.DEB.2.20.1804110911021.18053@axis700.grange>
 <e79738af-8d6d-a6b1-2539-d2dbdb07bb53@ideasonboard.com>
 <b33d611d-99ea-b350-9351-f5b8986e3fe9@ideasonboard.com>
 <alpine.DEB.2.20.1804111848320.25028@axis700.grange>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <2838ba6c-7425-f45f-d121-e519093ab842@ideasonboard.com>
Date: Wed, 11 Apr 2018 19:15:58 +0100
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1804111848320.25028@axis700.grange>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 11/04/18 18:06, Guennadi Liakhovetski wrote:

 <snip>

>>>>
>>>> Just figured out this commit
>>>>
>>>> From: Edgar Thier <info@edgarthier.net>
>>>> Date: Thu, 12 Oct 2017 03:54:17 -0400
>>>> Subject: [PATCH] media: uvcvideo: Apply flags from device to actual properties
>>>>
>>>> as the culprit. Without it everything is back to normal.
>>>
>>> I've already investigated and fixed this:
>>>
>>> Please apply:
>>> 	https://patchwork.kernel.org/patch/10299735/
> 
> Great, thanks! That seems to fix my problem.

Fantastic. I'm glad it helped.

 - Can I call that a Tested-by: ? :-D

Regards

Kieran
