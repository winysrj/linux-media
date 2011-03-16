Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:59105 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab1CPKUz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 06:20:55 -0400
Message-ID: <4D808F03.90501@matrix-vision.de>
Date: Wed, 16 Mar 2011 11:20:51 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Bastian Hecht <hechtb@googlemail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Where to find 8-bit sbggr patch for omap3-isp
References: <AANLkTimB5br6fydkHnE9sYwhpPh0u56Swn-qKHN0s_J4@mail.gmail.com>
In-Reply-To: <AANLkTimB5br6fydkHnE9sYwhpPh0u56Swn-qKHN0s_J4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bastian,

On 03/16/2011 11:01 AM, Bastian Hecht wrote:
> Hello dear omap-isp developers,
> 
> I'm working with a  OV5642 sensor with an 8-bit parallel bus.
> 
> I'm referring to this patch:
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/29876/match=sgrbg8
> 
> Michael, you say that the patch applies to media-0005-omap3isp from Laurent.
> I cannot see it in the repo:
> http://git.linuxtv.org/pinchartl/media.git?a=blob;f=drivers/media/video/omap3-isp/ispccdc.c;h=5ff9d14ce71099cc672e71e2bd1d7ca619bbcc98;hb=media-0005-omap3isp
> 
> Hasn't the patch been merged into your tree yet, Laurent?
> Or am I looking at the wrong spot?

Laurent hasn't merged those patches into his tree yet, and when he does it
will probably not show up on top of that media-0005-omap3isp branch, but
rather be incorporated into a future branch.  The most recent version I've
submitted to the list is

http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/30258

I'm waiting a bit to see if Laurent has any more comments on the patches
before submitting v4.  So if you want them you'll have to take them from
the list for now.

-Michael

> 
> Thanks for help,
> 
>  Bastian Hecht

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
