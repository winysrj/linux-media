Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:19590 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab0DQGoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Apr 2010 02:44:32 -0400
Received: by fg-out-1718.google.com with SMTP id 19so726751fgg.1
        for <linux-media@vger.kernel.org>; Fri, 16 Apr 2010 23:44:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <u2g829197381004161714z2f0b827eu824a3bcb17d2aa17@mail.gmail.com>
References: <4BC8F087.3050805@cogweb.net>
	 <u2g829197381004161714z2f0b827eu824a3bcb17d2aa17@mail.gmail.com>
Date: Sat, 17 Apr 2010 08:44:30 +0200
Message-ID: <g2w846899811004162344ib3c9223ek8bcef2df83e7f23b@mail.gmail.com>
Subject: Re: zvbi-atsc-cc device node conflict
From: HoP <jpetrous@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: David Liontooth <lionteeth@cogweb.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/4/17 Devin Heitmueller <dheitmueller@kernellabs.com>:
> On Fri, Apr 16, 2010 at 7:19 PM, David Liontooth <lionteeth@cogweb.net> wrote:
>> I'm using a HVR-1850 in digital mode and get good picture and sound using
>>
>>  mplayer -autosync 30 -cache 2048 dvb://KCAL-DT
>>
>> Closed captioning works flawlessly with this command:
>>
>> zvbi-atsc-cc -C test-cc.txt KCAL-DT
>>
>> However, if I try to run both at the same time, I get a device node
>> conflict:
>>
>>  zvbi-atsc-cc: Cannot open '/dev/dvb/adapter0/frontend0': Device or resource
>> busy.
>>
>> How do I get video and closed captioning at the same time?
>
> To my knowledge, you cannot run two userland apps streaming from the
> frontend at the same time.  Generally, when people need to do this
> sort of thing they write a userland daemon that multiplexes.
> Alternatively, you can cat the frontend to disk and then have both
> mplayer and your cc parser reading the resulting file.
>

Usually there is some way, for ex. command line option,
how to say to "second" app that frondend is already locked.
Then second app simply skips tuning at all.

Rest processing is made using demux and dvr devices,
so there is not reason why 2 apps should tune in same
time.

/Honza
