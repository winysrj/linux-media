Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:40994 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbZBPBfL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 20:35:11 -0500
Date: Sun, 15 Feb 2009 19:46:58 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Trent Piepho <xyzzy@speakeasy.org>
cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>
Subject: Re: Adding a control for Sensor Orientation
In-Reply-To: <Pine.LNX.4.58.0902151506220.24268@shell2.speakeasy.net>
Message-ID: <alpine.LNX.2.00.0902151844340.1496@banach.math.auburn.edu>
References: <200902142048.51863.linux@baker-net.org.uk> <alpine.LNX.2.00.0902141624410.315@banach.math.auburn.edu> <4997DB74.6000108@redhat.com> <200902151019.35555.hverkuil@xs4all.nl> <4997E05F.9080509@redhat.com> <Pine.LNX.4.58.0902150445490.24268@shell2.speakeasy.net>
 <49981C9F.7000305@redhat.com> <Pine.LNX.4.58.0902151506220.24268@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 15 Feb 2009, Trent Piepho wrote:

> On Sun, 15 Feb 2009, Hans de Goede wrote:
>> Trent Piepho wrote:
>>> On Sun, 15 Feb 2009, Hans de Goede wrote:
>>>> Hans Verkuil wrote:
>>>>> On Sunday 15 February 2009 10:08:04 Hans de Goede wrote:
>>>>>> kilgota@banach.math.auburn.edu wrote:
>>>>>>> On Sat, 14 Feb 2009, Hans Verkuil wrote:
>>>>>>>> On Saturday 14 February 2009 22:55:39 Hans de Goede wrote:
>>>>>>>>> Adam Baker wrote:
>>>>>>>> OK, make it a buffer flag. I've got to agree that it makes more sense
>>>>>>>> to do
>>>>>>>> it that way.
>>>>>>>>
>>>>>>> The most particular problem is that some of the cameras require byte
>>>>>>> reversal of the frame data string, which would rotate the image 180
>>>>>>> degrees around its center. Others of these cameras require reversal of
>>>>>>> the horizontal lines in the image (vertical 180 degree rotation of the
>>>>>>> image across a horizontal axis).
>>>>>>>
>>>>>>> The point is, one can not tell from the Vendor:Product number which of
>>>>>>> these actions is required. However, one *is* able to tell immediately
>>>>>>> after the camera is initialized, which of these actions is required.
>>>>>>> Namely, one reads and parses the response to the first USB command sent
>>>>>>> to the camera.
>>>
>>>>>> Ack, but the problem later was extended by the fact that it turns out
>>>>>> some cams have a rotation detection (gravity direction) switch, which
>>>>>> means you can flip the cam on its socket while streaming, and then the
>>>>>> cam will tell you its rotation has changed, that makes this a per frame
>>>>>> property rather then a static property of the cam. Which lead to this
>>>>>> discussion, but we (the 2 Hans 's) agree now that using the flags field
>>>>>> in the buffer struct is the best way forward. So there is a standard now,
>>>>>> simply add 2 buffer flags to videodev2.h, one for content is h-flipped
>>>>>> and one for content is v-flipped and you are done.
>>>>> I think we should also be able to detect 90 and 270 degree rotations. Or at
>>>>> the very least prepare for it. It's a safe bet to assume that webcams will
>>>>> arrive that can detect portrait vs landscape orientation.
>>>> Handling those (esp on the fly) will be rather hard as width and height then
>>>> get swapped. So lets worry about those when we need to. We will need an
>>>> additional flag for those cases anyways.
>>>
>>> Why would you need to worry about width and height getting swapped?
>>> Meta-data about the frame would indicate it's now in portrait mode vs
>>> landscape mode, but the dimentions would be unchanged.
>>
>> Yes, unless ofcourse you want to display a proper picture and not one on its
>> side, when the camera is rotated 90 degrees, so somewere you need to rotate the
>> picture 90 degrees, and the lower down in the stack you do that, the bigger the
>> chance you do not need to duplicate the rotation code in every single app.
>> however the app will mostlikely become unhappy when you start out pushing
>> frames whith a changed width / height.
>
> It seems that image rotation, like format conversion, is something that is
> best done in userspace.  It could be done in hardware with opengl or faster
> software using MMX or SSE based code that can't be used in the kernel.
>

My impression is that nobody here disagrees with this. Certainly, I do 
not. As I understand, there is a general intention to avoid writing new 
modules which do such things and to try to rewrite old ones. The reasons 
are, presumably, very similar to the reasons you give.

Therefore,

1. Everyone seems to agree that the kernel module itself is not going to 
do things like rotate or flip data even if a given supported device 
always needs that done.

However, this decision has a consequence:

2. Therefore, the module must send the information about what is needed 
out of the module, to whatever place is going to deal with it. Information 
which is known to the module but unknown anywere else must be transmitted 
somehow.

Now there is a further consequence:

3. In view of (1) and (2) there has to be a way agreed upon for the module 
to pass the relevant information onward.

It is precisely on item 3 that we are stuck right now. There is an 
immediate need, not a theoretical need but an immediate need. However, 
there is no agreed-upon method or convention for communication.

Some might argue that it is sufficient to know some ID of the device (USB 
Vendor:Product number, for example), but it is not:

4. The idea of relying on the USB ID of the supported device to decide 
what should be done with the frame data is inadequate. Sometimes, 
preliminary communication with the device is the only possible way to 
learn what is needed. Again, this is not a theoretical problem. It is an 
actual problem. A known device exists. Go back to item (3).


There are of course related problems. But it strikes me that the related 
problems are not so very related at all. As I understand, it is visualized 
that a camera could be put on a pivot, with control mechanism which would 
permit various rotations and then the question becomes how to support a 
camera and to make the stream come out "right" no matter which way the 
camera is pointed. A far-seeing project design will certainly think of 
things like that before they happen and will try to anticipate what to do.

Why do I say then that these problems are not related at all to the 
present problem? Because we are dealing with cameras that always present 
the data upside-down or mirrored, unless corrective action is taken. 
So, again, either the module has to do the correction inside itself (and 
everyone agrees that it should not!) or it has to have a standard protocol 
to pass that information onward. to be dealt with appropriately. It would 
seem to me best to separate a problem like this from discussions about 
tilting or physically rotating the camera.

Theodore Kilgore
