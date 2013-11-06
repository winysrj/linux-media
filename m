Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53537 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab3KFQNo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Nov 2013 11:13:44 -0500
Message-ID: <527A6AAD.50901@iki.fi>
Date: Wed, 06 Nov 2013 18:13:33 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>,
	=?UTF-8?B?44G744Gh?= <knightrider@are.ma>
CC: linux-media <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: Re: [PATCH] Full DVB driver package for Earthsoft PT3 (ISDB-S/T)
 cards
References: <1383666180-9773-1-git-send-email-knightrider@are.ma>	<CAOcJUbxCjEWk47MkJP15QBAuGd3ePYS3ZRMduqdMCrVT362-8Q@mail.gmail.com>	<CAKnK8-Q51UOqGc1T2jfJENm5pOWAutytKLcDkhgkM3yWjAtJ2w@mail.gmail.com>	<CAKnK8-Rva-m-tVN3n16Q3O0D5bhYrNsFm4+1f8=xvp92aMa-uA@mail.gmail.com> <CAOcJUbx96JYHaqQd3BG-p3h1M9TXjvkvffnzURBgUrWoWOk9HQ@mail.gmail.com>
In-Reply-To: <CAOcJUbx96JYHaqQd3BG-p3h1M9TXjvkvffnzURBgUrWoWOk9HQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06.11.2013 15:14, Michael Krufky wrote:
> On Tue, Nov 5, 2013 at 5:30 PM, ほち <knightrider@are.ma> wrote:
>> Michael Krufky <mkrufky <at> linuxtv.org> writes:
>>
>>> As the DVB maintainer, I am telling you that I won't merge this as a
>>> monolithic driver.  The standard is to separate the driver into
>>> modules where possible, unless there is a valid reason for doing
>>> otherwise.
>>>
>>> I understand that you used the PT1 driver as a reference, but we're
>>> trying to enforce a standard of codingstyle within the kernel.  I
>>> recommend looking at the other DVB drivers as well.
>>
>> OK Sir. Any good / latest examples?
>
> There are plenty of DVB drivers to look at under drivers/media/  ...
> you may notice that there are v4l and dvb device drivers together
> under this hierarchy.  It's easy to tell which drivers support DVB
> when you look at the source.
>
> I could name a few specific ones, but i'd really recommend for you to
> take a look at a bunch of them.  No single driver should be considered
> a 'prefect example' as they are all under constant maintenance.
>
> Also, many of these drivers are for devices that support both v4l and
> DVB interfaces.  One example is the cx23885 driver.  Still, please try
> to look over the entire media tree, as that would give a better idea
> of how the drivers are structured.

I will also try explain that modular chipset driver architecture what I 
could :)

If you look normal digital television device there is always 3 chips, 
usually those exists in physically, but some cases multiple chips are 
integrated to same packet.
Those chips are:
1) bus interface (USB/PCIe/firewire "bridge")
2) demodulator
3) RF tuner (we call it usually just tuner)

There has been multiple cases where people has submitted one big driver 
and afterwards some new devices appeared having same chips. It is almost 
impossible to separate those drivers afterwards as you will need 
original hardware and so. That has led to situation we have some 
overlapping drivers.

To avoid these problems, we have specified some rules to new drivers:
RFCv2: Second draft of guidelines for submitting patches to linux-media
http://lwn.net/Articles/529490/

I search some pictures from that device to see what are used chips. Here 
is blog having some pictures:
http://hidepod.blog.shinobi.jp/iyh-/%E5%98%98%E3%81%A0%EF%BC%81

What I see:
1) PCI-bridge. Custom Altera Cyclone IV FPGA. (heh, that is familiar 
chip for me. I have used older Cyclone II for some digital technique 
course exercises).
2) Toshiba demodulator
3) Sharp tuner module (there is some tuner chip inside, which needs driver)

So those are the parts and each one needs own driver.

regards
Antti

-- 
http://palosaari.fi/
