Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:23177 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbZCYOiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 10:38:09 -0400
Received: by yx-out-2324.google.com with SMTP id 31so59875yxl.1
        for <linux-media@vger.kernel.org>; Wed, 25 Mar 2009 07:38:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49C970C9.20407@gmail.com>
References: <49B9BC93.8060906@nav6.org>
	 <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>
	 <49C2D4DB.6060509@gmail.com> <49C33DE7.1050906@gmail.com>
	 <1237689919.3298.179.camel@palomino.walls.org>
	 <412bdbff0903221800j2f9e1137u7776191e2e75d9d2@mail.gmail.com>
	 <412bdbff0903241439u472be49mbc2588abfc1d675d@mail.gmail.com>
	 <49C96A37.4020905@gmail.com>
	 <Pine.LNX.4.64.0903250128110.11676@shogun.pilppa.org>
	 <49C970C9.20407@gmail.com>
Date: Wed, 25 Mar 2009 10:38:07 -0400
Message-ID: <412bdbff0903250738l23a3b04fpdebbad502897bf57@mail.gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
	and BER from HVR 4000 Lite
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Mika Laitio <lamikr@pilppa.org>, Andy Walls <awalls@radix.net>,
	linux-media@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 24, 2009 at 7:46 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
> Mika Laitio wrote:
>>>>> That said, the solution takes the approach of "revolutionary" as
>>>>> opposed to "evolutionary", which always worries me.  While providing a
>>>>> much more powerful interface, it also means all of the applications
>>>>> will have to properly support all of the various possible
>>>>> representations of the data, increasing the responsibility in userland
>>>>> considerably.
>>>
>>> Not necessarily, the application can simply chose to support what
>>> the driver provides as is, thereby doing no translations at all.
>>
>>> From the end user point of view it is not very usefull if he has 2
>> different cards and application can not show any usefull signal goodness
>> info in a way that would be easy to compare. So I think the attempt to
>> standardize to db is good.
>
> The first part: For comparison having a standardized value is good.
>
> True.
>
> But the problem that surrounds it:
>
> To do this, a driver should support statistics in dB. For a device
> which doesn't show statistics in dB, for reasons
> (a) device uses a different format
>
> (b) enough information is not available to do a conversion
>    (too less information, or a reverse engineered driver)
>
> (c) the conversion to be done makes things too complex in kernel land.
>
> So you have very less devices to do a comparison between.
>
> The other way to do this:
>
> Suppose, the driver that doesn't support a dB format (relative
> doesn't mean unknown) provides the information in a relative format.
> And the driver that provides the information in dB format, but that
> information you get, can be converted in to a relative floor -
> ceiling format (conversion handled by application, or by a library)
>
> This is a quick way.
>
> Now, which all devices do provide a scale in dB, which is really
> comparable ? There are many different parameters, quickly hacked
> together to be called SNR. In the terms you mention, you will be
> comparing things like
>
> SNR to CNR etc based on the device type.
>
> So eventually your comparison is wrong.
>
>
>> Maybe there could then in addition be some other optional method for
>> also getting data in some hw specific format in a way that Manu suggested.
>> But there should anyway be mandatory to have this one "standard goodness
>> value" in a way that does not require apps to make any complicate
>> comparisons... (I bet half of those apps would be broken for years)
>
>
> In the way i mentioned, it leaves to the application to choose from
> different styles such as
>
> (1) display parameters from the drivers, in their own native format
> (This is a completely human readable format, in which you can see
> the real scales)
>
> (2) convert parameters to a specific format.
> (The very important part here is that the application is free to
> convert from format A with driver X and  format B with driver Y, to
> get it into a unified format. if you really need the feature what
> you mentioned, you need this feature, rather than have all drivers
> being modified to provide one standard format)
>
> To make things look simple, i have a sample application which does
> (1) to make things look simple.
>
> If you choose to do (2) It will be just doing the conversion one
> time in a library or application, once rather than doing it multiple
> times in unknown ways and formats.

Hello Manu,

First off, a large part of your argument lies in the notion that many
of the devices do not support representing the SNR in dB.  However,
when I sent around the list in an attempt to do an inventory of what
formats were used by different demods, you didn't provide any actual
information.  Could you please look at the following list, and if you
know of how "unknown" demods do their SNR, provide the information?

http://www.devinheitmueller.com/snr.txt

My argument for doing it in dB was based on the inventory suggesting
that the vast majority of *known* devices do it that way.  If this is
incorrect, then how about providing some actual data so we have better
decision making?

I do agree that people should not be putting CNR data into the SNR
field.  If there are known cases where that happens, they should be
removed.  The CNR can be used to represent the "strength" field, but
it is not the same as the SNR and shouldn't be treated as such.  Also,
things like putting AGC feedback in that field should be removed as
well (or moved to the strength field).

I haven't raised this argument yet, but I also believe that once we
make this change, all the cases where the format for the SNR is
"unknown" should be "#ifdef 0" and return ENOSYS.  If nobody can tell
us what the format is, it's better to return nothing at all then
mislead users with garbage data.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
