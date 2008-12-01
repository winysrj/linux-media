Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1HUoFP001116
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 12:30:50 -0500
Received: from QMTA10.emeryville.ca.mail.comcast.net
	(qmta10.emeryville.ca.mail.comcast.net [76.96.30.17])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1HUfwP025770
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 12:30:41 -0500
Message-ID: <49341F38.4040107@personnelware.com>
Date: Mon, 01 Dec 2008 11:30:32 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, video4linux-list@redhat.com
References: <491CB0A6.9080509@personnelware.com>	<200811302207.24073.hverkuil@xs4all.nl>	<49334CA0.4070100@personnelware.com>
	<200812011429.44616.hverkuil@xs4all.nl>
In-Reply-To: <200812011429.44616.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: minimum v4l2 api - framework
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hans Verkuil wrote:
> On Monday 01 December 2008 03:32:00 Carl Karsten wrote:
>> Hans Verkuil wrote:
>>> On Sunday 30 November 2008 20:16:07 Carl Karsten wrote:
>>>> Hans Verkuil wrote:
>>>>> On Sunday 30 November 2008 18:49:45 Carl Karsten wrote:
>>>>>> Hans Verkuil wrote:
>>>>>>> On Tuesday 25 November 2008 03:24:07 Carl Karsten wrote:
>>>>>>>> Hans Verkuil wrote:
>>>>>>>>> On Saturday 15 November 2008 21:59:44 Carl Karsten wrote:
>>>>>>>>>> Tomorrow (Nov 16) I will be at a Linuxfest, where I am going
>>>>>>>>>> to try to find someone up for writing this driver.
>>>>>>>>>>
>>>>>>>>>> I am assuming there is some code they should use as a
>>>>>>>>>> starting point. Either
>>>>>>>>>> A) "This is the generic/abstract code that can be extended
>>>>>>>>>> to make a specific/concrete driver" (what I would call a
>>>>>>>>>> framework) B) "driver foo.c is a good example of how a V4L2
>>>>>>>>>> driver should be written; copy it and swap out the hardware
>>>>>>>>>> specific code." C) "vivi.c is close enough.  you should
>>>>>>>>>> really just work on fixing it."
>>>>>>>>>>
>>>>>>>>>> I am hoping the correct answer is:
>>>>>>>>>> http://linuxtv.org/hg/~hverkuil/v4l-dvb-media2/file/6292505c
>>>>>>>>>> a6 17 /l inu x/Documentation/video4linux/v4l2-framework.txt
>>>>>>>>> Hopefully this will be the correct answer in the near future,
>>>>>>>>> but now it refers to structs that do not yet exist. I've
>>>>>>>>> reserved next weekend to continue work on this.
>>>>>>>>>
>>>>>>>>> It's probably a good idea for me to create a template driver
>>>>>>>>> that can be used as a proper starting point, however nothing
>>>>>>>>> will be available soon enough for you. I don't think we have
>>>>>>>>> a 'perfect' driver right now. All drivers have their own
>>>>>>>>> problems. It's one of the main reasons I'm working on a
>>>>>>>>> better framework.
>>>>>>>> Any progress?
>>>>>>>>
>>>>>>>> Carl K
>>>>>>> Erm, no. At least not on an example driver. As you may have
>>>>>>> noticed I'm working hard to get the new v4l2_device and
>>>>>>> v4l2_subdev structs merged.
>>>>>> personal disappointment is very offset by appreciation of what
>>>>>> you are doing for the world, so no hard feelings :)
>>>>> Phew, that's a relieve :-)
>>>>>
>>>>>>> I also think it is much harder to make an example driver than I
>>>>>>> expected. In many ways the cx18 driver is actually not a bad
>>>>>>> choice, except for the fact that it doesn't use video-buf when
>>>>>>> it really should do that. It also very much depends on the type
>>>>>>> of driver: a PCI driver is quite different from an USB driver,
>>>>>>> and a webcam driver is again quite different from a TV capture
>>>>>>> driver. There is such a wide variety of hardware that we
>>>>>>> support that there isn't really such a thing as a perfect
>>>>>>> example driver.
>>>>>> gspca is v4l v1 (right?)
>>>>> No, it's v2. It might perhaps still support v1, I'm not sure.
>>>> oh wow, I thought that was still a ways off.  well then...
>>>>
>>>>>> perhaps something like that would be a good
>>>>>> place for me to look for creating a driver that doesn't rely on
>>>>>> hardware?   Are there any v4l2 codebases that are not tied to
>>>>>> one piece of hardware?
>>>>> Only vivi is software only. All other drivers are always tied to
>>>>> specific hardware.
>>>> er, I meant code that is used across many different pices of
>>>> hardware (as opposed to just one.)   The thought is that would be
>>>> a) a good start for creating another test driver like vivi, and b)
>>>> would benefit that code base by having some automated regression
>>>> tests. Testing the test driver would test some code,  but would
>>>> mainly be useful for testing the tester.  the substantial benefit
>>>> would come from being able to test the drivers on real hardware.
>>> Hmm, the driver that probably has the most accurate v4l2 support is
>>> ivtv (although I might be biased, being the maintainer of that
>>> driver). The cx18 driver is derived from ivtv and is probably a bit
>>> easier to understand. The main problem with ivtv and cx18 is that
>>> they don't use video-buf. So to test streaming video you would
>>> probably want to look at cx88 or bt8xx. For USB capture devices I
>>> think the em28xx driver is a decent driver and for webcams I would
>>> look at uvc.
>>>
>>> The sad fact is that in many cases drivers reinvented the wheel due
>>> to the lack of a proper V4L2 framework, or copied the same broken
>>> code. E.g. drivers like saa7134 and cx88 both share the same defect
>>> where if you call VIDIOC_S_FMT that format is lost as soon as you
>>> close the filehandle. That's completely against the V4L2 spec which
>>> says that it is kept after closing the video device. This same bug
>>> is in a series of drivers, all copied from some original driver.
>>>
>>> So if you are looking for hardware to test with, then I would
>>> suggest that you try to get a second-hand Hauppauge PVR-350. This
>>> allows you to test MPEG encoding, decoding, VBI (both raw and
>>> sliced), MPEG indexing, raw video encoding and decoding.
>>>
>>> To test streaming IO get a card supported by the saa7134, cx88 or
>>> bt8xx drivers. For webcam support look at a UVC webcam (a webcam
>>> supported by the gspca driver is probably also OK for your
>>> purposes).
>> my ultimate goal is to help with the development (I would just test)
>> a closed source v4l driver that digitizes svga (or whatever you call
>> what video cards put out over 15 pin monitor connector, with res up
>> to 2384x3370) and exposes it as a v4l stream.  more on that project
>> here: http://chipy.org/V4l2forPyCon
>>
>> The driver developer has said he would be doing a v4l2 one soon, and
>> I would like to help test it.  This would be done best if I had a
>> good generic test app, but that has been troublesome given the state
>> of v4l(2) drivers.
>>
>> I could focus my work on making tests that only apply to the vga2usb
>> device, but the usefulness would be limited to that device, so very
>> limited, so I would pretty much be alone.  I would rather put the
>> effort into something universally useful to all v4l driver
>> developers, and thus will get a bit more help.
>>
>> I have the hardware I need (i think).  it's the automated tests I am
>> struggling with because there isn't a solid starting point.  
>> although perhaps getting some hardware that digitized composite and
>> has a solid driver could be used by feeding a test pattern signal. 
>> the reason i am opposed to that is because the only people that will
>> be able to help are people who have that card, or maybe when the
>> tests become reliable and others start using it as part of their
>> development.  my fear is that alone I won't be able to get it to that
>> point.
>>
>> So given all this, what would you suggest?
>>
>> (and if you already understood all this and your suggestions still
>> stands, forgive me for making sure.)
>>
>> Carl K
> 
> Hi Carl,

