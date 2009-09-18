Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:39116 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbZIRTrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 15:47:37 -0400
Received: by fxm17 with SMTP id 17so942609fxm.37
        for <linux-media@vger.kernel.org>; Fri, 18 Sep 2009 12:47:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253303096.22947.2.camel@prometheus>
References: <1253298801.19044.5.camel@prometheus>
	 <829197380909181201w6ad9da3cide3c8825c421edfe@mail.gmail.com>
	 <1253303096.22947.2.camel@prometheus>
Date: Fri, 18 Sep 2009 15:47:40 -0400
Message-ID: <829197380909181247l5ff4e18eu55454da9310bd522@mail.gmail.com>
Subject: Re: Incorrectly detected em28xx device
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Matthias_Bl=E4sing?= <mblaesing@doppel-helix.eu>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/9/18 Matthias Bläsing <mblaesing@doppel-helix.eu>:
> Hey David,
>
> thanks for this very fast reply.
>
> Am Freitag, den 18.09.2009, 15:01 -0400 schrieb Devin Heitmueller:
>> 2009/9/18 Matthias Bläsing <mblaesing@doppel-helix.eu>:
>> > Hello,
>> >
>> > when I plugin my usb video grabber, it is misdetected (this email is the
>> > reaction to the request in the module output):
>> >
>> > [Syslog Entries]
>> >
>
>> The correct functionality can be accessed, when explicitly called with
>> > card=35 as paramter:
>> >
>> > [Syslog Entries]
>> >
>> > It would be very nice, if this could be auto-detected. If you need more information, please CC me.
>> >
>> > Greetings
>> >
>> > Matthias
>>
>> Hi Matthias,
>>
>> I fixed this a couple of months ago.  Just update to the latest v4l-dvb tree.
>
>
> will/was this be merged to the mainline kernel? I'm currently running
> the ubuntu build of 2.6.30 and am about to switch to 2.6.31.
>
> Thanks for the information so far.
>
> Matthias

It went into v4l-dvb on June 6th, and was submitted upstream to Linus
for 2.6.31 on June 16th.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
