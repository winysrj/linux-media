Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47232 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab1HQR1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 13:27:13 -0400
Received: by ywf7 with SMTP id 7so920737ywf.19
        for <linux-media@vger.kernel.org>; Wed, 17 Aug 2011 10:27:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313597729.2672.11.camel@localhost>
References: <CAL9G6WUpso9FFUzC3WWiBZDqQDr-+HQFouCO_2V-zVHVyiyKeg@mail.gmail.com>
	<201108162227.00963.jareguero@telefonica.net>
	<4E4AD9B4.2040908@iki.fi>
	<201108170123.09647.jareguero@telefonica.net>
	<1313597729.2672.11.camel@localhost>
Date: Wed, 17 Aug 2011 19:27:11 +0200
Message-ID: <CAL9G6WVNx+dYFF+OeFK0uuJU04vnRaUSsCr1r=x5M+=+Cq6o2g@mail.gmail.com>
Subject: Re: Afatech AF9013
From: Josu Lazkano <josu.lazkano@gmail.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
	Jose Alberto Reguero <jareguero@telefonica.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/8/17 Malcolm Priestley <tvboxspy@gmail.com>:
> On Wed, 2011-08-17 at 01:23 +0200, Jose Alberto Reguero wrote:
>> On Martes, 16 de Agosto de 2011 22:57:24 Antti Palosaari escribió:
>> > On 08/16/2011 11:27 PM, Jose Alberto Reguero wrote:
>> > >> options dvb-usb force_pid_filter_usage=1
>> > >>
>> > >> I change the signal timeout and tuning timeout and now it works perfect!
>> > >>
>> > >> I can watch two HD channels, thanks for your help.
>> > >>
>> > >> I really don't understand what force_pid_filter_usage do on the
>> > >> module, is there any documentation?
>> > >>
>> > >> Thanks and best regards.
>> > >
>> > > For usb devices with usb 2.0 when tunned to a channel there is enought
>> > > usb bandwith to deliver the whole transponder. With pid filters they
>> > > only deliver the pids needed for the channel. The only limit is that the
>> > > pid filters is limited normaly to 32 pids.
>> >
>> > May I ask how wide DVB-T streams you have? Here in Finland it is about
>> > 22 Mbit/sec and I think two such streams should be too much for one USB
>> > bus. I suspect there is some other bug in back of this.
>> >
>> > regards
>> > Antti
>>
>> Here the transport stream is like yours. About 4 Mbit/sec by channel, and
>> about 5 channels by transport stream. The problem I have is that when I have
>> the two tuners working I have a few packets lost, and I have some TS
>> discontinuitys. With pid filters the stream is perfect. Perhaps Josu have
>> another problem.
>
> I am certain it is the configuration of the second frontend that ripples
> through Afatech devices.
>
> I have only got a single AF9015 device so can't test the dual
> configuration.
>
> Does the same problems exist when running the second frontend solo or
> dual with the Windows driver?
>
> With the IT1937(aka AF9035) the second frontend appeared not to work at
> all in Windows in dual mode.
>
> tvboxspy
>
>

Thanks Malcolm, sorry but I don't understand very good your post (my
poor english).

On Microsoft Windows XP the dual device works great, I can watch two
different channels (different transponder).

I want to know if there is an other command-line tool to test them,
because it will be MythTV playback problem.

The most problem is that sometimes one adapter work, then no adapter
work and then both adapter work but there is no clear image (pixeled).

How could I test if there is some packet drop?

Thanks for your great help.

Best regards.

-- 
Josu Lazkano
