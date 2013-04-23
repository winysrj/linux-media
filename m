Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325Ab3DWQ2H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 12:28:07 -0400
Message-ID: <5176B688.7020702@redhat.com>
Date: Tue, 23 Apr 2013 13:27:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: "Michael ." <boycee_@hotmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Fwd: Device no longer handled by em28xx kernel drivers
References: <DUB118-W3105CA5468C478D0494A7687CE0@phx.gbl>,<516EF48C.2080804@iki.fi>,<DUB118-W43501C44B9B252CC5A03DD87CE0@phx.gbl> <DUB118-W30802FB90E04796F1FBDE187CF0@phx.gbl> <5176AB5F.1050901@googlemail.com>
In-Reply-To: <5176AB5F.1050901@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-04-2013 12:40, Frank Schäfer escreveu:
> (forwarding to the linux-media mailing list) (2nd try)
>
>
> Am 18.04.2013 21:04, schrieb Michael .:
>> Hi
>>
>> I hope you don't mind me contacting you directly.
>
> Issues like this should always be discussed on the linux-media mailing
> list, so please CC it in the future.
> Neither I'm the em28xx maintainer nor do I know much about issues/things
> that happened in the past.
>
>> I have a USB device which I was surprised to find is no longer handled
>> by the driver:
>
> What does "no longer handled" mean ?
> What was the last kernel that supported this device ?
>
>>
>> Bus 001 Device 004: ID 0ccd:0072 TerraTec Electronic GmbH Cinergy Hybrid T
>>
>> I believe the hardware is em28xx + zl10353 + xc5000 as I can see my
>> precise hardware being detected by em28xx in dmesg output here:
>
> Yes, according to http://linux.terratec.de/tv_en.html it uses em2882+xc5000.
>
>>
>> http://doc.ubuntu-fr.org/terratec_cinergy_xs
>>
>> As I understand there might have been two parallel drivers being
>> developed.
>
> I never heard of a second driver.
>
>> I just wondered if there is any chance of this support being
>> re-instated for this particular one?
>> I am surprised to find that a device has gone from supported to
>> unsupported!
>
> I don't know. The em28xx driver is generally the right driver and it
> already supports other devices with the xc5000 tuner.
> If support for this device has really been removed a while ago, then
> there must have been good reasons...
>
> Mauro, Devin ?

It is hard to discuss without seeing the entire thread.

I don't remember having any USB ID removed from the driver.

In any case, it is likely easy to add support for it. It is just
a matter of capturing the logs from the other driver using
the usbmon interface, and checking for the specific bits needed
to make this device work.

This is described at:
	http://linuxtv.org/wiki/index.php/Bus_snooping/sniffing

In summary, once compiled v4l2-utils, it should do:

	$ cd contrib/
	$ ./parse_tcpdump_log.pl --pcap |./parse_em28xx.pl

eventually, if the device is not at usbmon1, you may need
to do:

	$ ~/parse_tcpdump_log.pl --list-devices
	usbmon2 ==> Camera (level 1)
	usbmon2 ==> USB2.0 Hub (level 1)

To list where the device is inserted, and then pass the --devices
to capture data on a different interface, like:

$ ./parse_tcpdump_log.pl --device usbmon2 |./parse_em28xx.pl

Regards,
Mauro

