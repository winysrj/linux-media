Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55654 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab2IRIp4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 04:45:56 -0400
Received: by obbuo13 with SMTP id uo13so10131800obb.19
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2012 01:45:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiy4Ybymdd4Mym1JB3gwW9Suqdj3w6bEdMpxWWBHPhUvTQ@mail.gmail.com>
References: <CAAnFQG_SrXyr8MtPDujciE2=QRQK8dAK_SPBE3rC_c-XNSC00w@mail.gmail.com>
 <CAGoCfiy4Ybymdd4Mym1JB3gwW9Suqdj3w6bEdMpxWWBHPhUvTQ@mail.gmail.com>
From: Javier Marcet <jmarcet@gmail.com>
Date: Tue, 18 Sep 2012 10:45:35 +0200
Message-ID: <CAAnFQG_MMVU1uNvOQR1urrj8_KPEK3dJ=ZhKKTOS-GXpts-aCA@mail.gmail.com>
Subject: Re: Terratec Cinergy T PCIe Dual doesn;t work nder the Xen hypervisor
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 18, 2012 at 5:40 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:

>> Initially I thought Xen would be the cause of the problem, but after
>> having written on
>> the Xen development mailing list and talked about it with a couple
>> developers, it isn't
>> very clear where the problem is. So far I haven't been able to get the
>> smallest warning
>> or error.
>
> This is a very common problem when attempting to use any PCI/PCIe
> tuner under a hypervisor.  Essentially the issue is all of the
> virtualization solutions provide very poor interrupt latency, which
> results in the data being lost.
>
> Devices delivering a high bitrate stream of data in realtime are much
> more likely for this problem to be visible since such devices have
> very little buffering (it's not like a hard drive controller where it
> can just deliver the data slower).  The problem is not specific to the
> cx23885 - pretty much all of the PCI/PCIe bridges used in tuner cards
> work this way, and they cannot really be blamed for expecting to run
> in an environment with really crappy interrupt latency.
>
> I won't go as far as to say, "abandon all hope", but you're not really
> likely to find any help in this forum.

Well, it is not what I wanted to hear but at least I know for sure what is
happening.

I´ve post your words on the xen ml, I´ll see what they have to say.
I still don´t understand how graphics pass through works and a tuner
card has problems. I also have read reports of people running vdr on
a domU.

Anyway, thanks for the prompt and quick answer.


-- 
Javier Marcet <jmarcet@gmail.com>
