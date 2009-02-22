Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57112 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbZBVX3F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 18:29:05 -0500
Message-ID: <49A1DF50.1080903@redhat.com>
Date: Mon, 23 Feb 2009 00:27:12 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: kilgota@banach.math.auburn.edu, Hans Verkuil <hverkuil@xs4all.nl>,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
References: <200902180030.52729.linux@baker-net.org.uk> <200902211253.58061.hverkuil@xs4all.nl> <49A13466.5080605@redhat.com> <alpine.LNX.2.00.0902221225310.10870@banach.math.auburn.edu> <49A1A03A.8080303@redhat.com> <alpine.LNX.2.00.0902221334310.10870@banach.math.auburn.edu> <49A1CA5B.5000407@redhat.com> <Pine.LNX.4.58.0902221419550.24268@shell2.speakeasy.net> <49A1D7B2.5070601@redhat.com> <Pine.LNX.4.58.0902221504410.24268@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0902221504410.24268@shell2.speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Trent Piepho wrote:
> On Sun, 22 Feb 2009, Hans de Goede wrote:
>> Trent Piepho wrote:
>>> On Sun, 22 Feb 2009, Hans de Goede wrote:
>>>> Yes that is what we are talking about, the camera having a gravity switch
>>>> (usually nothing as advanced as a gyroscope). Also the bits we are talking
>>>> about are in a struct which communicates information one way, from the camera
>>>> to userspace, so there is no way to clear the bits to make the camera do something.
>>> First, I'd like to say I agree with most that the installed orientation of
>>> the camera sensor really is a different concept than the current value of a
>>> gravity sensor.  It's not necessary, and maybe not even desirable, to
>>> handle them in the same way.
>>>
>>> I do not see the advantage of using reserved bits instead of controls.
>>>
>>> The are a limited number of reserved bits.  In some structures there are
>>> only a few left.  They will run out.  Then what?  Packing non-standard
>>> sensor attributes and camera sensor meta-data into a few reserved bits is
>>> not a sustainable policy.
>>>
>>> Controls on the other card are not limited and won't run out.
>>>
>> Yes but these things are *not* controls, end of discussion. The control API is
>> for controls, not to stuff all kind of cruft in.
> 
> All kind of cruft belongs in the reserved bits of whatever field it can be
> stuffed in?

Not whatever field, these are input properties which happen to also be pretty 
binary so putting them in the input flags field makes plenty of sense.

> What is the difference?  Why does it matter?  Performance?  Maintenance?
> Is there something that's not possible?  I do not find "end of discussion"
> to be a very convincing argument.

Well they are not controls, that is the difference, the control interface is 
for controls (and only for controls, end of discussion if you ask me). These 
are not controls but properties, they do not have a default min and max value, 
they have only one *unchanging* value, there  is nothing the application can 
control / change. It has been suggested to make them readonly, but that does 
not fix the ugliness. A proper written v4l2 application will enumerate all the 
controls, and then the user will see a grayed out control saying: "your cam is 
upside down" what is there to control ? will this be a grayed out slider? or a 
grayed out checkbox "your cam is upside down", or maybe a not grayed out 
dropdown: where the user can select: "my sensor is upside down", "I deny my 
sensor is upside down", "I don't care my sensor is upside down", "WTF is this 
doing in my webcam control panel?", "nwod edispu si rosnes yM"

Do you know I have an idea, lets get rid of the S2 API for DVB and put all that 
in controls too. Oh, and think like standards for video formats, surely that 
can be a control too, and ... and, ...

Yes we can stuff almost anything in a control, that does not make it a good idea.

Regards,

Hans
