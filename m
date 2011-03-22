Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:41831 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab1CVMRl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 08:17:41 -0400
Message-ID: <4D889362.9070007@matrix-vision.de>
Date: Tue, 22 Mar 2011 13:17:38 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: =?ISO-8859-15?Q?Lo=EFc_Akue?= <akue.loic@gmail.com>,
	linux-media@vger.kernel.org, Neil MacMunn <neil@gumstix.com>,
	Bastian Hecht <hechtb@googlemail.com>
Subject: Re: Demande de support V4L2
References: <AANLkTinK1MvhNtAKpSwMARZhLNrW+FGLwd9KMcbdwOCa@mail.gmail.com> <AANLkTin+4_Y65nL9h45feGarzmuJaeZnWxfyMPyDQai0@mail.gmail.com> <AANLkTikyoEKuBvLhnFo7t9wXBPwNnQy5mxgnVyns6TWZ@mail.gmail.com> <201103211843.39677.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103211843.39677.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/21/2011 06:43 PM, Laurent Pinchart wrote:
> Hi Loïc,
> 
> On Friday 18 March 2011 16:43:40 Loïc Akue wrote:
>> Hi,
>>
>> Do you know if Gstreamer or Mplayer are able to capture some vidéo from the
>> CCDC output?
>> I've been trying with the v4l2src plugin but Gstreamer "can negociate
>> format".
> 
> I haven't tried mplayer or v4l2src with the OAMP3 ISP, sorry.
> 


Hi Loïc,

GStreamer relies on ENUM_FMT to negotiate the format, which the current
ISP driver doesn't provide.  I have patched my kernel to do this and I
have gotten GStreamer to display UYVY images from the previewer output,
but I haven't spent much time trying to get it from the CCDC yet.  I
would be interested to hear your progress there.

I will submit my ENUM_FMT patch to the list in a different thread.

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
