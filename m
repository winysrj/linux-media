Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:42812 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbbBPPYZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 10:24:25 -0500
Received: by mail-qc0-f182.google.com with SMTP id r5so10919013qcx.13
        for <linux-media@vger.kernel.org>; Mon, 16 Feb 2015 07:24:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54E202C5.7070904@xs4all.nl>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
	<5c8a3752af88ba4c349d9d2416cad937f96a0423.1423867976.git.mchehab@osg.samsung.com>
	<54E1B3F0.7060807@xs4all.nl>
	<20150216085925.3b52a558@recife.lan>
	<CAGoCfiy+te9GRt=xPrHmUe+ckeO2X0u3XmJC77BSQG6VJ_aEFw@mail.gmail.com>
	<54E202C5.7070904@xs4all.nl>
Date: Mon, 16 Feb 2015 10:24:24 -0500
Message-ID: <CAGoCfiy5Obec7OZXjEsO0kEcDSOVLdkzX+qQYVjDf9wtkGR2Ew@mail.gmail.com>
Subject: Re: [PATCHv4 15/25] [media] tuner-core: properly initialize media
 controller subdev
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Feb 16, 2015 at 9:46 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 02/16/2015 03:39 PM, Devin Heitmueller wrote:
>>> Except for PVR-500, I can't remember any case where the same tuner is used
>>> more than once.
>>>
>>> There is the case of a device with two tuners, one for TV and another one
>>> for FM. Yet, on such case, the name of the FM tuner will be different,
>>> anyway. So, I don't think this is a current issue, but if the name should
>>> be unique, then we need to properly document it.
>>
>> Perhaps I've misunderstood the comment, but HVR-2200/2250 and numerous
>> dib0700 designs are dual DVB tuners.  Neither are like the PVR-500 in
>> that they are a single entity with two tuners (as opposed to the
>> PVR-500 which is two PCI devices which happen to be on the same PCB).
>
> DVB, yes, but not analog (V4L2) tuners. For DVB tuners the frontend name
> is used as the entity name, which I assumed is unique. It is, right? If
> that's not unique, then the same issue is there as well. I have ordered
> a dual DVB-T board, but I won't have that for another two weeks.

Sorry, I thought this patch was related to the DVB tuner subdev -
didn't realize it was for tuner-core (which is obviously analog).

The HVR-2200/2250 is a single board with dual hybrid tuners (model
2200 has a DVB-T demod and 2250 has an ATSC demod).  In other words,
it has two tuners, each of which can be independently tuned to either
digital or analog signals.  And unlike the PVR-500, it's a single PCIe
bridge (saa7164).

Regarding your question on DVB tuners, yes - each tuner gets its own
frontendX device node (in reality the frontendX points to the digital
demodulator, but ultimately it passes the tuning request off to the
tuner as well).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
