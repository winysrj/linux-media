Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36450 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291AbZDQIvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 04:51:08 -0400
Message-ID: <49E843CB.6050306@redhat.com>
Date: Fri, 17 Apr 2009 10:54:35 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l release: 0.5.97: the whitebalance release!
References: <49E5D4DE.6090108@hhs.nl> <200904152326.59464.linux@baker-net.org.uk> <49E66787.2080301@hhs.nl> <200904162146.59742.linux@baker-net.org.uk>
In-Reply-To: <200904162146.59742.linux@baker-net.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04/16/2009 10:46 PM, Adam Baker wrote:
> On Thursday 16 Apr 2009, Hans de Goede wrote:
>> On 04/16/2009 12:26 AM, Adam Baker wrote:
>>> On Wednesday 15 Apr 2009, Hans de Goede wrote:
>>>> Currently only whitebalancing is enabled and only on Pixarts (pac)
>>>> webcams (which benefit tremendously from this). To test this with other
>>>> webcams (after instaling this release) do:
>>>>
>>>> export LIBV4LCONTROL_CONTROLS=15
>>>> LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so v4l2ucp&
>>> Strangely while those instructions give me a whitebalance control for the
>>> sq905 based camera I can't get it to appear for a pac207 based camera
>>> regardless of whether LIBV4LCONTROL_CONTROLS is set.
>> Thats weird, there is a small bug in the handling of pac207
>> cams with usb id 093a:2476 causing libv4l to not automatically
>> enable whitebalancing (and the control) for cams with that id,
>> but if you have LIBV4LCONTROL_CONTROLS set (exported!) both
>> when loading v4l2ucp (you must preload v4l2convert.so!) and
>> when loading your viewer, then it should work.
>>
>
> I've tested it by plugging in the sq905 camera, verifying the whitebablance
> control is present and working, unplugging the sq905 and plugging in the
> pac207 and using up arrow to restart v4l2ucp and svv so I think I've
> eliminated most finger trouble possibilities. The pac207 is id 093a:2460 so
> not the problem id. I'll have to investigate more thoroughly later.
>

Does the pac207 perhaps have a / in its "card" string (see v4l-info output) ?
if so try out this patch:
http://linuxtv.org/hg/~hgoede/libv4l/rev/1e08d865690a

Thanks & Regards,

Hans
