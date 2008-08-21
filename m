Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7LDruuI007008
	for <video4linux-list@redhat.com>; Thu, 21 Aug 2008 09:54:28 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7LDeedA020184
	for <video4linux-list@redhat.com>; Thu, 21 Aug 2008 09:40:40 -0400
Message-ID: <48AD72D5.4050408@hhs.nl>
Date: Thu, 21 Aug 2008 15:51:17 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
References: <48A8698E.3090004@hhs.nl> <1219304978.1762.25.camel@localhost>
In-Reply-To: <1219304978.1762.25.camel@localhost>
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
> On Sun, 2008-08-17 at 20:10 +0200, Hans de Goede wrote:
>> Hi,
> 
> Hi Hans,
> 
>> This patch adds a V4L2_CAP_SENSOR_UPSIDE_DOWN flag to the capabilities flags,
>> and sets this flag for the Philips SPC200NC cam (which has its sensor installed
>> upside down). The same flag is also needed and added for the Philips SPC300NC.
> 	[snip]
>> Of you do not plan to apply this patch please let me know that and why, then we 
>> can discuss this further, I really believe that in cases where the upside down 
>> ness is 100% known at the kernel level we should report this in some way to 
>> userspace so that libv4l can flip the image in software. I know that for 
>> certain cases the upside down ness needs to be determined elsewhere, but not 
>> for all cases.
>>
>> I believe all hardware info for a certain piece of hardware should be kept at 
>> one place, and in this case that is the driver. With upside down mounted 
>> generic laptop cam modules, the upside down ness is not module specific but 
>> laptop specific and thus this info should be stored in hal, which takes care of 
>> laptop model specific things which can differ from laptop to laptop even though 
>> they use the same lowlevel IC's. In this case however this is not system/latop 
>> specific but cam specific so this info should be stored together with the other 
>> cam specific knowledge (such as which sensor it uses) in the driver.
> 
> Well, I looked at various messages in various mail-lists talking about
> upside down. Sometimes, a webcam may be normal or upside down, or even
> just mirrored. Two times only (Vimicro 0325 and 0326), they say that the
> webcam is always upside down. So, is it useful to make a generic code
> for this specific case?
> 

Yes, as that will make these webcam work out of the box for end users. Please 
stop thinking as a developer for a moment and start thinking as a simple end 
user plugging such a cam into his asus eee pc, which is his first and only 
linux machine. What do you think he will like better, the upside down picture 
or the hey cool I plug in in this cam and it just works (tm) ?

> For the general case (the webcam may have H or V flip, or both - upside
> down). The user will see it. If she may use the HFLIP and VFLIP
> controls, she will get a correct image.

Currently the 4 major (as in more then just a gimmick) end user v4l wewbcam 
programs I'm aware of are:
ekiga
cheese
flash plugin
skype

And AFAIK (didn't check skype) non of these offer a simple GUI option for the 
user to change vflip / hflip controls. Telling a user to go the cmdline is not 
*userfriendly* and in this scenario is not necessary!

Sorry to say this, but sheesh what a lot of discussion I'm only adding one 
simple lousy flag, all the actual rotating code is done in libv4l! So what if 
for now we only can use this flag for 2 webcams, we may use it for others in 
the future.

The reason why I'm spending tons of time on all this webcam stuff, is so that 
end users can just plugin their cam and have it work. If that requires a 
special flag for just these 2 cams so be it and I strongly believe we will 
encounter other cams like this in the future.

> To go further, it will be nice
> to have a v4l2 control program which saves and restores the video
> control values at system stop and start times, as it is done for sound.
> 

That may be usefull, but I myself prefer (atleast for laptop frame cams) a 
solution using a laptop BIOS DMI string database so things will just work for 
end users.

> BTW, if noticed a small difference in the PAS106B initialization between
> the actual driver (zc3xx) and the data in usbvm31b.inf. As I have no
> such webcams, may anybody check what happens changing the lines 4146 and
> 4264 of zc3xx.c from
> 	{0xa0, 0x00, 0x01ad},
> to
> 	{0xa0, 0x09, 0x01ad},
> 
> This will impact on the webcams V:041e P:401c, 4034 and 4035, V:0471,
> P:0325, 0326, 032d and 032e.
> 

That register seems to influence the zc3xx autoexposure / autogain algorithm, 
with the values changed to 9 as suggested by you, the algorithm becomes very 
quick to adjust, so quick I can get it to oscilate quite easily just be moving 
me head a little in the picture until I've found a sweet spot for oscilating, 
so the 0 setting definitely is better!

I also tried writing 5 to it, but it does not seem to be a simple linear scale, 
after I wrote 5 to it no more autoexposure / gain was done at all, not even 
after changing the value back to 0, I had to unplug the cam to get autoexposure 
back again.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
