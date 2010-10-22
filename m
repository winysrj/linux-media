Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:33044 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab0JVOCg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 10:02:36 -0400
Message-ID: <4CC197B3.3040208@matrix-vision.de>
Date: Fri, 22 Oct 2010 15:54:59 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: Bastian Hecht <hechtb@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com
Subject: Re: OMAP 3530 camera ISP forks and new media framework
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com> <4CADA7ED.5020604@maxwell.research.nokia.com>
In-Reply-To: <4CADA7ED.5020604@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sakari Ailus wrote:
> Bastian Hecht wrote:
>> Hello media team,
> 
> Hi Bastian,
> 
>> I want to write a sensor driver for the mt9p031 (not mt9t031) camera
>> chip and start getting confused about the different kernel forks and
>> architectural changes that happen in V4L2.
>> A similar problem was discussed in this mailing list at
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg19084.html.
>>
>> Currently I don't know which branch to follow. Either
>> http://gitorious.org/omap3camera from Sakari Ailus or the branch
>> media-0004-omap3isp at http://git.linuxtv.org/pinchartl/media.git from
>> Laurent Pinchart. Both have an folder drivers/media/video/isp and are
>> written for the new media controller architecture if I am right.
> 
> Take Laurent's branch it has all the current patches in it. My gitorious
> tree isn't updated anymore. (I just had forgotten to add a note, it's
> there now.)
> 

Will Laurent's media-0004-omap3isp branch at linuxtv.org then continue to get updated?  Or will the existing commits be rebased at some point?  I'm trying to understand/decide what the best approach is with git if I continue doing development on top of the media controller and want to stay up to date.

<snip>

thanks,

-- 
Michael Jones

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
