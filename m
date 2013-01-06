Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:56592 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852Ab3AFBn0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jan 2013 20:43:26 -0500
Received: from mailout-de.gmx.net ([10.1.76.31]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MWvNq-1TWi5o1nqW-00VzBa for
 <linux-media@vger.kernel.org>; Sun, 06 Jan 2013 02:43:24 +0100
Message-ID: <50E8D6AA.1040305@gmx.net>
Date: Sun, 06 Jan 2013 02:43:06 +0100
From: Andreas Nagel <andreasnagel@gmx.net>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: How to configure resizer in ISP pipeline?
References: <50C747B7.20107@gmx.net> <20130106010321.GE13641@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130106010321.GE13641@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

thanks for helping.

>> My "sensor" (TVP5146) already provides YUV data, so I can skip the
>> previewer. I tried setting the input and output pad of the resizer
>> subdevice to incoming resolution (input pad) and desired resolution
>> (output pad). For example: 720x576 --> 352x288. But it didn't work
>> out quite well.
> How did it not work quite well? :)

Not sure, if I recall all the details. I haven't done much in this area 
for a few weeks now.
Currently, I actually can configure the resizer, but then 
VIDIOC_STREAMON fails with EINVAL when I configure the devnode. Don't 
know why.
I do connect the resizer source to the resizer output (devnode) and then 
capture from there. I think it is /dev/video6.
If I leave the resizer out and connect the ccdc source to the ccdc 
output (/dev/video2), capturing works just fine.

One reason could be, that the resizer isn't supported right now. (You 
remember, I have to use Technexion's TI kernel 2.6.37 with its exotic 
ISP driver. ;-) )
That's, what one could interpret from this TI wiki page.
http://processors.wiki.ti.com/index.php/UserGuideOmap35xCaptureDriver_PSP_04.02.00.07#Architecture
Under the block diagram, there's a note saying, that only the path with 
the continuous line has been validated. So, the dotted lines are ISP 
paths that might not have been validated ("supported"?) yet.


(I might add, that all this is part of my master thesis and resizing 
would be a nice-to-have goal, but not a must-have. So I can live with it 
if it won't work.)

>> Can someone explain how one properly configures the resizer in an
>> ISP pipeline (with Media Controller API) ? I spend some hours
>> researching, but this topic seems to be a well guarded secret...
> There's nothing special about it. Really.
>
> The resizing factor is chosen by setting the media bus format on the source
> pad to the desired size.

Yes, that is what I figured out eventually.
