Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:53206 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZCIIB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 04:01:27 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1829950wfa.4
        for <linux-media@vger.kernel.org>; Mon, 09 Mar 2009 01:01:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200903090841.46902.hverkuil@xs4all.nl>
References: <5e9665e10903081842h2c8a7185lc9a7e2a6d0f63a2a@mail.gmail.com>
	 <200903090841.46902.hverkuil@xs4all.nl>
Date: Mon, 9 Mar 2009 17:01:25 +0900
Message-ID: <5e9665e10903090101g9c774a8m898b396cb904b28@mail.gmail.com>
Subject: Re: Is there any reference for v4l2-subdev?
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you Hans,

Now it is so clear.
Thank you for your clear explanation. I'll be posting a new camera
module (sensor+ISP) driver sooner or later.
Cheers,

Nate


On Mon, Mar 9, 2009 at 4:41 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Monday 09 March 2009 02:42:03 Dongsoo Nathaniel Kim wrote:
>> Hello Hans,
>>
>> I've been working on camera device based on v4l2-int-device until now,
>> but to follow latest work of yours I decided to make my driver in v4l2
>> subdev before I send patch to the list.
>> So I'm trying to find any passable driver to reference but I haven't
>> found any one yet.
>> Only thing I could find was v4l2-framework.txt for now. Am I missing
>> something? I've not look into every single repository in hg yet, but
>> which one could be the right one I am looking for?
>> Please give me a guideline if there are some further work besides
>> v4l2-framework.txt.
>> Cheers,
>>
>> Nate
>
> Hi Nate,
>
> In the master v4l-dvb (www.linuxtv.org/hg/v4l-dvb) almost all i2c modules
> have been converted. It can however be confusing due to the use of
> backwards compatibility headers v4l2-i2c-drv.h and v4l2-i2c-drv-legacy.h.
> The latter will disappear once all adapter drivers have been converted. The
> first is still needed since the v4l-dvb master also supports kernels <
> 2.6.22.
>
> There has been a lot of discussion about that and it looks like
> v4l2-i2c-drv.h will probably disappear as well in the future as we will
> attempt to do the backwards compatibility in a different way.
>
> Since you don't need such compatibility, you can ignore those headers and
> only concentrate on the subdev changes.
>
> Good examples are wm8739.c and saa7115.c. Note that there are no sensor
> drivers converted as these are currently all soc-camera or v4l2-int based.
> I'm sure that you will need to add new ops to v4l2-subdev.h for sensor
> drivers.
>
> The v4l-dvb master also contains several PCI and USB drivers that are
> converted to use v4l2_device/v4l2_subdev. Probably the best to look at is
> saa7134. Also interesting is cx18 since that models the analog digitizer
> part of the cx23418 device as a subdev, thus demonstrating that sub-devices
> do not have to be actual i2c devices.
>
> It would be great if at least one sensor driver could be implemented in
> v4l2_subdev before the 2.6.30 merge window opens. Any changes that need to
> be made to v4l2_subdev to support such drivers will then be in the 2.6.30
> tree which will make it easier for you to track compared to v4l-dvb.
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>



-- 
========================================================
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
