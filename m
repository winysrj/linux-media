Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:37391 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753269AbdLTJ1u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 04:27:50 -0500
Received: by mail-it0-f50.google.com with SMTP id d137so6097701itc.2
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 01:27:50 -0800 (PST)
Received: from mail-it0-f52.google.com (mail-it0-f52.google.com. [209.85.214.52])
        by smtp.gmail.com with ESMTPSA id 202sm2501994ioz.51.2017.12.20.01.27.49
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Dec 2017 01:27:49 -0800 (PST)
Received: by mail-it0-f52.google.com with SMTP id f143so6118267itb.0
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 01:27:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1513371884.3541.8.camel@ndufresne.ca>
References: <20171215075625.27028-1-acourbot@chromium.org> <1513371884.3541.8.camel@ndufresne.ca>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Wed, 20 Dec 2017 18:27:28 +0900
Message-ID: <CAPBb6MUubHGnQ+rR+b8qtbhN4PPu3zBDBpckb1-nobCUAXv-4w@mail.gmail.com>
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

On Sat, Dec 16, 2017 at 6:04 AM, Nicolas Dufresne <nicolas@ndufresne.ca> wr=
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
>
> Would it be possible to explain why this relation between request and
> the media controller ? Why couldn't request be created from video
> devices ?

Laurent replied on IRC, but for the record this is because the media
node can act as an orchestrator to the devices it manages. Some
devices may have particular needs in that respect, and we want to be
able to hook somewhere and control that.

Another reason is that in the future the media framework will probably
take more importance, to the point where you could control the whole
chain of devices through it instead of having to open every node
individually. This is a different topic though, and we only touched
the surface of it during the latest mini-summit.
