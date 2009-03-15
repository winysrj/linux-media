Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:37891 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbZCOOkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 10:40:32 -0400
Received: by yw-out-2324.google.com with SMTP id 5so759373ywh.1
        for <linux-media@vger.kernel.org>; Sun, 15 Mar 2009 07:40:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49BD0088.6050203@gmx.de>
References: <49B9BC93.8060906@nav6.org>
	 <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>
	 <49B9DECC.5090102@nav6.org>
	 <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
	 <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>
	 <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>
	 <37219a840903131452mf8b7969h881a24fc2dd031e8@mail.gmail.com>
	 <a3ef07920903131527x2762f6e6y18f3a0b825ff2a49@mail.gmail.com>
	 <412bdbff0903131531y3dcb5382red13ac1e4d43feaf@mail.gmail.com>
	 <49BD0088.6050203@gmx.de>
Date: Sun, 15 Mar 2009 10:40:29 -0400
Message-ID: <412bdbff0903150740m1a1884bdhc296542e3fb3a87a@mail.gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
	and BER from HVR 4000 Lite
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: wk <handygewinnspiel@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 15, 2009 at 9:20 AM, wk <handygewinnspiel@gmx.de> wrote:
>> 1.  Getting everyone to agree on a standard representation for the
>> field, and how to represent certain error conditions (such as when a
>> demod doesn't support SNR, or when it cannot return a valid value at a
>> given time).
>>
>>
>
> Its just straightforward as described in DVB API, chapters
> 2.2.3 FE READ STATUS
> 2.2.4 FE READ BER
> 2.2.5 FE READ SNR
> 2.2.6 FE READ SIGNAL STRENGTH
> 2.2.7 FE READ UNCORRECTED BLOCKS
>
> if ioctl suceeds with valid data: 0, if not one of
> EBADF            no valid fi le descriptor.
> EFAULT          error condition
> ENOSIGNAL  not yet, i have no signal..
> ENOSYS         not supported by device.

You're right, the error codes are indeed currently documented.  I
guess I just didn't realize that since I saw many different devices
returning zero when the call was unimplemented, and returning garbage
when there was no signal lock.  In which case, the error codes don't
need to be agreed on, they just need to be implemented across all the
drivers.  Of course, the bigger issue still remains to figure out what
format the actual SNR should be in.

>> 2.  Converting all the drivers to the agreed-upon format.  For some
>> drivers this is relatively easy as we have specs available for how the
>> SNR is represented.  For others, the value displayed is entirely
>> reverse engineered so the current representations are completely
>> arbitrary.
>
> Since a lot of frontends have no proper docs, probably providing the signal
> strength unit with a second ioctl could make sense here.
>
> a.u.          arbitrary units, not exactly known or not perfectly working
> dBµV       comparable trough all devices, but probably not possible for all
> percent     technical not understandable, percent relative to what? Assumes
> that there is a optimum/hard limit of 100% which is not the case.

That was the very first suggestion I put out - to at least provide an
ioctl indicating what unit the data was represented in, so
applications would know how to show it (as opposed to trying to get
every driver to unify it's return format).  However, at the time the
thinking was to at least get an inventory of all the different formats
being used and how many drivers are impacted, and we can then assess
how hard it would actually be to get them into a unified format.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
