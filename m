Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:40345 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZAUC0Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 21:26:25 -0500
Received: by bwz14 with SMTP id 14so11967434bwz.13
        for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 18:26:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1232503628.2685.5.camel@pc10.localdom.local>
References: <496C9FDE.2040408@hemmail.se>
	 <d9def9db0901131101y59cd5c1ct2344052f86b42feb@mail.gmail.com>
	 <d9def9db0901151028k6ab8bd79q6627c7516020aabe@mail.gmail.com>
	 <alpine.DEB.2.00.0901171037230.18169@ybpnyubfg.ybpnyqbznva>
	 <d9def9db0901170216g5be0ed16sa1eeb4c4f9acce76@mail.gmail.com>
	 <1232503628.2685.5.camel@pc10.localdom.local>
Date: Wed, 21 Jan 2009 03:26:22 +0100
Message-ID: <d9def9db0901201826j7bef2232s6ad12b7ff081ece3@mail.gmail.com>
Subject: Re: [linux-dvb] Terratec XS HD support?
From: Markus Rechberger <mrechberger@gmail.com>
To: linux-media@vger.kernel.org
Cc: "DVB mailin' list thingy" <linux-dvb@linuxtv.org>,
	em28xx@mcentral.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 21, 2009 at 3:07 AM, hermann pitton <hermann-pitton@arcor.de> wrote:
>
> Am Samstag, den 17.01.2009, 11:16 +0100 schrieb Markus Rechberger:
>> On Sat, Jan 17, 2009 at 10:57 AM, BOUWSMA Barry
>> <freebeer.bouwsma@gmail.com> wrote:
>> > Hi Markus, I follow your list as a non-subscriber, but I thought
>> > it would be worthwhile to post this to linux-dvb as well, and
>> > eventually to linux-media...
>> >
>> > On Thu, 15 Jan 2009, Markus Rechberger wrote:
>> >
>> >> On Tue, Jan 13, 2009 at 8:01 PM, Markus Rechberger
>> >> <mrechberger@gmail.com> wrote:
>> >
>> >> >> Is there any news about Terratec HTC USB XS HD support?
>> >
>> >> > it's upcoming soon.
>> >
>> > Thanks Markus, that's good news for me, and for several people
>> > who have written me as well!
>> >
>> >
>> >> http://mcentral.de/wiki/index.php5/Terratec_HTC_XS
>> >> you might track that site for upcoming information.
>> >
>> > Interesting.  You say that your code will make use of a BSD
>> > setup.  Can you or someone say something about this, or point
>> > to past discussion which explains this?  Would this be the
>> > userspace_tuner link on your wiki?
>> >
>> > In particular, I'm wondering whether this is completely
>> > compatible with the standard DVB utilities -- dvbscan,
>> > dvbstream, and the like, or whether a particular higher-
>> > level end-user application is required.
>> >
>> >
>>
>> The design goes hand in hand with some discussions that have been made
>> with some BSD developers.
>> The setup makes use of usbdevfs and pci configspace access from
>> userland, some work still has to be done there, it (will give/gives)
>> manufacturers the freedom to release opensource and binary drivers for
>> userland.
>> I'm a friend of open development and not of some kind of monopoly
>> where a few people rule everything (linux).
>
> I do remember when BSD shared some tuner code with GNU/LINUX ;)
>

there is nothing wrong with that.

As a reference:
* http://mcentral.de/wiki/index.php5/Terratec_HTC_XS
* http://corona.homeunix.net/cx88wiki

regards,
Markus
