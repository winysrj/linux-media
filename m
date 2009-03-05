Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1749 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbZCEIk4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 03:40:56 -0500
Message-ID: <20296.62.70.2.252.1236242449.squirrel@webmail.xs4all.nl>
Date: Thu, 5 Mar 2009 09:40:49 +0100 (CET)
Subject: Re: identifying camera sensor
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>,
	"camera@ok.research.nokia.com" <camera@ok.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Wednesday 04 March 2009 16:52:20 ext Hans Verkuil wrote:
>> > Alternatively, VIDIOC_QUERYCAP could be used to identify the sensor.
>> > Would it make more sense if it would return something like
>> >   capability.card:  `omap3/smia-sensor-12-1234-5678//'
>> > where 12 would be manufacturer_id, 1234 model_id, and
>> > 5678 revision_number?
>>
>> Yuck :-)
>
> Agreed :)
>
> Also, if there are many slaves, the length of the capability.card
> field is not sufficient.
>
> From: Trent Piepho <xyzzy@speakeasy.org>
>> You could always try to decode the manufacturer name and maybe even the
>> model name.  After all, pretty much every other driver does this.
>
> That would be possible, but the driver would then need a device name table
> which would need to be modified whenever a new chip comes up :(
>
> On Wednesday 04 March 2009 16:52:20 ext Hans Verkuil wrote:
>> G_CHIP_IDENT is probably the way to go, provided you are aware of the
>> limitations of this ioctl. Should this be a problem, then we need to
>> think
>> of a better solution.
>
> Could you tell me what limitations?
>
> I thought about that ioctl initially, but then read that it is going
> to be removed, that's why abandoned it.

The limitation is that it's API might change from one kernel version to
another. It's not going to be removed.

http://n2.nabble.com/-REVIEW--v4l2-debugging:-match-drivers-by-name-instead-of-the-deprecated-ID-td1681635.html

That's the API change :-) This change is already in 2.6.29.

> But if you say it's a good way, then I'll go that way.
> The intention is to get the SMIA driver included into official kernel,
> so I'd prefer a method which allows that :-)

Using DBG_G_CHIP_IDENT is the quick way of doing things, but it is by
definition an API that might change in the future (although I hope that
doesn't happen anytime soon). If you want something stable, then we need
to come up with an alternative.

ENUMINPUT is probably a better solution: you can say something like
"Camera 1 (sensor1)", "Camera 2 (sensor2)".

It remains a bit of a hack, though.

The problem is that DBG_G_CHIP_IDENT is really the only ioctl that can do
what you want, but it is meant for internal use only.

Perhaps this calls for an ENUM_CHIPS ioctl that calls G_CHIP_IDENT
internally.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

