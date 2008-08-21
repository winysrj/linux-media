Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7LHmUU8013974
	for <video4linux-list@redhat.com>; Thu, 21 Aug 2008 13:48:30 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7LHlug5024832
	for <video4linux-list@redhat.com>; Thu, 21 Aug 2008 13:47:57 -0400
Message-ID: <48ADACC9.7000009@hhs.nl>
Date: Thu, 21 Aug 2008 19:58:33 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
References: <48A8698E.3090004@hhs.nl> <1219304978.1762.25.camel@localhost>	
	<48AD72D5.4050408@hhs.nl> <1219337937.1726.39.camel@localhost>
In-Reply-To: <1219337937.1726.39.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: PATCH: gspca-spc200nc-upside-down-v2
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

Jean-Francois Moine wrote:
> On Thu, 2008-08-21 at 15:51 +0200, Hans de Goede wrote:
>> Jean-Francois Moine wrote:
> 	[snip]
>>> Well, I looked at various messages in various mail-lists talking about
>>> upside down. Sometimes, a webcam may be normal or upside down, or even
>>> just mirrored. Two times only (Vimicro 0325 and 0326), they say that the
>>> webcam is always upside down. So, is it useful to make a generic code
>>> for this specific case?
>> Yes, as that will make these webcam work out of the box for end users. Please 
>> stop thinking as a developer for a moment and start thinking as a simple end 
>> user plugging such a cam into his asus eee pc, which is his first and only 
>> linux machine. What do you think he will like better, the upside down picture 
>> or the hey cool I plug in in this cam and it just works (tm) ?
> 
> It is possible if some system application (hal?) does the job.
> 
>>> For the general case (the webcam may have H or V flip, or both - upside
>>> down). The user will see it. If she may use the HFLIP and VFLIP
>>> controls, she will get a correct image.
>> Currently the 4 major (as in more then just a gimmick) end user v4l wewbcam 
>> programs I'm aware of are:
>> ekiga
>> cheese
>> flash plugin
>> skype
>>
>> And AFAIK (didn't check skype) non of these offer a simple GUI option for the 
>> user to change vflip / hflip controls. Telling a user to go the cmdline is not 
>> *userfriendly* and in this scenario is not necessary!
> 
> You did not try v4l2ucp?
> 

No I didn't and that is not installed by default on most systems, it actually 
isn't packaged for most distros and even it was needing to start up a seperate 
application is anything but userfriendly, things should just work whenever 
possible.

> 	[snip]
>> The reason why I'm spending tons of time on all this webcam stuff, is so that 
>> end users can just plugin their cam and have it work. If that requires a 
>> special flag for just these 2 cams so be it and I strongly believe we will 
>> encounter other cams like this in the future.
> 	[snip]
> 
> Sorry, but I am not happy the way it is done. Here is an other proposal.
> 
> In the V4L2 spec, VIDIOC_QUERYCTRL returns the controls accepted (or
> rejected) by the driver, and also information about these ones. As the
> Vimicro/Z-star has no way to change H and V flips, the driver may give
> these controls as READ_ONLY and set the control values according to the
> device type.
> 
> Now, when accessing the device, the V4L library will get the flags and
> values of the H and V flip. If HFLIP and VFLIP are settable, the driver
> does all the job. If not (HFLIP and VFLIP are READ_ONLY or INVAL), the
> library memorizes the control values of the driver (INVAL implies 0) and
> also the values asked by the application. Frame decoding is then H
> and/or H flipped according to (<driver value> ^ <user value>).
> 

As interesting as ideas like this are, that translates to a *lott* of 
additional code for no gain, all we need (for this case) is a way for the 
kernel to tell libv4l I know 100% certain this device is upside down.

This is a boolean a simple flag is sufficient for that anything more is bloat!

Why on earth would we add fake controls for that (confusing applications like 
v4l2ucp), and then add more fake controls to libv4l to cover up the fake 
controls of the driver ????

I know you want me to add fake v4l2 controls for the software flipping in 
libv4l, but what is the use case scenario for that? As technically interesting 
this might be, I see little relevant real life use for it, I see little 
relevant real life use for flipping in general (which is proven by the lack of 
availability to control flipping from all serious webcam applications). The 
only use for flipping is to correct broken hardware and todo that we do not 
need to export the flipping functionality to the application using libv4l, so 
until a practical real life example which shows the use of adding fake v4l2 
controls for flipping to libv4l I won't be adding them.

You see there is this little thing called time, and this whole discussion and 
the whole add fake v4l2 controls for flipping thing is a big waste of time!

I've actually spend many many hours the last 3 days getting the Pixart JPEG 
cams to work (and I'm happy to report I hope to post patches for them soon). 
I've even bought a pac7311 based cam to complement my pac7302 based cam so that 
I could test both code paths and I much rather spend my time on this (as this 
is actually usefull for people) then on such frivilous features as adding fake 
v4l2 flip controls, whats next fake contrast and brightness? The sky is the 
limit ...

So let me repeat the most important part of this mail:

This is a boolean a simple flag is sufficient for that anything more is bloat!


Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
