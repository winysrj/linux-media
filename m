Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33134 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab2FCCos (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Jun 2012 22:44:48 -0400
Received: from dyn3-82-128-188-130.psoas.suomi.net ([82.128.188.130] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1Sb0o9-0005g9-Gr
	for linux-media@vger.kernel.org; Sun, 03 Jun 2012 05:44:45 +0300
Message-ID: <4FCACF9C.8060509@iki.fi>
Date: Sun, 03 Jun 2012 05:44:44 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Re: Fwd: [Bug 827538] DVB USB device firmware requested in module_init()
References: <bug-827538-199927-UDXT6TGYkq@bugzilla.redhat.com> <4FC91D64.6090305@iki.fi> <4FCA41D7.2060206@iki.fi>
In-Reply-To: <4FCA41D7.2060206@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/02/2012 07:39 PM, Antti Palosaari wrote:
> On 06/01/2012 10:52 PM, Antti Palosaari wrote:
>>
>>
>> -------- Original Message --------
>> Subject: [Bug 827538] DVB USB device firmware requested in module_init()
>> Date: Fri, 01 Jun 2012 19:44:17 +0000
>> From: bugzilla@redhat.com
>> To: crope@iki.fi
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=827538
>>
>> Kay Sievers <kay@redhat.com> changed:
>>
>> What |Removed |Added
>> ----------------------------------------------------------------------------
>>
>>
>> CC| |gansalmon@Gmail.com,
>> | |itamar@ispbrasil.com.br,
>> | |kernel-maint@redhat.com,
>> | |madhu.chinakonda@gmail.com
>> Component|udev |kernel
>> Assignee|udev-maint@redhat.com |kernel-maint@redhat.com
>> Summary|DVB USB device firmware |DVB USB device firmware
>> |downloading takes 30 |requested in module_init()
>> |seconds |
>>
>> --- Comment #1 from Kay Sievers <kay@redhat.com> ---
>> This is very likely a kernel driver issue.
>>
>> Drivers must not load firmware in the module_init() path, or device
>> probe()/bind() path. This creates a deadlock in the event handling.
>>
>> We used to silently try to work around that, but recently started
>> to log this error explicitely.
>>
>> The firmware should in general be requested asynchronously, or at the
>> first
>> open() of the device.
>>
>> Details are here:
>> http://thread.gmane.org/gmane.linux.network/217729
>>
>
> I suspect all of our DVB USB firmere downloading problems are coming
> from that issues. I mean especially those suspend / resume failings too.
>
> What I think I will try to delay driver registertration using workqueue.
> Return just success for the USB driver probe and continue real probe
> from workqueue.

That solves DVB USB firmware loading problems. I wonder why that udev 
requirement not to block module init was not informed for linux-media... 
Now it is much work to look thru all drivers and check those did not 
load firmware on attach or init.

regards
Antti
-- 
http://palosaari.fi/
