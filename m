Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:43489 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab1KGKsB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Nov 2011 05:48:01 -0500
Message-ID: <4EB7B75B.70004@linuxtv.org>
Date: Mon, 07 Nov 2011 11:47:55 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Steffen Barszus <steffenbpunkt@googlemail.com>
CC: linux-media Mailing List <linux-media@vger.kernel.org>,
	James <bjlockie@lockie.ca>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: femon signal strength
References: <4EA78E3C.2020308@lockie.ca> <CAGoCfiwS=O75uyaaueNSrq275MS9eednR+Y=yrgsJo0XaExRKA@mail.gmail.com> <4EA86366.1020906@lockie.ca> <CAGoCfiww_5pF_S3M_mpN4gk1qqLYn7H7PPcieZXZNnjvK-RHHA@mail.gmail.com> <4EA86668.6090508@lockie.ca> <20111105111050.5b8762fa@grobi> <CAGoCfiwC+7pkY6ZchySBYRkyY1XjFjKeJYQEPTc2ZiBN-pdoyw@mail.gmail.com> <20111106141515.5b56a377@grobi> <CAGoCfixoOwZumohwJrLVKhfpUNGYwbD9uSq7nM0GhqriOx0FxA@mail.gmail.com> <20111106205907.47b9102b@grobi>
In-Reply-To: <20111106205907.47b9102b@grobi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I didn't receive Devin's mail, so I'm replying to this one instead, see
below:

On 06.11.2011 20:59, Steffen Barszus wrote:
> On Sun, 6 Nov 2011 10:01:49 -0500
> Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> 
>> On Sunday, November 6, 2011, Steffen Barszus
>> <steffenbpunkt@googlemail.com> wrote:
>>>
>>> Any uniform
>>> scale is better, then whats there at the moment.

[...]

>> (and I've said on numerous occasions when discussing this
>> issue that any standard that is uniform is better than no standard at
>> all).  "Perfect is the enemy of good"

Quoting myself from three years ago, I propose to add an interface to
read SNR in units of db/100:

On 17.10.2008 11:55, Andreas Oberritter wrote:
> How about adding a new command instead (and a similar one for S2API)? 
> 
> /* Read SNR in units of dB/100 */
> #define FE_READ_SNR_DB _IOR('o', 74, __u16)
> 
> Then it's no problem to slowly migrate the drivers to this interface. The
> old interface can still stay for some time without changes. Applications
> can try this ioctl, and if it returns an error, then it is not implemented
> for the used device.

S2API currently implements none of the signal quality measurement
commands that v3 knows about. Nevertheless, it should be easy to add a
property:

/* SNR in units of dB/100 */
#define DTV_SNR		44

If a driver does not implement this property, the core should return an
error (i.e. set dtv_property.result to a non-zero value, e.g. -EOPNOTSUPP).

Regards,
Andreas
