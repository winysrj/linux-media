Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:47817 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZHILEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Aug 2009 07:04:15 -0400
Received: by ey-out-2122.google.com with SMTP id 9so741258eyd.37
        for <linux-media@vger.kernel.org>; Sun, 09 Aug 2009 04:04:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908091019.10222.hverkuil@xs4all.nl>
References: <1249753576.15160.251.camel@tux.localhost>
	 <208cbae30908081208o5a048fb0qdd6c356b0c6d3eb9@mail.gmail.com>
	 <4A7DDD1C.1030906@gmx.de> <200908091019.10222.hverkuil@xs4all.nl>
Date: Sun, 9 Aug 2009 15:04:15 +0400
Message-ID: <208cbae30908090404h3f03dc5fk10bfdc8ae3eb9f04@mail.gmail.com>
Subject: Re: [patch review 6/6] radio-mr800: redesign radio->users counter
From: Alexey Klimov <klimov.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: wk <handygewinnspiel@gmx.de>, Trent Piepho <xyzzy@speakeasy.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 9, 2009 at 12:19 PM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> On Saturday 08 August 2009 22:16:28 wk wrote:
>> Alexey Klimov schrieb:
>> > On Sat, Aug 8, 2009 at 10:01 PM, Trent Piepho<xyzzy@speakeasy.org> wrote:
>> >
>> >> On Sat, 8 Aug 2009, Alexey Klimov wrote:
>> >>
>> >>> Redesign radio->users counter. Don't allow more that 5 users on radio in
>> >>>
>> >> Why?
>> >>
>> >
>> > Well, v4l2 specs says that multiple opens are optional. Honestly, i
>> > think that five userspace applications open /dev/radio is enough. Btw,
>> > if too many userspace applications opened radio that means that
>> > something wrong happened in userspace. And driver can handle such
>> > situation by disallowing new open calls(returning EBUSY). I can't
>> > imagine user that runs more than five mplayers or gnomeradios, or
>> > kradios and so on.
>> >
>> > Am i totally wrong here?
>> >
>> > Thanks.
>> >
>
> Exactly. It's an artificial restriction that serves no purpose. Also
> remember that apps can open a radio device just to do e.g. a QUERYCAP
> or something like that. It does not necessarily has to be an mplayer
> or gnomeradio.
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

Ok, i'll update the patch.
Idea initially came in mind from gspca.c.

-- 
Best regards, Klimov Alexey
