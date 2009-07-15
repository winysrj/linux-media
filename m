Return-path: <linux-media-owner@vger.kernel.org>
Received: from proxy1.bredband.net ([195.54.101.71]:44046 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbZGOM6L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jul 2009 08:58:11 -0400
Received: from iph1.telenor.se (195.54.127.132) by proxy1.bredband.net (7.3.140.3)
        id 49F5A152019DDD93 for linux-media@vger.kernel.org; Wed, 15 Jul 2009 14:58:10 +0200
Message-ID: <b2ff3e182a6cfce5a5a65df7083ab1d3.squirrel@mail.kurelid.se>
In-Reply-To: <4A26832B.5060508@nildram.co.uk>
References: <4A197CE8.9040404@gmail.com> <4A26832B.5060508@nildram.co.uk>
Date: Wed, 15 Jul 2009 14:58:08 +0200
Subject: Re: Digital Everywhere FloppyDTV / FireDTV (incl. CI)
From: "Henrik Kurelid" <henke@kurelid.se>
To: lotway@nildram.co.uk
Cc: "David Lister" <foceni@gmail.com>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lou,

I do not have a DVB-C variant, but if you enable the AVC logging in the driver (cat -1 > /sys/module/firedtv/parameters/debug) and give a pointer to
a log from where you try to do a tune or scan, I can take a look at the log for you to see what I can come up with.
Also, please provide information about what scan file you are using.

Regards,
Henrik


> David Lister wrote:
>> Hi all,
>>
>> just found out that these cards have finally some preliminary Linux
>> support. They seem quite versatile and even customizable -- a true gift
>> for dedicated hobbyists. :) PCI/PCIe/AGP or floppy drive mounting and
>> firewire /connection/ chaining look especially interesting. Even
>> FloppyDTV is apparently half internal, half external - sort of. Anybody
>> with hands-on access? Any updates? Share your experience! :o)
>
> I have been evaluating the Floppy DTV DVB-S2, DVB-T and DVB-C variants.
>
> So far I have managed to get fairly good results from the DVB-S2 and
> DVB-T adapters but I can't get the DVB-C device to tune under linux. I
> tested it with a windows PC to be sure it wasn't faulty and it worked fine.
>
> I've had them all working (i.e. appearing as devices) while chained one
> to the next and when individually connected to a 1394 adapter card.
>
> Now I need to spend some more time to see if they will give the
> performance I need, but so far so good.
>
> If anyone has been able to tune the cable adapter under linux I'd like
> to hear more.
>
> I had to make a small modification to the driver to enable some frontend
> settings required by my applications, but apart from that the latest v4l
>   drivers have been sufficient.
>
> Cheers,
>
> Lou
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

