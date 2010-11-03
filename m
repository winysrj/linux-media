Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([192.100.122.233]:61228 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab0KCUAI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Nov 2010 16:00:08 -0400
Message-ID: <4CD1BDB7.2030307@maxwell.research.nokia.com>
Date: Wed, 03 Nov 2010 21:53:27 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Yordan Kamenov <ykamenov@mm-sol.com>
Subject: Re: RFCl libv4l2 plugin API
References: <4CC9189E.3040700@redhat.com> <4CC91A3A.2070002@redhat.com>
In-Reply-To: <4CC91A3A.2070002@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hans de Goede wrote:
> Hi Sakari,

Hi Hans,

> On 10/28/2010 08:30 AM, Hans de Goede wrote:
>> Hans de Goede wrote:
>>  > Hi All,
>>
>> Hi Hans,
>>
>> Thanks for the RFC!
>>
>> I'd have a few comments and questions.
>>
>> The coding style for libv4l hasn't been defined as far as I understand.
>> Should kernel coding style be assumed, or something else?
> 
> v4l-utils uses kernel coding style.

Good! A well defined coding style is always a plus. The current codebase
doesn't quite follow it at the moment, though. (And I don't have a patch
either.) New patches should still pass checkpatch.pl, I understand.

I Cc'd Yordan who is working on the plugin interface.

...
>> However, the application is a V4L2 application which works on V4L2
>> devices and may well be unaware of the media device. I don't think this
>> is _necessarily_ a problem since the plugin can do whatever it sees fit
>> for user's request; it could even open another video node.
> 
> Yes this is the whole idea, the app uses just one video node, like with
> any regular v4l device, and then the plugin can open video nodes
> for "sub-devices" to hook up all the plumbing to get a pipeline which
> does what the app wants.

Ok.

Video nodes that are related to the ISP driver may not be opened as long
as one of them is in use. They use the same resources --- the ISP.
Multiple opens are possible but for the use case (libv4l) it makes no
sense since libv4l is just for capture.

V4L2 allows multiple opens but if the MC setup is done from both that
may easily result in an invalid configuration. So for the time being, I
think we will be limited to just one application per (MC) device for the
time being.

That's specific to OMAP 3 plugin, however.

>> Obviously, there can be only one of this kind of media device control
>> plugins at a time. Other plugins should have their say before that, so
>> that the device appears a regular V4L2 device for those plugins as well.
> 
> The current "design" (the RFC) assumes only one plugin per /dev/video#
> device, so no stacking of plugins on the same fd. It is possible to
> have multiple plugins, but only one will get "attached" to a certain
> fd. The idea here is that plugins are meant for doing certain hardware
> specific stuff. And different /dev/video# nodes could relate
> to completely different hardware, so we do need multiple plugins to
> support this. But as the purpose of the plugins is to deal with certain
> hardware specific things, having one plugin per type of hardware seems
> enough.

Sounds good.

>> The order in which the plugins are executed matters also if they do
>> image processing. The result may well be different.
> 
> As said, there can only be one plugin per fd.

This makes things easy indeed.

Thanks for your comments.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
