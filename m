Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4142 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbZJVWSV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2009 18:18:21 -0400
Message-ID: <3815ae099e769727cd4cb21abf338a18.squirrel@webmail.xs4all.nl>
Date: Fri, 23 Oct 2009 00:18:08 +0200
Subject: Re: Details about DVB frontend API
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Jean Delvare" <khali@linux-fr.org>,
	"LMML" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Em Thu, 22 Oct 2009 21:13:30 +0200
> Jean Delvare <khali@linux-fr.org> escreveu:
>
>> Hi folks,
>>
>> I am looking for details regarding the DVB frontend API. I've read
>> linux-dvb-api-1.0.0.pdf, it roughly explains what the FE_READ_BER,
>> FE_READ_SNR, FE_READ_SIGNAL_STRENGTH and FE_READ_UNCORRECTED_BLOCKS
>> commands return, however it does not give any information about how the
>> returned values should be interpreted (or, seen from the other end, how
>> the frontend kernel drivers should encode these values.) If there
>> documentation available that would explain this?
>>
>> For example, the signal strength. All I know so far is that this is a
>> 16-bit value. But then what? Do greater values represent stronger
>> signal or weaker signal? Are 0x0000 and 0xffff special values? Is the
>> returned value meaningful even when FE_HAS_SIGNAL is 0? When
>> FE_HAS_LOCK is 0? Is the scale linear, or do some values have
>> well-defined meanings, or is it arbitrary and each driver can have its
>> own scale? What are the typical use cases by user-space application for
>> this value?
>>
>> That's the kind of details I'd like to know, not only for the signal
>> strength, but also for the SNR, BER and UB. Without this information,
>> it seems a little difficult to have consistent frontend drivers.
>
> We all want to know about that ;)
>
> Seriously, the lack of a description of the meaning of the ranges for
> those
> read values were already widely discussed at LMML and at the legacy dvb
> ML.
> We should return this discussion again and decide what would be the better
> way to describe those values.
>
> My suggestion is that someone summarize the proposals we had and give some
> time
> for people vote. After that, we just commit the most voted one, and commit
> the
> patches for it. A pending question that should also be discussed is what
> we will
> do with those dvb devices where we simply don't know what scale it uses.
> There
> are several of them.
>
> Btw, the new official documentation is the media infrastructure docbook
> that
> can be found at the Kernel and at:
> 	http://linuxtv.org/downloads/v4l-dvb-apis
>
> This covers both DVB and V4L API's.

We did discuss this briefly during the v4l-dvb mini-summit and I know Mike
Krufky knew what to do about this, but for the life of me I can't remember
what it was. I should have made a note of it...

Mike, can you refresh my memory?

Thanks,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

