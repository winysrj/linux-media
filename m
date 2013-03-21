Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:63327 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3CUET5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 00:19:57 -0400
Received: by mail-ve0-f178.google.com with SMTP id db10so2109228veb.9
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 21:19:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20130321T025536-528@post.gmane.org>
References: <1363329876-9021-1-git-send-email-arun.kk@samsung.com>
	<loom.20130321T025536-528@post.gmane.org>
Date: Thu, 21 Mar 2013 09:49:55 +0530
Message-ID: <CALt3h7-tGYPxnkaS=UOOeAn2sv=7thQK7f7pvjz7cv6BS6_z1w@mail.gmail.com>
Subject: Re: NACK: [PATCH] [media] s5p-mfc: Modify encoder buffer alloc sequence
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: John Sheu <sheu@google.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi John Sheu,

On Thu, Mar 21, 2013 at 7:30 AM, John Sheu <sheu@google.com> wrote:
> Arun Kumar K <arun.kk <at> samsung.com> writes:
>
>> MFC v6 needs minimum number of capture buffers to be queued
>> for encoder depending on the stream type and profile.
>> For achieving this the sequence for allocating buffers at
>> the encoder is modified similar to that of decoder.
>> The new sequence is as follows:
>>
>> 1) Set format on CAPTURE plane
>> 2) REQBUF on CAPTURE
>> 3) QBUFS and STREAMON on CAPTURE
>> 4) G_CTRL to get minimum buffers for OUTPUT plane
>> 5) REQBUF on OUTPUT with the minimum buffers given by driver
>
> NACK: the commit summary mentions the CAPTURE queue, but we're actually changing
> the OUTPUT queue allocation sequence.  Please fix.
>

Thanks for pointing out this mistake. Will correct it and post.
Is there any more Acks/ Nacks/ Comments on this?

Regards
Arun
