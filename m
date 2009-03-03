Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:7520 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZCCFNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 00:13:13 -0500
MIME-Version: 1.0
In-Reply-To: <19F8576C6E063C45BE387C64729E73940427BC9B86@dbde02.ent.ti.com>
References: <5e9665e10903021848u328e0cd4m5186344be15b817@mail.gmail.com>
	 <19F8576C6E063C45BE387C64729E73940427BC9B86@dbde02.ent.ti.com>
Date: Tue, 3 Mar 2009 14:13:11 +0900
Message-ID: <5e9665e10903022113r17e36afh7861fd00cd8ef0f7@mail.gmail.com>
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
From: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Ailus Sakari (Nokia-D/Helsinki)" <Sakari.Ailus@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you for your reply.

This is quite confusing because in case of mine, I wanna make
switchable between different cameras attached to omap camera
interface.
Which idea do I have to follow? Comparing with multiple video input
devices and multiple cameras attached to single camera interface is
giving me no answer.

Perhaps multiple cameras with single camera interface couldn't make
sense at the first place because single camera interface can go with
only one camera module at one time.
But we are using like that. I mean dual cameras with single camera
interface. There is no choice except that when we are using dual
camera without stereo camera controller.

By the way, I cannot find any API documents about
VIDIOC_INT_S_VIDEO_ROUTING but it seems to be all about "how to route
between input device with output device".
What exactly I need is "how to make switchable with multiple camera as
an input for camera interface", which means just about an input
device. In my opinion, those are different issues each other..(Am I
right?)
Cheers,

Nate


On Tue, Mar 3, 2009 at 12:53 PM, Hiremath, Vaibhav <hvaibhav@ti.com> wrote:
>
>
> Thanks,
> Vaibhav Hiremath
>
>> -----Original Message-----
>> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
>> owner@vger.kernel.org] On Behalf Of DongSoo(Nathaniel) Kim
>> Sent: Tuesday, March 03, 2009 8:18 AM
>> To: Tuukka.O Toivonen
>> Cc: Aguirre Rodriguez, Sergio Alberto; linux-omap@vger.kernel.org;
>> Ailus Sakari (Nokia-D/Helsinki); Nagalla, Hari
>> Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
>>
>> Hi Tuukka,
>>
>> I understand that it is a huge thing to support VIDIOC_S_INPUT.
>> But without that, we don't have any proper "V4L2" api to get
>> information about how many devices are attached to camera interface,
>> and names of input devices...and so on. Because VIDIOC_ENUMINPUT and
>> VIDIOC_G_INPUT needs VIDIOC_S_INPUT for prior. Of course we can
>> refer
>> to sysfs, but using only single set of APIs like V4L2 looks more
>> decent.
>>
>> What do you think about this?
>> If you think that it is a big burden, can I make a patch for this?
>> Cheers,
>>
> [Hiremath, Vaibhav] You may want to refer to the thread on this subject.
>
> http://marc.info/?l=linux-omap&m=122772175002777&w=2
> http://marc.info/?l=linux-omap&m=122823846806440&w=2
>
>> Nate
>>
>> On Mon, Feb 23, 2009 at 5:50 PM, Tuukka.O Toivonen
>> <tuukka.o.toivonen@nokia.com> wrote:
>> > On Monday 23 February 2009 10:08:54 ext DongSoo(Nathaniel) Kim
>> wrote:
>> >> So, logically it does not make sense with making device nodes of
>> every
>> >> single slave attached with OMAP3camera interface. Because they
>> can't
>> >> be opened at the same time,even if it is possible it should not
>> work
>> >> properly.
>> >>
>> >> So.. how about making only single device node like /dev/video0
>> for
>> >> OMAP3 camera interface and make it switchable through V4L2 API.
>> Like
>> >> VIDIOC_S_INPUT?
>> >
>> > You are right that if the OMAP3 has several camera sensors
>> attached
>> > to its camera interface, generally just one can be used at once.
>> >
>> > However, from user's perspective those are still distinct
>> > cameras. Many v4l2 applications don't support VIDIOC_S_INPUT
>> > or at least it will be more difficult to use than just pointing
>> > an app to the correct video device. Logically they are two
>> > independent cameras, which can't be used simultaneously
>> > due to HW restrictions.
>> >
>> > - Tuukka
>> >
>>
>>
>>
>> --
>> ========================================================
>> DongSoo(Nathaniel), Kim
>> Engineer
>> Mobile S/W Platform Lab. S/W centre
>> Telecommunication R&D Centre
>> Samsung Electronics CO., LTD.
>> e-mail : dongsoo.kim@gmail.com
>>           dongsoo45.kim@samsung.com
>> ========================================================
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-
>> omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



-- 
========================================================
DongSoo(Nathaniel), Kim
Engineer
Mobile S/W Platform Lab. S/W centre
Telecommunication R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
