Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:51493 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab0BCMhU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 07:37:20 -0500
Received: by fxm7 with SMTP id 7so1459272fxm.28
        for <linux-media@vger.kernel.org>; Wed, 03 Feb 2010 04:37:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <dd5e898cb64e7f76edfc36d263ba12aa.squirrel@webmail.xs4all.nl>
References: <4B1E1974.6000207@jusst.de> <4B1E532C.9040903@redhat.com>
	 <4B6946A3.9080803@redhat.com>
	 <dd5e898cb64e7f76edfc36d263ba12aa.squirrel@webmail.xs4all.nl>
Date: Wed, 3 Feb 2010 16:37:19 +0400
Message-ID: <1a297b361002030437u2d8dab49qf7a2d835e5809b1@mail.gmail.com>
Subject: Re: New DVB-Statistics API - please vote
From: Manu Abraham <abraham.manu@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Julian Scheel <julian@jusst.de>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 3, 2010 at 2:40 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> Mauro Carvalho Chehab wrote:
>>
>>>> after the last thread which asked about signal statistics details
>>>> degenerated into a discussion about the technical possibilites for
>>>> implementing an entirely new API, which lead to nothing so far, I
>>>> wanted
>>>> to open a new thread to bring this forward. Maybe some more people can
>>>> give their votes for the different options
>>
>> Only me and Manu manifested with opinions on this thread. Not sure why
>> nobody else gave their comments. Maybe all interested people just decided
>> to take a long vacation and are not listening to their emails ;)
>>
>> Seriously, from what I understand, this is an API improvement and we need
>> to take a decision on it. So, your opinions are important.
>>
>> ---
>>
>> Let me draw a summary of this subject, trying to be impartial.
>>
>> The original proposal were made by Manu. My proposal is derived from
>> Manu's
>> original one, both will equally provide the same features.
>>
>> The main difference is that Manu's proposal use a struct to get the
>> statistics while my proposal uses DVBS2API.
>>
>> With both API proposals, all values are get at the same time by the
>> driver.
>> the DVBS2API adds a small delay to fill the fields, but the extra delay is
>> insignificant, when compared with the I/O delays needed to retrieve the
>> values from the hardware.
>>
>> Due to the usage of DVBS2API, it is possible to retrieve a subset of
>> statistics.
>> When obtaining a subset, the DVBS2API latency is considerable faster, as
>> less
>> data needed to be transfered from the hardware.
>>
>> The DVBS2API also offers the possibility of expanding the statistics
>> group, since
>> it is not rigid as an struct.
>>
>> One criteria that should be reminded is that, according with Linux Kernel
>> rules,
>> any userspace API is stable. This means that applications compiled against
>> an
>> older API version should keep running with the latest kernel. So, whatever
>> decided,
>> the statistics API should always maintain backward compatibility.
>>
>> ---
>>
>> During the end of the year, I did some work with an ISDB-T driver for
>> Siano, and
>> I realized that the usage of the proposed struct won't fit well for
>> ISDB-T. The
>> reason is that, on ISDB-T, the transmission uses up to 3 hierarchical
>> layers.
>> Each layer may have different OFDM parameters, so the devices (at least,
>> this is the
>> case for Siano) has a group of statistics per layer.
>>
>> I'm afraid that newer standards may also bring different ways to present
>> statistics, and
>> the current proposal won't fit well.
>>
>> So, in my opinion, if it is chosen any struct-based approach, we'll have a
>> bad time to
>> maintain it, as it won't fit into all cases, and we'll need to add some
>> tricks to extend
>> the struct.
>>
>> So, my vote is for the DVBS2API approach, where a new group of statistics
>> can easily be added,
>> on an elegant way, without needing of re-discussing the better API or to
>> find a way to extend
>> the size of an struct without breaking backward compatibility.
>
> From a purely technical standpoint the DVBS2API is by definition more
> flexible and future-proof. The V4L API has taken the same approach with
> controls (basically exactly the same mechanism). Should it be necessary in
> the future to set multiple properties atomically, then the same technique
> as V4L can be used (see VIDIOC_S_EXT_CTRLS).
>
> The alternative is to make structs with lots of reserved fields. It
> depends on how predictable the API is expected to be. Sometimes you can be
> reasonably certain that there won't be too many additions in the future
> and then using reserved fields is perfectly OK.
>
> Just my 5 cents based on my V4L experience.


In fact, I don't see the advantage using a specific get/set, since
what i proposed just reads back basic data types such as a u32 for any
instance and those being "standard " for any digital communication
system. It makes no sense to go for a get/set approach. For example
there cannot be multiple properties for any digital system such as
BER, just that there are different measure s such as kilograms,
pounds, grams etc. Which is what the whole patch is meant to do in a
performance critical manner.
The whole patch is a kind of get/set and and hence it doesn't need a
get/set at the micro level.

To contradict the reverse, as an example, I can state that weight is
not measured in centimeters or inches or feet, to put it in laymans
terms. if you say that it needs to be expressed as such,  then i very
well see that there is something conceptually wrong in your thought.

My 2 cents, for those who don't understand the issue.

Regards,
Manu
