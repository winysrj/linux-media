Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:44209 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbZDUNEN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 09:04:13 -0400
MIME-Version: 1.0
In-Reply-To: <19F8576C6E063C45BE387C64729E739404280C5F44@dbde02.ent.ti.com>
References: <19F8576C6E063C45BE387C64729E73940427E3F70B@dbde02.ent.ti.com>
	 <200903301902.21783.hverkuil@xs4all.nl>
	 <19F8576C6E063C45BE387C64729E73940427E3F8F1@dbde02.ent.ti.com>
	 <200904181753.47515.hverkuil@xs4all.nl>
	 <793DE56C-45AE-48ED-B26D-A1A4BECC5F87@gmail.com>
	 <19F8576C6E063C45BE387C64729E739404280C5B46@dbde02.ent.ti.com>
	 <5e9665e10904200345x7272a24fs6a3e8c72af2e3fe@mail.gmail.com>
	 <19F8576C6E063C45BE387C64729E739404280C5EAF@dbde02.ent.ti.com>
	 <5e9665e10904210313j5d141903o7652a4d5a107066c@mail.gmail.com>
	 <19F8576C6E063C45BE387C64729E739404280C5F44@dbde02.ent.ti.com>
Date: Tue, 21 Apr 2009 22:04:12 +0900
Message-ID: <5e9665e10904210604u6d206a85h78e7bc3363b28b89@mail.gmail.com>
Subject: Re: [RFC] Stand-alone Resizer/Previewer Driver support under V4L2
	framework
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"R, Sivaraj" <sivaraj@ti.com>, "Hadli, Manjunath" <mrh@ti.com>,
	"Shah, Hardik" <hardik.shah@ti.com>,
	"Kumar, Purushotam" <purushotam@ti.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Vaibhav,