moving this back to the list - seems appropriate

> 
> I think that you should look at two different test apps here. One 
> utility would validate the V4L2 API as implemented by a driver as much 
> as possible. I made a starting point at one time with the 
> v4l2-compliance utility (in v4l2-apps/utils in the v4l-dvb repository), 
> but that's really, really small at the moment. I never had time to 
> expand on it.
> 
> The basic idea is that this utility queries the capabilities and based 
> on that tries to exercise all the ioctls and verifies that what the 
> driver returns has all the fields filled in, uses the right return 
> codes/error and that you can set formats, controls, etc. according to 
> the returned capabilities.
> 
> It could also do some short captures, but just to test if it works.
> 
> A second test app should be available to do long-term captures and look 
> at timestamps and things like that.

This is exactly what I was planning on.

> 
> I can definitely think of numerous test cases for you to implement. 
> There simply is no proper testing application available right now.

I would ask you to add them to the a wiki page about it, but it appears to be
missing:
http://linuxtv.org/v4lwiki/index.php/Test_Suite

> 
> What I don't quite follow is what this has to do with your questions 
> about a good example driver. 

As a baseline for what the test app would do when used against a proper driver.

I need a driver like what I hoped vivi was: can be run by anyone (it can) and
properly implements v4l2 api (questionable.  it currently hangs my kernel, so
that seems like a problem.)

A test driver would
1) help me make sure the test app works correctly.  as the test app is modified,
the automated test run would first use the test driver to make sure  the app is
not giving false reports.

2) when the close source driver fails the test app, the developer may want to
see an example of what code should look like that doesn't fail.

3) help test v4l apps, like transcode's v4l2_import module.

4) help me develop http://code.google.com/p/python-video4linux2/


> Is that to help the developer that makes
> this new V4L2 driver? 

That is one of my goals.

I also think the v4l community needs such a thing.  Otherwise I would not be
bothering the community :)

> (And why is it closed source anyway? 

to be clear: my relation to this product is a user.  my interest in helping the
development is because I want it to work for me.  Now to answer your question:

I think it is the same reason nvidia video drivers are.  In this case I think it
is to protect the compression algorithm that moves video data over usb2.

> Note that
> video-buf is all EXPORT_SYMBOL_GPL so in order to use that the driver 
> has to be GPL as well).

I am not working with the closed source code.  I am just trying to use it, and
submit bug reports when it isn't working.  Right now I am never sure if the bug
is in the closed source driver or the app.  having both a reliable test driver
and app would help this process.

> 
> All you need to make a good test suite is the V4L2 spec. That's a pretty 
> good document and (almost) always leading.

and be a proficient kernel hacker.  which I am not.  but I have friends that are
willing to help if I can give them a reasonable goal.

And I hope to create some sort of liveCD (bootable thumb drive really) that
would test v4l2 drivers: boot, hardware is identified, modules loaded, tests
run, results displayed with an option to send them back to a central database.

Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
