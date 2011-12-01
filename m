Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57516 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab1LAOjn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 09:39:43 -0500
Received: by ggnr5 with SMTP id r5so1843051ggn.19
        for <linux-media@vger.kernel.org>; Thu, 01 Dec 2011 06:39:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <84bdeea7e55d1c5db1251e48309f2e36@chewa.net>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<84bdeea7e55d1c5db1251e48309f2e36@chewa.net>
Date: Thu, 1 Dec 2011 15:39:42 +0100
Message-ID: <CAJbz7-11WytPg3b=mU__Xr2kfXSP=e2mF39+paVTDyGqc0gGBQ@mail.gmail.com>
Subject: Re: [RFC] vtunerc: virtual DVB device
From: HoP <jpetrous@gmail.com>
To: =?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

> On Wed, 30 Nov 2011 22:38:33 +0100, HoP <jpetrous@gmail.com> wrote:
>> I have one big problem with it. I can even imagine that some "bad guys"
>> could abuse virtual driver to use it for distribution close-source
> drivers
>> in the binary blobs. But is it that - worrying about bad boys abusing -
>> the sufficient reason for such aggressive NACK which I did?
>
> I am not a LinuxTV developer so I am not in position to take a stand for
> or against this. Ultimately though, either your driver is rejected or it is
> accepted. This is not really a matter of being aggressive or not. It just
> so happens that many Linux-DVB contributors feel the same way against that
> class of driver.
>
> Also note the fear of GPL avoidance is not unique to Linux-DVB. If I am
> not mistaken there is no user-space socket API back-end for the same
> reasons. And there is also no _in-tree_ loopback V4L2 device driver in
> kernel.

Well, that is why I was asking again - in some parts there are similar
drivers accepted and in another parts no. Really confusing to me.
I'm not kernel hacker, so I didn't know about historical cases. Sorry.

[...]

>> I can't understand that because I see very similar drivers in kernel for
>> ages (nbd, or even more similar is usbip) and seems they don't hamper to
>> anybody.
>
> Sure. On That said, the Network Block Device, USB-IP and TUNTAP are not
> really competing with real drivers because of their high perfomance impact,
> so they are probably not the best examples to support your argument. uinput
> and ALSA loopback would seem like better examples to me.

Thanks for hints. It is no problem to use another arguments, if things get
cleaner then :-)

>> I would like to note that I don't want to start any flame-war,
>> so very short answer would be enough for me.
>
> Did you try to implement this through CUSE? Then there should be no GPL
> problems. Also then you do not need to convince anybody to take your driver
> in the kernel.

I did a very quick look on CUSE and if I understood it well, it was usable for
drivers not need for cooperation of other kernel internal subsystems.
But DVB driver usually use dvb-core subsystem (for tuning and for pid
filtering/demuxing),
so I don't see the way how to connect there. I think it is impossible.

Honza
