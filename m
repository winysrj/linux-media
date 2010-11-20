Return-path: <mchehab@gaivota>
Received: from ns1.tyldum.com ([91.189.178.231]:49962 "EHLO ns1.tyldum.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab0KTSYe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Nov 2010 13:24:34 -0500
Received: from [192.168.168.91] (unknown [192.168.168.91])
	by ns1.tyldum.com (Postfix) with ESMTP id 5AA8924C0A5
	for <linux-media@vger.kernel.org>; Sat, 20 Nov 2010 19:14:58 +0100 (CET)
Message-ID: <4CE8101E.4040708@tyldum.com>
Date: Sat, 20 Nov 2010 19:14:54 +0100
From: Vidar Tyldum <vidar@tyldum.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: mantis crashes
References: <20100413150153.GB11631@mail.tyldum.com> <87ochne35i.fsf@nemi.mork.no> <20100413165616.GC11631@mail.tyldum.com> <loom.20100414T133315-652@post.gmane.org> <20100417054749.GA6067@mail.tyldum.com> <87aat1dc9r.fsf@nemi.mork.no> <20100418045106.GA7741@mail.tyldum.com> <loom.20100821T210808-680@post.gmane.org> <4C7C9AE2.3060509@tyldum.com>
In-Reply-To: <4C7C9AE2.3060509@tyldum.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Den 31.08.2010 08:02, Vidar Tyldum:
> Den 21.08.2010 21:11, skrev Hans van den Bogert:
>> Vidar Tyldum Hansen <vidar <at> tyldum.com> writes:
>>
>>> So now I will revert to stock Lucid kernel and give your patch a go. But
>>> I have a feeling this has something might be some incompatibility or bug
>>> between the card and the motherboard (Asus P5N7A-VM). This, though is
>>> beyond me...
>>>
>>
>> Late reply, but
>> Probably is nvidia/bios/asus incompatibility, I used a M3N78-pro

And for the record, ditching the Asus P5N7A-VM fixed the problem in the end.

-- 
Vidar Tyldum
                              vidar@tyldum.com               PGP: 0x3110AA98
