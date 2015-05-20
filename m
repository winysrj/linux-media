Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52281 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414AbbETUyP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 16:54:15 -0400
Date: Wed, 20 May 2015 22:54:13 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 4/6] [media] rc: lirc is not a protocol or a keymap
Message-ID: <20150520205413.GC15223@hardeman.nu>
References: <cover.1426801061.git.sean@mess.org>
 <2a2f4281ba60988242c11bdf2fda3243e2dc4467.1426801061.git.sean@mess.org>
 <20150514135123.4ba85dc7@recife.lan>
 <20150519203442.GB18036@hardeman.nu>
 <20150520051923.7cefe112@recife.lan>
 <5b14c3fee1ee0a553db5dac7b01fbf0a@hardeman.nu>
 <20150520060133.5b2846ae@recife.lan>
 <f7f9baed90d28f68a4284da0f9b127ad@hardeman.nu>
 <20150520191632.GA21798@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150520191632.GA21798@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 20, 2015 at 09:16:32PM +0200, David Härdeman wrote:
>On Wed, May 20, 2015 at 11:06:06AM +0200, David Härdeman wrote:
>>On 2015-05-20 11:01, Mauro Carvalho Chehab wrote:
>>>Em Wed, 20 May 2015 10:49:34 +0200
>>>David Härdeman <david@hardeman.nu> escreveu:
>>>
>>>>On 2015-05-20 10:19, Mauro Carvalho Chehab wrote:
>>>>> Em Tue, 19 May 2015 22:34:42 +0200
>>>>> David Härdeman <david@hardeman.nu> escreveu:
>>>>>> I think we should be able to at least not break userspace by still
>>>>>> accepting (and ignoring) commands to enable/disable lirc.
>>>>>
>>>>> Well, ignoring is not a good idea, as it still breaks userspace, but
>>>>> on a more evil way. If one is using this feature, we'll be receiving
>>>>> bug reports and fixes for it.
>>>>
>>>>I disagree it's more "evil" (or at least I fail to see how it would be).
>>>
>>>Because the Kernel would be lying to userspace. If one tells the Kernel to
>>>disable something, it should do it, or otherwise return an error explaining
>>>why disabling was not possible.
>>
>>Would really you be happier with a patch so that writing "-lirc" to the sysfs
>>file returns an error?
>
>Actually that would be very weird in case userspace writes e.g. "rc5" to
>the sysfs file (since that implies disabling lirc which would then
>return an error as well).
>
>So, that won't work. I still think just ignoring "+lirc" and "-lirc" is
>the best solution...(and the usecase you suggested of disabling lirc so
>that lircd won't get any events while an app reads only decoded
>events...seems very far-fetched)...do you have any other suggestion?

I've done some more checking.

Not changing protocols even though user-space asked for it is actually
already part of the rc-core API.

struct rc_dev contains:
	int (*change_protocol)(struct rc_dev *dev, u64 *rc_type);

The reason rc_type is a pointer is that it is used to pass the requested
protocols to the change_protocol function and the function can then
update it to reflect what the actual result was.

Examples:
drivers/media/usb/em28xx/em28xx-input.c
drivers/media/rc/img-ir/img-ir-hw.c

Both of these drivers will pick *one* protocol to enable...so if you'd
write "+rc5 +nec" to their sysfs protocols file, it'd just enable one
protocol (and the file would read e.g. "[rc5] nec" afterwards).

With that in mind, userspace could never expect the list of enabled
protocols to match what it just wrote, even if no error was returned.

-- 
David Härdeman
