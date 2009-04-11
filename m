Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:54953 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbZDKARc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2009 20:17:32 -0400
Date: Fri, 10 Apr 2009 19:30:10 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, g.liakhovetski@gmx.de,
	Mauro Carvalho Chehab <mchehab@infrade4ad.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	laurent.pinchart@skynet.be,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@ssamsung.com"@banach.math.auburn.edu,
	jongse.won@samsung.com, riverful.kim@samsung.com
Subject: Re: [RFC] White Balance control for digital camera
In-Reply-To: <5e9665e10904101344p1272dd5j4820bc36f9cedbf7@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.0904101824520.4699@banach.math.auburn.edu>
References: <5e9665e10904091450u3e70cda8w9e1d57e45365a32b@mail.gmail.com>  <alpine.LNX.2.00.0904101217260.4270@banach.math.auburn.edu> <5e9665e10904101344p1272dd5j4820bc36f9cedbf7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sat, 11 Apr 2009, Dongsoo, Nathaniel Kim wrote:

> On Sat, Apr 11, 2009 at 2:39 AM, Theodore Kilgore
> <kilgota@banach.math.auburn.edu> wrote:
>>
>>
>> On Fri, 10 Apr 2009, Dongsoo, Nathaniel Kim wrote:
>>
>>> Hello everyone,
>>>
>>> I'm posting this RFC one more time because it seems to everyone has
>>> been forgot this, and I'll be appreciated if any of you who is reading
>>> this mailing list give me comment.
>>
>> I don't know much about the topic, and I wish I did.
>>
>>> I've got a big question popping up handling white balance with
>>> V4L2_CID_WHITE_BALANCE_TEMPERATURE CID.
>>>
>>> Because in digital camera we generally control over user interface
>>> with pre-defined white balance name. I mean, user controls white
>>> balance with presets not with kelvin number.
>>> I'm very certain that TEMPERATURE CID is needed in many of video
>>> capture devices, but also 100% sure that white balance preset control
>>> is also necessary for digital cameras.
>>> How can we control white balance through preset name with existing V4L2
>>> API?
>>
>> Let's broaden the question to include digital still cameras, which present
>> similar problems. They present data related to this kind of thing, that is
>> obvious. But are there any standard meanings to what is there? Do you know
>> anything about that? Can you help?
>>
>
> Exactly right, but we need to see this on the top of the user space first.
> Because there could be several types of camera devices could be handled.
> I mean, the device that I'm intending to handle is based on I2C device
> and the "digital still camera" you issued is totally based on USB
> communication.
> That could be different in driver implementation point of view, but
> user in user space should be using in same manner.
> And I think I can help to coordinate how to handle them in user space
> with V4L2 API, but not so much with usb communication with digital
> still cameras.(but I really want to help indeed)
> Actually my expertise is totally based on mobile camera devices like
> camera phone. Even though they are "mobile" camera modules, they are
> very close to regular digital camera in performance and quality level
> now days.

Well, I would say of the top of my head that to do things the same way is 
a good idea, whenever possible. But that would appear to me, then, that 
libgphoto2 and things related to v4l would have to do these things, which 
would probably result in some code being incorporated in both places, in 
the end.

>
>> Two examples:
>>
>> The SQ905 and SQ905C cameras in stillcam mode use an allocation table, which
>> presents on each line some data about the given image. In this line, byte 0
>> is a one-byte code for pixel dimensions and compression setting. Then some
>> more bytes give the starting and ending locations of the photo in the
>> camera's memory (actually irrelevant and superfluous information, because
>> you can only ask for the photos in sequence, and with a command which has
>> nothing to do with its memory location at all). Then some more bytes
>> obviously have something to do with contrast, brightness, white balance,
>> color balance, and so on. But I have no more idea than the Man in the Moon
>> how those bytes are supposed to be interpreted. The SQ905 gives no such
>> equivalent information while in streaming mode, and so there is nothing at
>> all which could be done with the nonexistent information. But the SQ905C
>> does obviously give such information, in a few bytes in the header of each
>> frame.
>
> As far as I know, SQ905 (is that actually cheez camera?)

