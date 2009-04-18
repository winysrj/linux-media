Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56248 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbZDRLYH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Apr 2009 07:24:07 -0400
Message-ID: <49E9B923.3080606@redhat.com>
Date: Sat, 18 Apr 2009 13:27:31 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l release: 0.5.97: the whitebalance release!
References: <49E5D4DE.6090108@hhs.nl> <200904162146.59742.linux@baker-net.org.uk> <49E843CB.6050306@redhat.com> <200904172313.47532.linux@baker-net.org.uk>
In-Reply-To: <200904172313.47532.linux@baker-net.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04/18/2009 12:13 AM, Adam Baker wrote:
> On Friday 17 Apr 2009, Hans de Goede wrote:
>>> I've tested it by plugging in the sq905 camera, verifying the
>>> whitebablance control is present and working, unplugging the sq905 and
>>> plugging in the pac207 and using up arrow to restart v4l2ucp and svv so I
>>> think I've eliminated most finger trouble possibilities. The pac207 is id
>>> 093a:2460 so not the problem id. I'll have to investigate more thoroughly
>>> later.
>> Does the pac207 perhaps have a / in its "card" string (see v4l-info output)
>> ? if so try out this patch:
>> http://linuxtv.org/hg/~hgoede/libv4l/rev/1e08d865690a
>>
>
> No, no / in the device name.
>
> I've tried enabling the logging option in libv4l while running v4l2-ctl -l to
> list the controls present on each camera but I can't see any significant
> looking differences in the log other than the the fact the sq905 seems to get
> many more unsuccessful VIDIOC_QUERYCTRL requests. Unless you have a better
> idea my next step would be to extend the logging to include the parameters on
> the VIDIOC_QUERYCTRL ioctls, however my gut feel is that it is related the
> camera having controls that have CIDs both lower and higher than the ones
> libv4l adds and libv4l doesn't do anything with the driver returned values if
> V4L2_CTRL_FLAG_NEXT_CTRL is set.
>

Ah, you are using v4l2-ctl, not v4l2ucp, and that uses V4L2_CTRL_FLAG_NEXT_CTRL
control enumeration. My code doesn't handle V4L2_CTRL_FLAG_NEXT_CTRL (which is
a bug). I'm not sure when I'll have time to fix this. Patches welcome, or in
the mean time use v4l2ucp to play with the controls.

Regards,

Hans
