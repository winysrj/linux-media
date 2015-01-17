Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:59534 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbbAQN1G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2015 08:27:06 -0500
Received: by mail-ie0-f180.google.com with SMTP id rp18so24989101iec.11
        for <linux-media@vger.kernel.org>; Sat, 17 Jan 2015 05:27:04 -0800 (PST)
Received: from mail-ig0-f182.google.com (mail-ig0-f182.google.com. [209.85.213.182])
        by mx.google.com with ESMTPSA id g20sm3103740igt.14.2015.01.17.05.27.03
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 17 Jan 2015 05:27:03 -0800 (PST)
Received: by mail-ig0-f182.google.com with SMTP id hn15so7308363igb.3
        for <linux-media@vger.kernel.org>; Sat, 17 Jan 2015 05:27:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150117102339.5c224564@pirotess.bf.iodev.co.uk>
References: <1419184727-11224-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<54B8EE13.6010508@xs4all.nl>
	<20150117102339.5c224564@pirotess.bf.iodev.co.uk>
Date: Sat, 17 Jan 2015 14:27:03 +0100
Message-ID: <CAKXHbyNjd2X9A9OZ16oRu-ud3A8373jDOR5dCevD1mp+YFf-yQ@mail.gmail.com>
Subject: Re: [PATCH] media: pci: solo6x10: solo6x10-enc.c: Remove unused function
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ismael Luceno <ismael.luceno@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-01-17 14:23 GMT+01:00 Ismael Luceno <ismael.luceno@gmail.com>:
> On Fri, 16 Jan 2015 11:55:15 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> (resent with correct email address for Ismael)
>>
>> Ismael, Andrey,
>>
>> Can you take a look at this? Shouldn't solo_s_jpeg_qp() be hooked up
>> to something?
>
> The feature was never implemented, so yes, and we should keep it around.


Hi

But maybe add a comment then?

Kind regards
Rickard Strandqvist
