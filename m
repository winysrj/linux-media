Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:63913 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759392AbZKZJh0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 04:37:26 -0500
Received: by mail-pz0-f171.google.com with SMTP id 1so434529pzk.33
        for <linux-media@vger.kernel.org>; Thu, 26 Nov 2009 01:37:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50104.115.70.135.213.1259224041.squirrel@webmail.exetel.com.au>
References: <33305.64.213.30.2.1259216241.squirrel@webmail.exetel.com.au>
	 <50104.115.70.135.213.1259224041.squirrel@webmail.exetel.com.au>
Date: Thu, 26 Nov 2009 20:37:33 +1100
Message-ID: <702870ef0911260137r35f1784exc27498d0db3769c2@mail.gmail.com>
Subject: Re: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1) tuning regression
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Robert Lowery <rglowery@exemail.com.au>
Cc: mchehab@redhat.com, terrywu2009@gmail.com, awalls@radix.net,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob

would you mind very much posting a patch that implements these two reversions,
so I can try it easily? My hg-fu is somewhat lacking...
I have the same hardware and noticed what I think is the same issue,
just with Channel 9.
Another manifestation is huge BER and nonzero REC in the output from 'tzap'.

Kind regards,
Vince


On 11/26/09, Robert Lowery <rglowery@exemail.com.au> wrote:
>> Hi,
>>
>> After fixing up a hang on the DViCO FusionHDTV DVB-T Dual Digital 4 (rev
>> 1) recently via http://linuxtv.org/hg/v4l-dvb/rev/1c11cb54f24d everything
>> appeared to be ok, but I have now noticed certain channels in Australia
>> are showing corruption which manifest themselves as blockiness and
>> screeching audio.
>>
>> I have traced this issue down to
>> http://linuxtv.org/hg/v4l-dvb/rev/e6a8672631a0 (Fix offset frequencies for
>> DVB @ 6MHz)
> Actually, in addition to the above changeset, I also had to revert
> http://linuxtv.org/hg/v4l-dvb/rev/966ce12c444d (Fix 7 MHz DVB-T)  to get
> things going.  Seems this one might have been an attempt to fix an issue
> introduced by the latter, but for me both must be reverted.
>
> -Rob
>
>>
>> In this change, the offset used by my card has been changed from 2750000
>> to 2250000.
>>
>> The old code which works used to do something like
>> offset = 2750000
>> if (((priv->cur_fw.type & DTV7) &&
>>     (priv->cur_fw.scode_table & (ZARLINK456 | DIBCOM52))) ||
>>     ((priv->cur_fw.type & DTV78) && freq < 470000000))
>>     offset -= 500000;
>>
>> In Australia, (type & DTV7) == true _BUT_ scode_table == 1<<29 == SCODE,
>> so the subtraction is not done.
>>
>> The new code which does not work does
>> if (priv->cur_fw.type & DTV7)
>>     offset = 2250000;
>> which appears to be off by 500khz causing the tuning regression for me.
>>
>> Could any one please advice why this check against scode_table &
>> (ZARLINK456 | DIBCOM52) was removed?
>>
>> Thanks
>>
>> -Rob
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
