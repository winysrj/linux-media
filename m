Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:44648 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753091AbeEGVRc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 17:17:32 -0400
MIME-Version: 1.0
In-Reply-To: <36e4effa-135d-daeb-1abb-f55500a9dfee@xs4all.nl>
References: <20180424204158.2764095-1-arnd@arndb.de> <20180425061537.GA23383@infradead.org>
 <CAK8P3a06ragAPWpHGm-bGoZ8t6QyAttWJfD0jU_wcGy7FqLb5w@mail.gmail.com>
 <20180425072138.GA16375@infradead.org> <CAK8P3a1cs_SPesadAQhV3QU97WjNE8bLPSQCfaMQRU7zr_oh3w@mail.gmail.com>
 <20180425152636.GC27076@infradead.org> <CAK8P3a0CHSC7yP3x8xDJgcg5xMzD1-sC-rmBJECtYvGFmyG4vQ@mail.gmail.com>
 <20180425142229.25d756ed@vento.lan> <36e4effa-135d-daeb-1abb-f55500a9dfee@xs4all.nl>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 7 May 2018 17:17:31 -0400
Message-ID: <CAK8P3a2Pfo+MDYC=TMnOdhhRsYLDojbTGD+Wu9MrEX9VLY9sVA@mail.gmail.com>
Subject: Re: [PATCH] media: zoran: move to dma-mapping interface
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        mjpeg-users@lists.sourceforge.net,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Trent Piepho <tpiepho@impinj.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 7, 2018 at 5:05 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 25/04/18 19:22, Mauro Carvalho Chehab wrote:
>> Em Wed, 25 Apr 2018 17:58:25 +0200
>> Arnd Bergmann <arnd@arndb.de> escreveu:
>>
>>> On Wed, Apr 25, 2018 at 5:26 PM, Christoph Hellwig <hch@infradead.org> wrote:
>>>> On Wed, Apr 25, 2018 at 01:15:18PM +0200, Arnd Bergmann wrote:
>>>>> That thought had occurred to me as well. I removed the oldest ISDN
>>>>> drivers already some years ago, and the OSS sound drivers
>>>>> got removed as well, and comedi got converted to the dma-mapping
>>>>> interfaces, so there isn't much left at all now. This is what we
>>>>> have as of v4.17-rc1:
>>>>
>>>> Yes, I've been looking at various grotty old bits to purge.  Usually
>>>> I've been looking for some non-tree wide patches and CCed the last
>>>> active people to see if they care.  In a few cases people do, but
>>>> most often no one does.
>>>
>>> Let's start with this one (zoran) then, as Mauro is keen on having
>>> all media drivers compile-testable on x86-64 and arm.
>>>
>>> Trent Piepho and Hans Verkuil both worked on this driver in the
>>> 2008/2009 timeframe and those were the last commits from anyone
>>> who appears to have tested their patches on actual hardware.
>>
>> Zoran is a driver for old hardware. I don't doubt that are people
>> out there still using it, but who knows?
>>
>> I have a few those boards packed somewhere. I haven't work with PCI
>> hardware for a while. If needed, I can try to seek for them and
>> do some tests. I need first to unpack a machine with PCI slots...
>> the NUCs I generally use for development don't have any :-)
>>
>> Anyway, except for virt_to_bus() and related stuff, I think that this
>> driver is in good shape, as Hans did a lot of work in the past to
>> make it to use the current media framework.
>>
>>>
>>> Trent, Hans: do you have reason to believe that there might still
>>> be users out there?
>
> I have no way of knowing this. However, I think they are easily replaced
> by much cheaper USB alternatives today.
>
> I did some work on the zoran driver several years ago, but it doesn't use
> the vb2 framework (and not even the older vb1 framework!) so I'm sure there
> are all sorts of bugs in that driver.
>
> Personally I would be fine with moving this driver to staging and removing
> it by, say, the end of the year.
>
> Nobody is going to work on it and I think it is time to retire it.

Based on the link to the old discussed that Bernhard provided, it
seems that the driver was already in a barely usable state 5 years
ago (the remaining users decided to use an even older 2.6 kernel instead),
and nobody has worked on fixing it since, so moving it to staging or
immediately removing it would both seem appropriate.

        Arnd
