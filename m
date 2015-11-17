Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36748 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbbKQVnP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 16:43:15 -0500
Received: by igcph11 with SMTP id ph11so88679267igc.1
        for <linux-media@vger.kernel.org>; Tue, 17 Nov 2015 13:43:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <564B319D.7030706@xs4all.nl>
References: <CAJ2oMhLN1T5GL3OhdcOLpK=t74NpULTz4ezu=fZDOEaXYVoWdg@mail.gmail.com>
	<564ADD04.90700@xs4all.nl>
	<CAJ2oMh++Rhcvqs+nmCPRrTUmKkze69t1tJmK3KBRvhoBC6qYjg@mail.gmail.com>
	<564B319D.7030706@xs4all.nl>
Date: Tue, 17 Nov 2015 23:43:14 +0200
Message-ID: <CAJ2oMh+2Y69m2t_BmrUWu=uKk2Ohxx9ODMD+ZeJzo3E3-N6fFg@mail.gmail.com>
Subject: Re: cobalt & dma
From: Ran Shalit <ranshalit@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 17, 2015 at 3:54 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 11/17/15 14:15, Ran Shalit wrote:
>> On Tue, Nov 17, 2015 at 9:53 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> On 11/17/2015 08:39 AM, Ran Shalit wrote:
>>>> Hello,
>>>>
>>>> I intend to use cobalt driver as a refence for new pci v4l2 driver,
>>>> which is required to use several input simultaneously. for this cobalt
>>>> seems like a best starting point.
>>>> read/write streaming will probably be suffecient (at least for the
>>>> dirst debugging).
>>>> The configuration in my cast is i7 core <-- pci ---> fpga.
>>>> I see that the dma implementation is quite complex, and would like to
>>>> ask for some tips regarding the following points related to dma issue:
>>>>
>>>> 1. Is it possible to do the read/write without dma (for debug as start) ?
>>>
>>> No. All video capture/output devices all use DMA since it would be prohibitively
>>> expensive for the CPU to do otherwise. So just dig in and implement it.
>>>
>>
>> Hi,
>>
>> Is the cobalt or other pci v4l device have the chip datasheet
>> available so that we can do a reverse engineering and gain more
>> understanding about the register read/write for the dma transactions ?
>> I made a search but it seems that the PCIe chip datasheet for these
>> devices is not available anywhere.
>
> Sorry, no, it's not publicly available.
>
> But they all work along the same lines: each DMA descriptor has a
> PCI DMA address (where the data should be written to in memory), the length
> (bytes) of the DMA transfer and the pointer to the next DMA descriptor (chaining
> descriptors together). Finally there is some bit to trigger and interrupt when
> the full frame has been transferred.
>


Thank you all very much for all these valuable information !
I must admit that when I observe the source examples,
it seems quite complex, (at least much more complex than the driver I
am familiar with, which most of them time is taking a functional
example and understanding what to change and how, or writing simple
drivers.... )

If there are any other tips and ideas about debug/testing/development
steps when doing pci v4l device driver please tell me.

Thank you all very much,
Ran