You know, I really do not know the answer to that. The relation between 
some of these outfits is very confusing. But what I *think* I know is

-- Standard & Quality Technology (S&Q, or SQ) <www.sq.com.tw> claims to 
make the chips, and then a lot of companies sell cameras with those chips.

-- CHE-eZ appears to me to be one of the companies which produces cameras, 
which appears to be an activity of, more or less, putting a plastic case 
and a decal or stencil logo on the outside of a plastic case containing 
the electronics which allegedly came from SQ. There are lots of companies 
that do that, as I said.

-- The usb.ids file seems to think that Vendor 0x2770 is some Japanese 
company called NHL. I think that the usb.ids file is probably not correct 
and the number belongs to SQ, which actually makes the chips and is not 
(for example) a mail drop for some other company. But how could I actually 
know? I don't.

What is the real story? Perhaps you can enlighten _me_.

.. ... is a regular
> digital camera not a mobile camera module, so in that case it could be
> handled in gspca and totally control through usb_control_msg.

Well the issue here with the supported SQ cameras is to be able to process 
better the data that came out of the camera. There is nothing which can be 
set up through usb_control_msg. These cameras do not have any control 
settings for changing what goes on inside the camera. The SQ905 cameras, 
as I said, do not even provide any data other than direct image data, whle 
streaming (though they do in stillcam mode). So one would not be able to 
do anything at all. The SQ905C cameras will pro

> And with my experience, I think I can help you if I have any kind of
> datasheet or user manual for that.

The user manuals, of course, just tell how to insert the Windows CD and 
install the drivers. The "datasheets" which were available at the SQ 
website (see above) were not much more than glorified sales brochures. 
They are not available now; I just checked. I do have copies from when 
they were available.

> But even if I don't have datasheet and don't know which message field
> means what I'm intending to do, I think it could be possible to make
> it compatible with the parameters I'm trying to make in v4l2 control.

Again, commands which can be sent to the camera are not even part of the 
discussion, from my point of view. My questions are about how to use 
information which the camera sends along with the data in order to improve 
the quality of the resulting images.

>
>>
>> The MR97310A cameras give similar information in the header of the photo
>> itself (and in this case the camera does the same thing in webcam mode,
>> too). Again, I have no idea either what these mysterious bytes are supposed
>> to mean, and how to use them constructively.
>>
>> I could mention several other examples, too, but these will do for a start.
>
> OK I've got what you mean. Can I have any information like user manual
> or datasheet for those SQ and MR devices?

As to the SQ devices, I do not think you will find anything interesting in 
the datasheets.

The MR cameras are apparently using some Pixart chipset (there is a 
company called Mars Technologies, but is it really just a brand name for 
Pixart? Again, who really knows?). I am not sure if I ever did find any 
datasheets from them; back when I was first confronted with an MR97310 
camera, it took me months even to find the company's website! There are 
too many companies called Mars Technologies.

> If we make a white balance preset api in v4l2, then we should have to
> implement that functionality in every single camera drivers in v4l2 if
> those devices are supporting for white balance presets.
>
> I want to make this clear that if we have white balance preset api in
> v4l2, then we can handle every camera device's white balance more user
> friendly.

Not if there are no such controls available for that camera.

> Thank you for your opinion by the way.
>
> Nate

It does seem that we were talking about two different branches of this 
topic. You are looking from the point of view of sending commands to the 
camera to alter what it is doing, with respect to white balance and such. 
I am well aware of the fact that some cameras will let one do that. 
However, my concerns were (and mostly are) about cameras which do not have 
such control options, but which do send you some few bytes of metadata 
which relate to white balance and other image properties. The question is 
then how to use that information constructively.

>
>>
>> Are there any agreed-upon standards about this kind of thing, in the camera
>> industry? Is there any source of information about it?

Perhaps someone can still answer this question ...

Theodore Kilgore
