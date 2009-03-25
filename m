Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:53034 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZCYA3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:32 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2814285ywb.1
        for <linux-media@vger.kernel.org>; Tue, 24 Mar 2009 17:29:30 -0700 (PDT)
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
Date: Tue, 24 Mar 2009 17:29:29 -0700
Message-ID: <a3ef07920903241729m9bcf464l13be5910b768e24b@mail.gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
	and BER from HVR 4000 Lite
From: VDR User <user.vdr@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Mika Laitio <lamikr@pilppa.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 24, 2009 at 4:46 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
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

Those are strong points you're making and more then enough reason to
maintain the values in their native form and deal with it elsewhere.

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

Another good point.  And a quick comment that I like the idea of a
library.  This takes the burden off the app while leaving options
available instead of just forcing everything to dB whether it's
compatible or not.

>> Maybe there could then in addition be some other optional method for
>> also getting data in some hw specific format in a way that Manu suggested.
>> But there should anyway be mandatory to have this one "standard goodness
>> value" in a way that does not require apps to make any complicate
>> comparisons... (I bet half of those apps would be broken for years)
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

Makes sense.  One of my concerns was that this would just be slapped
together and rushed like some other things were and finding out how
bad of an idea that was after the fact.  This doesn't need to take
forever to reach a majority opinion, but it should have enough thought
behind it to not cut people off at the knees.

It sounds to me that preserving the native format is certainly a good
idea for the numerous reasons that have been pointed out, and
providing converting via library is the most sane approach.  Trying to
force a square into a circle never seems to work out very well.

Best regards,
Derek
