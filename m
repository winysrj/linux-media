Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:36659 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753868AbdLTJYk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 04:24:40 -0500
Received: by mail-it0-f46.google.com with SMTP id d16so6099490itj.1
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 01:24:40 -0800 (PST)
Received: from mail-it0-f42.google.com (mail-it0-f42.google.com. [209.85.214.42])
        by smtp.gmail.com with ESMTPSA id d186sm2405220itd.22.2017.12.20.01.24.38
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Dec 2017 01:24:38 -0800 (PST)
Received: by mail-it0-f42.google.com with SMTP id o130so10909838itg.0
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 01:24:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1513371751.3541.6.camel@ndufresne.ca>
References: <20171215075625.27028-1-acourbot@chromium.org> <1513371751.3541.6.camel@ndufresne.ca>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Wed, 20 Dec 2017 18:24:17 +0900
Message-ID: <CAPBb6MVYEEcx2KvauJR5szq=z0y3PVANxhGL7DW8XV3nG7vzJA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/9] media: base request API support
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 16, 2017 at 6:02 AM, Nicolas Dufresne <nicolas@ndufresne.ca> wr=
ote:
> Le vendredi 15 d=C3=A9cembre 2017 =C3=A0 16:56 +0900, Alexandre Courbot a=
 =C3=A9crit :
>> Here is a new attempt at the request API, following the UAPI we agreed o=
n in
>> Prague. Hopefully this can be used as the basis to move forward.
>>
>> This series only introduces the very basics of how requests work: alloca=
te a
>> request, queue buffers to it, queue the request itself, wait for it to c=
omplete,
>> reuse it. It does *not* yet use Hans' work with controls setting. I have
>> preferred to submit it this way for now as it allows us to concentrate o=
n the
>> basic request/buffer flow, which was harder to get properly than I initi=
ally
>> thought. I still have a gut feeling that it can be improved, with less b=
ack-and-
>> forth into drivers.
>>
>> Plugging in controls support should not be too hard a task (basically ju=
st apply
>> the saved controls when the request starts), and I am looking at it now.
>>
>> The resulting vim2m driver can be successfully used with requests, and m=
y tests
>> so far have been successful.
>>
>> There are still some rougher edges:
>>
>> * locking is currently quite coarse-grained
>> * too many #ifdef CONFIG_MEDIA_CONTROLLER in the code, as the request AP=
I
>>   depends on it - I plan to craft the headers so that it becomes unneces=
sary.
>>   As it is, some of the code will probably not even compile if
>>   CONFIG_MEDIA_CONTROLLER is not set
>>
>> But all in all I think the request flow should be clear and easy to revi=
ew, and
>> the possibility of custom queue and entity support implementations shoul=
d give
>> us the flexibility we need to support more specific use-cases (I expect =
the
>> generic implementations to be sufficient most of the time though).
>>
>> A very simple test program exercising this API is available here (don't =
forget
>> to adapt the /dev/media0 hardcoding):
>> https://gist.github.com/Gnurou/dbc3776ed97ea7d4ce6041ea15eb0438
>
> It looks like the example uses Hans control work you just mention.
> Notably, it uses v4l2_ext_controls ctrls.request.

Oops, I indeed forgot to remove that bit. You will want to edit that
line out if trying to compile.