On Tue, Apr 21, 2009 at 9:08 PM, Hiremath, Vaibhav <hvaibhav@ti.com> wrote:
>> -----Original Message-----
>> From: Dongsoo, Nathaniel Kim [mailto:dongsoo.kim@gmail.com]
>> Sent: Tuesday, April 21, 2009 3:44 PM
>> To: Hiremath, Vaibhav
>> Cc: Hans Verkuil; linux-media@vger.kernel.org; Aguirre Rodriguez,
>> Sergio Alberto; Toivonen Tuukka.O (Nokia-D/Oulu); linux-
>> omap@vger.kernel.org; Nagalla, Hari; Sakari Ailus; Jadav, Brijesh R;
>> R, Sivaraj; Hadli, Manjunath; Shah, Hardik; Kumar, Purushotam
>> Subject: Re: [RFC] Stand-alone Resizer/Previewer Driver support
>> under V4L2 framework
>>
>> Hello, Vaibhav,
>>
>>
>> On Tue, Apr 21, 2009 at 7:01 PM, Hiremath, Vaibhav <hvaibhav@ti.com>
>> wrote:
>> >
>> >> -----Original Message-----
>> >> From: Hiremath, Vaibhav
>> >> Sent: Tuesday, April 21, 2009 3:16 PM
>> >> To: 'Dongsoo, Nathaniel Kim'
>> >> Cc: Hans Verkuil; linux-media@vger.kernel.org; Aguirre Rodriguez,
>> >> Sergio Alberto; Toivonen Tuukka.O (Nokia-D/Oulu); linux-
>> >> omap@vger.kernel.org; Nagalla, Hari; Sakari Ailus; Jadav, Brijesh
>> R;
>> >> R, Sivaraj; Hadli, Manjunath; Shah, Hardik; Kumar, Purushotam
>> >> Subject: RE: [RFC] Stand-alone Resizer/Previewer Driver support
>> >> under V4L2 framework
>> >>
>> >> > -----Original Message-----
>> >> > From: Dongsoo, Nathaniel Kim [mailto:dongsoo.kim@gmail.com]
>> >> > Sent: Monday, April 20, 2009 4:15 PM
>> >> > To: Hiremath, Vaibhav
>> >> > Cc: Hans Verkuil; linux-media@vger.kernel.org; Aguirre
>> Rodriguez,
>> >> > Sergio Alberto; Toivonen Tuukka.O (Nokia-D/Oulu); linux-
>> >> > omap@vger.kernel.org; Nagalla, Hari; Sakari Ailus; Jadav,
>> Brijesh
>> >> R;
>> >> > R, Sivaraj; Hadli, Manjunath; Shah, Hardik; Kumar, Purushotam
>> >> > Subject: Re: [RFC] Stand-alone Resizer/Previewer Driver support
>> >> > under V4L2 framework
>> >> >
>> >> > Hello Vaibhav,
>> >> >
>> >> > This is user manual of S3C6400 (not much different from
>> S3C6410)
>> >> >
>> >>
>> http://www.ebv.com/fileadmin/products/Products/Samsung/S3C6400/S3C64
>> >> > 00X_UserManual_rev1-0_2008-02_661558um.pdf
>> >> >
>> >> > That SoC is from my company but not from the same division of
>> >> mine.
>> >> > Actually I'm doing this driver job without any request from
>> chip
>> >> > delivering division. I'm doing this because this is so
>> challenging
>> >> > and
>> >> > want better generic driver :-)
>> >> >
>> >> > Take a look at the user manual and please let me know your
>> >> opinion.
>> >> > In my understanding scaler and some camera interface feature in
>> >> > S3C64XX are very similar to the features in Omap3.
>> >> >
>> >> [Hiremath, Vaibhav] Hi Kim,
>> >>
>> >> I went through the document and below are some observations and
>> >> questions I have -
>> >>
>> >>       - If I compare it with OMAP then there is nothing
>> application
>> >> needs to configure specific to hardware. All the parameters
>> >> supported through "v4l2_format" one with TYPE_VIDEO_OUTPUT and
>> >> another with TYPE_VIDEO_CAPTURE except the parameter "offset" (If
>> >> driver is supporting it)
>> >>
>>
>> I'm not sure whether I'm following your question, but S3C64XX camera
>> interface is obviously simpler than OMAP. So there is no wonder that
>> user doesn't need to configure H/W specific things. And I don't get
>> the question about "offset" parameter. Can you explain me more
>> specifically?
>>
> [Hiremath, Vaibhav] Please refer to the section 16.5.1 (Page no 532 (16-11)) 16.7.11 and 16.7.16.
>
> You can specify offset from the input image to start, so that you can have part of image for scaling.

Oh! sorry I made you get confused.
What I'm working on is not the TV scaler of S3C64XX but scaler and
rotator in camera interface.
Please take a look at "20-1 camera interface"
This scaler/rotator feature can be used in general purpose.


>
>>
>> >>       - I wanted to understand how are you configuring offset
>> >> register? How are you exporting it to user application?
>> >>
>>
>> Again, I don't get the point. Sorry.
>>
>> >> Rest everything we can handle in driver once input source and
>> output
>> >> destination format receives from application.
>> >>
>> > [Hiremath, Vaibhav] Missed one point in last draft, about buffer
>> handling. How are you handling buffers? Are you supporting both
>> USER_POINTER and MMAP buffers?
>> > What is the size of buffers, is that different for input and
>> output?
>> > If yes, then how are you managing it?
>> >
>> > If no, don't you see requirement for it?
>>
>> Sorry, my driver work is not that stage yet. It's just still in
>> designing level, because of some special H/W features (like MSDMA,
>> scaler and so) I'm totally stuck and can't go further.
>> But your buffer theory seems to make sense and I suppose that is
>> necessary if we have that kind of device.
>>
> [Hiremath, Vaibhav] I am talking to Mauro, and will keep you updated on this.
>

Thank you. I appreciate it.

Nate

