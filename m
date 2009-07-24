Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:53616 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbZGXNbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 09:31:35 -0400
Received: by ewy26 with SMTP id 26so1731507ewy.37
        for <linux-media@vger.kernel.org>; Fri, 24 Jul 2009 06:31:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090724100608.716d8b47@pedra.chehab.org>
References: <d9def9db0907230240w6d3a41fcv2fcef6cbb6e2cb8c@mail.gmail.com>
	 <829197380907230503y3a2ca24y4434ed759c1f4009@mail.gmail.com>
	 <d9def9db0907230510h31d1d225pb1d317c9a41fa210@mail.gmail.com>
	 <829197380907230705w4f1c3126r9cf156ca30aa2b5b@mail.gmail.com>
	 <d9def9db0907230729k4cc14707v763d242e14292ebb@mail.gmail.com>
	 <20090723155935.285f9cba@pedra.chehab.org>
	 <d9def9db0907240354x15927f29k2fc0939d25202e1@mail.gmail.com>
	 <20090724090600.525c86b8@pedra.chehab.org>
	 <d9def9db0907240515s28490707sfae205813033cad6@mail.gmail.com>
	 <20090724100608.716d8b47@pedra.chehab.org>
Date: Fri, 24 Jul 2009 15:31:32 +0200
Message-ID: <d9def9db0907240631y495b65a1mc85571b5339ad518@mail.gmail.com>
Subject: Re: em28xx driver crashes device
From: Markus Rechberger <mrechberger@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 24, 2009 at 3:06 PM, Mauro Carvalho
Chehab<mchehab@infradead.org> wrote:
> Em Fri, 24 Jul 2009 14:15:16 +0200
> Markus Rechberger <mrechberger@gmail.com> escreveu:
>
>> On Fri, Jul 24, 2009 at 2:06 PM, Mauro Carvalho
>> Chehab<mchehab@infradead.org> wrote:
>> > Em Fri, 24 Jul 2009 12:54:27 +0200
>> > Markus Rechberger <mrechberger@gmail.com> escreveu:
>> >
>> >> someone has problems here? We also support available opensource
>> >> players and will contribute some patches which can be used by all
>> >> devices.
>> >
>>
>> Ah well Mauro,
>>
>> > This mailing list, the freenode irc channels #v4l and #linuxtv, the V4L and the
>> > LinuxTV mailing lists were created for discussing open source development
>> > related to the kernel linux media drivers, the usability of those drivers and
>> > related open source themes.
>> >
>> > Anything related to binary only userspace stuff is completely out of topic and
>> > shouldn't be posted on the above places.
>> >
>> > Despiste what you're saying, your intention to drop support to open source is
>> > clear: you are playing against open source since 2007, when you firstly proposed a
>> > frontend hook at the kernel driver for userspace. This year, you dropped all
>> > open source trees you used to have. So, it is clear that you're out of open
>> > source business, and you won't be giving any open source support. So, please
>> > stop posting at the open source forums
>> >
>>
>> there's no reason to argue with you since you have your own ideas. We
>> do give opensource support as well. So please find another target to
>> struggle around with. Let's see who's able to deliver the better
>> solution for endusers.
>
> This is not a sort of game to see who has a better solution for end users.
>
> A company that has a serious commit to open source opens their datasheets to
> allow public development and contributions and submit patches regularly
> upstream, without any userspace hooks.
>

If a kerneldriver would be required for our devices we now would
definitely submit further patches to the kernel, but for USB drivers
it is just not necessary at all since the entire driver can work
without any complex dependencies in Userspace. Basically the
historically grown v4l-dvb kernelapi is just not needed and just
limits the customer base as initially pointed out that not everyone is
able to compile those drivers. It is still valid for PCI devices
probably until IOMMU is available. This has absolutely nothing to do
with what you wrote, rather than the em28xx kerneldriver is basically
not needed. If you want datasheets of various companies apply there
and work for them, everyone's free to do so.

regards,
Markus
