Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38154 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbZBVWAD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 17:00:03 -0500
Message-ID: <49A1CA5B.5000407@redhat.com>
Date: Sun, 22 Feb 2009 22:57:47 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
References: <200902180030.52729.linux@baker-net.org.uk> <200902211253.58061.hverkuil@xs4all.nl> <49A13466.5080605@redhat.com> <alpine.LNX.2.00.0902221225310.10870@banach.math.auburn.edu> <49A1A03A.8080303@redhat.com> <alpine.LNX.2.00.0902221334310.10870@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0902221334310.10870@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



kilgota@banach.math.auburn.edu wrote:
> 
> 
> On Sun, 22 Feb 2009, Hans de Goede wrote:
> 
>>
>>
>> kilgota@banach.math.auburn.edu wrote:
>>>
>> <snip>
>>
>>
>>> Hans and Adam,
>>>
>>> I am not sure how it fits into the above discussion, but perhaps it 
>>> is relevant to point out that flags can be toggled. Here is what I mean:
>>>
>>> Suppose that we have two flags 01 and 10 (i.e. 2), and 01 signifies 
>>> VFLIP and 10 signifies HFLIP.
>>>
>>> Then for an "ordinary" camera in ordinary position these are 
>>> initialized as 00. If the "ordinary" camera is turned in some funny 
>>> way (and it is possible to know that) then one or both of these flags 
>>> gets turned off.
>>>
>>> But if it is a "funny" camera like some of the SQ905s the initial 
>>> values are 1 and 1, because the sensor is in fact mounted upside 
>>> down. Now, suppose that there is some camera in the future which, 
>>> just like this, has the sensor upside down, and suppose that said 
>>> hypothetical camera also has the ability to "know" that it has been 
>>> turned over so what was upside down is now right side up. Well, all  
>>> that one has to do is to flip the two bits from whatever they were to 
>>> have instead the opposite values!
>>>
>>> Observe that this would take care of the orientation problem both for 
>>> cameras which had the sensor mounted right in the first place, and 
>>> for cameras which had the sensor mounted wrong in the first place. 
>>> Just use the same two bits to describe the sensor orientation, and if 
>>> there is any reason (based upon some ability to know that the camera 
>>> orientation is now different) that the orientation should change, 
>>> then just flip the bits as appropriate.
>>>
>>> Then it would be the job of the support module to provide proper 
>>> initial values only for these bits, and everything else could be done 
>>> later on, in userspace.
>>>
>>> Theodore Kilgore
>>
>> Theodore,
>>
>> We want to be able to differentiate between a cam which has its sensor 
>> mounted upside down, and a cam which can be pivotted and happens to be 
>> upside down at the moment, in case of any upside down mounted sensor, 
>> we will always want to compentsate, in case of a pivotting camera 
>> wether we compensate or not could be a user preference.
>>
>> So in you example of an upside down mounted sensor in a pivotting 
>> encasing and the encasing is pivotted 180 degrees we would have the 
>> hflip and vflip bits set for sensor orientation and we would have the 
>> pivotted 180 degrees bit set. If the user has choosen to compensate 
>> for pivotting the default, we would do nothing. But it is important to 
>> be able to differentiate between the 2.
> 
> Hans,
> 
> I am not sure if we are talking past each other, or what. But I was 
> pointing out that the initial values of two bits can indicate the 
> "default" orientation of the sensor, and this can be done permanently in 
> the module, which transmits the initial setting of those two bits to 
> anything up the line which is interested or curious to know those 
> initial values. The information in those two bits will definitely tell 
> whether the sensor is mounted upside down in the camera. For example, if 
> it is mounted upside down, then they are both set in the module to "on" 
> and exported therefrom. But if the sensor is mounted correctly, then 
> both of them are set to "off" and similarly exported.
> 
> Now if any application for any reason (such as "knowing" that the camera 
> is upside down or is pointing in the opposite direction, or into a 
> mirror) wants to change the defaults, all it has to do is to toggle the 
> bits.
> 
> But, hmmm. Perhaps there is the question about how the app "knows" that 
> the camera is upside down or is pointed in another direction. If the 
> camera has a gyroscope inside, for example, then it could be the camera 
> which needs to tell to the app about the current orientation, or else 
> the app would not have any way to know ... Is this the problem, then? 
> For that kind of thing, one might need more than two bits in order to 
> pass the needed information.
> 

Yes that is what we are talking about, the camera having a gravity switch 
(usually nothing as advanced as a gyroscope). Also the bits we are talking 
about are in a struct which communicates information one way, from the camera 
to userspace, so there is no way to clear the bits to make the camera do something.

Regards,

Hans