> Thanks,
> Vaibhav Hiremath
>
>> >
>> > Thanks,
>> > Vaibhav
>> >
>> >> From OMAP Point of view -
>> >> -----------------------
>> >>
>> >> The extra configuration is coefficients, which if we don't export
>> to
>> >> user application then I think we are very close to your IP.
>> >>
>> >> Extra configuration required other than coeff.
>> >>
>> >> RSZ_YENH - which takes 4 params
>> >>
>> >>       - Algo
>> >>       - Gain
>> >>       - Slope
>> >>       - Core
>> >>
>> >> All are part of one register so we can make use of "priv" field
>> for
>> >> this configuration.
>> >>
>>
>> I get it. But S3C64XX is not that much configurable. As you see in
>> user manual, it's a quite simple device.
>> For now I'm still designing my driver, so I'll let you know if I
>> face
>> those issues in my driver.
>> Cheers,
>>
>> Nate
>>
>> >>
>> >> Thanks,
>> >> Vaibhav Hiremath
>> >>
>> >> > Cheers,
>> >> >
>> >> > Nate
>> >> >
>> >> > On Mon, Apr 20, 2009 at 7:11 PM, Hiremath, Vaibhav
>> >> <hvaibhav@ti.com>
>> >> > wrote:
>> >> > >
>> >> > >
>> >> > > Thanks,
>> >> > > Vaibhav Hiremath
>> >> > >
>> >> > >> -----Original Message-----
>> >> > >> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> >> > >> owner@vger.kernel.org] On Behalf Of Dongsoo Kim
>> >> > >> Sent: Sunday, April 19, 2009 12:06 PM
>> >> > >> To: Hans Verkuil
>> >> > >> Cc: Hiremath, Vaibhav; linux-media@vger.kernel.org; Aguirre
>> >> > >> Rodriguez, Sergio Alberto; Toivonen Tuukka.O (Nokia-D/Oulu);
>> >> > linux-
>> >> > >> omap@vger.kernel.org; Nagalla, Hari; Sakari Ailus; Jadav,
>> >> Brijesh
>> >> > R;
>> >> > >> R, Sivaraj; Hadli, Manjunath; Shah, Hardik; Kumar,
>> Purushotam
>> >> > >> Subject: Re: [RFC] Stand-alone Resizer/Previewer Driver
>> support
>> >> > >> under V4L2 framework
>> >> > >>
>> >> > >> Hello Hans and Hiremath,
>> >> > >>
>> >> > >> One of my recent job is making S3C64XX camera interface
>> driver
>> >> > (even
>> >> > >> though other jobs of mine are not finished yet...;-()
>> >> > >> And, what a incident! S3C64XX has also similar H/W block in
>> >> > camera
>> >> > >> interface.
>> >> > >> Resizer in S3C camera interface can be used in system wide
>> like
>> >> > the
>> >> > >> one in Omap3.
>> >> > >>
>> >> > > [Hiremath, Vaibhav] Can you share the spec for the same; I
>> >> wanted
>> >> > to verify the configuration part of it? What all configuration
>> is
>> >> > exported to the user?
>> >> > >
>> >> > >> But in case of mine, I decided to make it as a
>> >> TYPE_VIDEO_CAPTURE
>> >> > >> and
>> >> > >> TYPE_VIDEO_OUTPUT.
>> >> > >> I thought that is was enough. Actually I took omap video out
>> >> > (vout?)
>> >> > >> for reference :-)
>> >> > >
>> >> > > [Hiremath, Vaibhav] I have also implemented the driver is the
>> >> same
>> >> > way and also working with Hans to get it reviewed. But there
>> are
>> >> > some configuration like coeff., luma enhancement, etc... need
>> to
>> >> > export to the user, where we need to add mechanism in V4L2
>> >> > framework.
>> >> > >
>> >> > > Since we have one more device where we are demanding for M-
>> to-M
>> >> > operation, I think it is important to go through it. Can you
>> share
>> >> > some documents of your IP for better understanding.
>> >> > >
>> >> > >
>> >> > >> Cheers,
>> >> > >>
>> >> > >> Nate
>> >> > >>
>> >> > >>
>> >> > >> 2009. 04. 19, ���� 12:53, Hans Verkuil �ۼ�:
>> >> > >>
>> >> > >> > On Tuesday 31 March 2009 10:53:02 Hiremath, Vaibhav wrote:
>> >> > >> >> Thanks,
>> >> > >> >> Vaibhav Hiremath
>> >> > >> >>
>> >> > >> >>>> APPROACH 3 -
>> >> > >> >>>> ----------
>> >> > >> >>>>
>> >> > >> >>>> .....
>> >> > >> >>>>
>> >> > >> >>>> (Any other approach which I could not think of would be
>> >> > >> >>>
>> >> > >> >>> appreciated)
>> >> > >> >>>
>> >> > >> >>>> I would prefer second approach, since this will provide
>> >> > >> standard
>> >> > >> >>>> interface to applications independent on underneath
>> >> > hardware.
>> >> > >> >>>>
>> >> > >> >>>> There may be many number of such configuration
>> parameters
>> >> > >> required
>> >> > >> >>>
>> >> > >> >>> for
>> >> > >> >>>
>> >> > >> >>>> different such devices, we need to work on this and
>> come
>> >> up
>> >> > >> with
>> >> > >> >>>
>> >> > >> >>> some
>> >> > >> >>>
>> >> > >> >>>> standard capability fields covering most of available
>> >> > devices.
>> >> > >> >>>>
>> >> > >> >>>> Does anybody have some other opinions on this?
>> >> > >> >>>> Any suggestions will be helpful here,
>> >> > >> >>>
>> >> > >> >>> FYI: I have very little time to look at this for the
>> next
>> >> 2-3
>> >> > >> weeks.
>> >> > >> >>> As you
>> >> > >> >>> know I'm working on the last pieces of the v4l2_subdev
>> >> > >> conversion
>> >> > >> >>> for 2.6.30
>> >> > >> >>> that should be finished this week. After that I'm
>> attending
>> >> > the
>> >> > >> >>> Embedded
>> >> > >> >>> Linux Conference in San Francisco.
>> >> > >> >>>
>> >> > >> >>> But I always thought that something like this would be
>> just
>> >> a
>> >> > >> >>> regular video
>> >> > >> >>> device that can do both 'output' and 'capture'. For a
>> >> resizer
>> >> > I
>> >> > >> >>> would
>> >> > >> >>> expect that you set the 'output' size (the size of your
>> >> > source
>> >> > >> >>> image) and
>> >> > >> >>> the 'capture' size (the size of the resized image), then
>> >> just
>> >> > >> send
>> >> > >> >>> the
>> >> > >> >>> frames to the device (== resizer) and get them back on
>> the
>> >> > >> capture
>> >> > >> >>> side.
>> >> > >> >>
>> >> > >> >> [Hiremath, Vaibhav] Yes, it is possible to do that.
>> >> > >> >>
>> >> > >> >> Hans,
>> >> > >> >>
>> >> > >> >> I went through the link referred by Sergio and I think we
>> >> > should
>> >> > >> >> inherit
>> >> > >> >> some implementation for CODECs here for such devices.
>> >> > >> >>
>> >> > >> >> V4L2_BUF_TYPE_CODECIN - To access the input format.
>> >> > >> >> V4L2_BUF_TYPE_CODECOUT - To access the output format.
>> >> > >> >>
>> >> > >> >> It makes sense, since such memory-to-memory devices will
>> >> > mostly
>> >> > >> being
>> >> > >> >> used from codecs context. And this would be more clear
>> from
>> >> > user
>> >> > >> >> application.
>> >> > >> >
>> >> > >> > To be honest, I don't see the need for this. I think
>> >> > >> > TYPE_VIDEO_CAPTURE and
>> >> > >> > TYPE_VIDEO_OUTPUT are perfectly fine.
>> >> > >> >
>> >> > >> >> And as acknowledged by you, we can use VIDIOC_S_FMT for
>> >> > setting
>> >> > >> >> parameters.
>> >> > >> >>
>> >> > >> >> One thing I am not able to convince myself is that, using
>> >> > "priv"
>> >> > >> >> field
>> >> > >> >> for custom configuration.
>> >> > >> >
>> >> > >> > I agree. Especially since you cannot use it as a pointer
>> to
>> >> > >> addition
>> >> > >> > information.
>> >> > >> >
>> >> > >> >> I would prefer and recommend capability based
>> >> > >> >> interface, where application will query the capability of
>> >> the
>> >> > >> >> device for
>> >> > >> >> luma enhancement, filter coefficients (number of coeff
>> and
>> >> > >> depth),
>> >> > >> >> interpolation type, etc...
>> >> > >> >>
>> >> > >> >> This way we can make sure that, any such future devices
>> can
>> >> be
>> >> > >> >> adapted by
>> >> > >> >> this framework.
>> >> > >> >
>> >> > >> > The big question is how many of these capabilities are
>> >> > 'generic'
>> >> > >> and
>> >> > >> > how
>> >> > >> > many are very much hardware specific. I am leaning towards
>> >> > using
>> >> > >> the
>> >> > >> > extended control API for this. It's a bit awkward to
>> >> implement
>> >> > in
>> >> > >> > drivers
>> >> > >> > at the moment, but that should improve in the future when
>> a
>> >> lot
>> >> > of
>> >> > >> the
>> >> > >> > control handling code will move into the new core
>> framework.
>> >> > >> >
>> >> > >> > I really need to know more about the sort of features that
>> >> > omap/
>> >> > >> > davinci
>> >> > >> > offer (and preferably also for similar devices by other
>> >> > >> > manufacturers).
>> >> > >> >
>> >> > >> >>
>> >> > >> >>
>> >> > >> >> Hans,
>> >> > >> >> Have you get a chance to look at Video-Buf layer issues I
>> >> > >> mentioned
>> >> > >> >> in
>> >> > >> >> original draft?
>> >> > >> >
>> >> > >> > I've asked Magnus Damm to take a look at this. I know he
>> did
>> >> > some
>> >> > >> > work in
>> >> > >> > this area and he may have fixed some of these issues
>> already.
>> >> > Very
>> >> > >> > useful,
>> >> > >> > that Embedded Linux conference...
>> >> > >> >
>> >> > >> > Regards,
>> >> > >> >
>> >> > >> >     Hans
>> >> > >> >
>> >> > >> > --
>> >> > >> > Hans Verkuil - video4linux developer - sponsored by
>> TANDBERG
>> >> > >>
>> >> > >> =
>> >> > >> DongSoo, Nathaniel Kim
>> >> > >> Engineer
>> >> > >> Mobile S/W Platform Lab.
>> >> > >> Digital Media & Communications R&D Centre
>> >> > >> Samsung Electronics CO., LTD.
>> >> > >> e-mail : dongsoo.kim@gmail.com
>> >> > >>            dongsoo45.kim@samsung.com
>> >> > >>
>> >> > >>
>> >> > >>
>> >> > >> --
>> >> > >> To unsubscribe from this list: send the line "unsubscribe
>> >> linux-
>> >> > >> media" in
>> >> > >> the body of a message to majordomo@vger.kernel.org
>> >> > >> More majordomo info at  http://vger.kernel.org/majordomo-
>> >> > info.html
>> >> > >
>> >> > >
>> >> >
>> >> >
>> >> >
>> >> > --
>> >> > ========================================================
>> >> > DongSoo, Nathaniel Kim
>> >> > Engineer
>> >> > Mobile S/W Platform Lab.
>> >> > Digital Media & Communications R&D Centre
>> >> > Samsung Electronics CO., LTD.
>> >> > e-mail : dongsoo.kim@gmail.com
>> >> >           dongsoo45.kim@samsung.com
>> >> > ========================================================
>> >
>> >
>>
>>
>>
>> --
>> =
>> DongSoo, Nathaniel Kim
>> Engineer
>> Mobile S/W Platform Lab.
>> Digital Media & Communications R&D Centre
>> Samsung Electronics CO., LTD.
>> e-mail : dongsoo.kim@gmail.com
>>           dongsoo45.kim@samsung.com
>
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
