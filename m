Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:45148 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbZDJXnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2009 19:43:10 -0400
Received: by wf-out-1314.google.com with SMTP id 29so1262462wff.4
        for <linux-media@vger.kernel.org>; Fri, 10 Apr 2009 16:43:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5e9665e10904101344p1272dd5j4820bc36f9cedbf7@mail.gmail.com>
References: <5e9665e10904091450u3e70cda8w9e1d57e45365a32b@mail.gmail.com>
	 <alpine.LNX.2.00.0904101217260.4270@banach.math.auburn.edu>
	 <5e9665e10904101344p1272dd5j4820bc36f9cedbf7@mail.gmail.com>
Date: Sat, 11 Apr 2009 08:43:10 +0900
Message-ID: <5e9665e10904101643g139dcaeay874f5cf5afacafc2@mail.gmail.com>
Subject: Re: [RFC] White Balance control for digital camera
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, g.liakhovetski@gmx.de,
	Mauro Carvalho Chehab <mchehab@infrade4ad.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	laurent.pinchart@skynet.be,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	jongse.won@samsung.com, riverful.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello again,

I forgot to give you reference about the range of color temperature to
handle white balance as preset.

Here is the wikipedia reference, I wish I could find better one but by
now it seems to be no problem.
http://en.wikipedia.org/wiki/Color_temperature#Categorizing_different_lighting
Cheers,

Nate

On Sat, Apr 11, 2009 at 5:44 AM, Dongsoo, Nathaniel Kim
<dongsoo.kim@gmail.com> wrote:
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
> As far as I know, SQ905 (is that actually cheez camera?) is a regular
> digital camera not a mobile camera module, so in that case it could be
> handled in gspca and totally control through usb_control_msg.
> And with my experience, I think I can help you if I have any kind of
> datasheet or user manual for that.
> But even if I don't have datasheet and don't know which message field
> means what I'm intending to do, I think it could be possible to make
> it compatible with the parameters I'm trying to make in v4l2 control.
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
> If we make a white balance preset api in v4l2, then we should have to
> implement that functionality in every single camera drivers in v4l2 if
> those devices are supporting for white balance presets.
>
> I want to make this clear that if we have white balance preset api in
> v4l2, then we can handle every camera device's white balance more user
> friendly.
>
> Thank you for your opinion by the way.
>
> Nate
>
>>
>> Are there any agreed-upon standards about this kind of thing, in the camera
>> industry? Is there any source of information about it?
>>
>> Theodore Kilgore
>>
>
>
>
> --
> ========================================================
> DongSoo, Nathaniel Kim
> Engineer
> Mobile S/W Platform Lab.
> Digital Media & Communications R&D Centre
> Samsung Electronics CO., LTD.
> e-mail : dongsoo.kim@gmail.com
>          dongsoo45.kim@samsung.com
> ========================================================
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
