Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1522 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZCDKEU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 05:04:20 -0500
Message-ID: <28050.62.70.2.252.1236161035.squirrel@webmail.xs4all.nl>
Date: Wed, 4 Mar 2009 11:03:55 +0100 (CET)
Subject: Re: saa7134 and RDS
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: "hermann pitton" <hermann-pitton@arcor.de>,
	"Dmitri Belimov" <d.belimov@gmail.com>,
	"Hans J. Koch" <koch@hjk-az.de>,
	=?iso-8859-1?Q?Hans-J=C3=BCrgen_Koch?= <hjk@linutronix.de>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Wed, Mar 04, 2009 at 01:43:08AM +0100, hermann pitton wrote:
>> Hi,
>>
>> Am Montag, den 02.03.2009, 13:33 +0900 schrieb Dmitri Belimov:
>> > Hi All.
>> >
>> > I want use RDS on our TV cards. But now saa7134 not work with saa6588.
>> > I found this old patch from Hans J. Koch. Why this patch is not in
>> mercurial??
>> > Yes I know that patch for v4l ver.1 and for old kernel. But why not??
>> > v4l has other way for RDS on saa7134 boards?
>>
>> I think the patch got lost, because it was not clear who should pull it
>> in. Likely Hartmut or Mauro would have picked it up in 2006 if pinged
>> directly.
>
> The main reason was that at that time there was a conflict with the i2c
> ir keyboard driver. I couldn't fix it immediately and was occupied with
> different things afterwards. I don't know if saa7134 i2c got fixed
> in the meantime.
>
>>
>> Please try to work with Hans to get it in now. There was also a
>> suggestion to add a has_rds capability flag and about how to deal with
>> different RDS decoders later, IIRC.
>
> Right. We should have a flag you could set to something like
>   .has_rds = RDS_SAA6588
> so that the rds driver could be loaded automagically.
>
> But I'm afraid I cannot spend much time on this work ATM, sorry.
>
> Thanks,
> Hans

Dmitri,

I have a patch pending to fix this for the saa7134 driver. The i2c
problems are resolved, so this shouldn't be a problem anymore.

The one thing that is holding this back is that I first want to finalize
the RFC regarding the RDS support. I posted an RFC a few weeks ago, but I
need to make a second version and for that I need to do a bit of research
into the US version of RDS. And I haven't found the time to do that yet.

I'll see if I can get the patch merged anyway.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

