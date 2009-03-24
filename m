Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:40128 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbZCXXq1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 19:46:27 -0400
Message-ID: <49C970C9.20407@gmail.com>
Date: Wed, 25 Mar 2009 03:46:17 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Mika Laitio <lamikr@pilppa.org>
CC: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
 and BER from HVR 4000 Lite
References: <49B9BC93.8060906@nav6.org>  <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>  <20090319101601.2eba0397@pedra.chehab.org>  <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>  <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net>  <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>  <49C2D4DB.6060509@gmail.com> <49C33DE7.1050906@gmail.com>  <1237689919.3298.179.camel@palomino.walls.org>  <412bdbff0903221800j2f9e1137u7776191e2e75d9d2@mail.gmail.com> <412bdbff0903241439u472be49mbc2588abfc1d675d@mail.gmail.com> <49C96A37.4020905@gmail.com> <Pine.LNX.4.64.0903250128110.11676@shogun.pilppa.org>
In-Reply-To: <Pine.LNX.4.64.0903250128110.11676@shogun.pilppa.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mika Laitio wrote:
>>>> That said, the solution takes the approach of "revolutionary" as
>>>> opposed to "evolutionary", which always worries me.  While providing a
>>>> much more powerful interface, it also means all of the applications
>>>> will have to properly support all of the various possible
>>>> representations of the data, increasing the responsibility in userland
>>>> considerably.
>>
>> Not necessarily, the application can simply chose to support what
>> the driver provides as is, thereby doing no translations at all.
> 
>> From the end user point of view it is not very usefull if he has 2 
> different cards and application can not show any usefull signal goodness
> info in a way that would be easy to compare. So I think the attempt to
> standardize to db is good.

The first part: For comparison having a standardized value is good.

True.

But the problem that surrounds it:

To do this, a driver should support statistics in dB. For a device
which doesn't show statistics in dB, for reasons
(a) device uses a different format

(b) enough information is not available to do a conversion
    (too less information, or a reverse engineered driver)

(c) the conversion to be done makes things too complex in kernel land.

So you have very less devices to do a comparison between.

The other way to do this:

Suppose, the driver that doesn't support a dB format (relative
doesn't mean unknown) provides the information in a relative format.
And the driver that provides the information in dB format, but that
information you get, can be converted in to a relative floor -
ceiling format (conversion handled by application, or by a library)

This is a quick way.

Now, which all devices do provide a scale in dB, which is really
comparable ? There are many different parameters, quickly hacked
together to be called SNR. In the terms you mention, you will be
comparing things like

SNR to CNR etc based on the device type.

So eventually your comparison is wrong.


> Maybe there could then in addition be some other optional method for
> also getting data in some hw specific format in a way that Manu suggested.
> But there should anyway be mandatory to have this one "standard goodness
> value" in a way that does not require apps to make any complicate
> comparisons... (I bet half of those apps would be broken for years)


In the way i mentioned, it leaves to the application to choose from
different styles such as

(1) display parameters from the drivers, in their own native format
(This is a completely human readable format, in which you can see
the real scales)

(2) convert parameters to a specific format.
(The very important part here is that the application is free to
convert from format A with driver X and  format B with driver Y, to
get it into a unified format. if you really need the feature what
you mentioned, you need this feature, rather than have all drivers
being modified to provide one standard format)

To make things look simple, i have a sample application which does
(1) to make things look simple.

If you choose to do (2) It will be just doing the conversion one
time in a library or application, once rather than doing it multiple
times in unknown ways and formats.


Regards,
Manu
