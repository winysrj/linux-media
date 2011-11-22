Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54532 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab1KVAnR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 19:43:17 -0500
Received: by wwe5 with SMTP id 5so11402019wwe.1
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 16:43:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ECAEB37.4040404@linuxtv.org>
References: <CAHFNz9KAi=XRZt=qM=KKnSKmmf_mn18JJAiUmd_5gXG71VBELA@mail.gmail.com>
	<4ECAEB37.4040404@linuxtv.org>
Date: Tue, 22 Nov 2011 06:13:16 +0530
Message-ID: <CAHFNz9LfMc3LTOscX9=Wtpsj5DtL-k9fgKnWzqw5NnLgHRZq6A@mail.gmail.com>
Subject: Re: PATCH 00/13: Enumerate DVB frontend Delivery System capabilities
 to identify devices correctly.
From: Manu Abraham <abraham.manu@gmail.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 22, 2011 at 5:52 AM, Andreas Oberritter <obi@linuxtv.org> wrote:
> On 21.11.2011 22:05, Manu Abraham wrote:
>> Hi,
>>
>> As discussed prior, the following changes help to advertise a
>> frontend's delivery system capabilities.
>>
>> Sending out the patches as they are being worked out.
>>
>> The following patch series are applied against media_tree.git
>> after the following commit
>
> Patches 7, 9 and 10 semm to be unneeded, because they just set the defaults.
>

cx24116 AFAIR handles dss, but no code exists in the driver to handle the same.
ds3000, I have no clue
tda10071, is a derivative of the CX demods and likely supports DSS,
just like the ST ones.
but that said no code exists in the driver.

As you state, yes, it is pointless to have these 3 patches, but then I
thought maybe if someone adds in DSS it would be okay. DSS hasn't been
added to most frontends for the reasons

- earlier there was no support from the frontend API
- need to handle it with demux as well.

Well, anyway patch exists, so anyone can add it in later if they need
when adding support to the driver.

> Regarding the patches adding SYS_DSS: If I remember correctly, DSS
> doesn't use MPEG-2 TS packets. Do we have a way to deliver DSS payload
> to userspace?

Yes, even the SYNC is different, length is different too. Somebody
wrote a parser a while back. But nothing happened on that front due to
the mentioned 2 reasons.

there are 2 options,

- send the captured packets as it is to userspace
- based on delivery system (dvb-s2 has generic streams as well, other
than MPEG2-TS, didn't look at dvb-t2, most likely the same option
exists there as well), look for sync and length, send packets to
userspace.

Regards,
Manu
