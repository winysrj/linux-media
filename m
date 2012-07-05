Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610Ab2GEPkx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 11:40:53 -0400
Message-ID: <4FF5B581.2050900@redhat.com>
Date: Thu, 05 Jul 2012 12:40:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/3] [media] tuner-xc2028: Fix signal strength report
References: <1341497792-6066-1-git-send-email-mchehab@redhat.com> <1341497792-6066-2-git-send-email-mchehab@redhat.com> <CAGoCfixNj8CiSA8E1bDUg2+bUB9jq-pV7JuOht2QyT8NhK0=sA@mail.gmail.com> <CAGoCfiwBimUQzvAWEYuu8WWA50vEHpD2fMgcXhiJP1eB7nDSRg@mail.gmail.com>
In-Reply-To: <CAGoCfiwBimUQzvAWEYuu8WWA50vEHpD2fMgcXhiJP1eB7nDSRg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-07-2012 11:31, Devin Heitmueller escreveu:
> On Thu, Jul 5, 2012 at 10:25 AM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
>> On Thu, Jul 5, 2012 at 10:16 AM, Mauro Carvalho Chehab
>>> -       /* Use both frq_lock and signal to generate the result */
>>> -       signal = signal || ((signal & 0x07) << 12);
>>> +       /* Signal level is 3 bits only */
>>> +
>>> +       signal = ((1 << 12) - 1) | ((signal & 0x07) << 12);
>>
>> Are you sure this is correct?   It's entirely possible the original
>> code used a logical or because the signal level isn't valid unless
>> there is a lock.  The author may have been intending to say:
>>
>> if (signal != 0) /* There is a lock, so set the signal level */
>>    signal = (signal & 0x07) << 12;
>> else
>>    signal = 0 /* Leave signal level at zero since there is no lock */
>>
>> I agree that the way the original code was written is confusing, but
>> it may actually be correct.

No, the intention there were to do a bit OR. The idea there was that, 
if a lock was given, some signal would be received. The real signal
level would be identified by the remaining bits.

What it was happening due to the code mistake was:

if (lock)
	return 1;
else
	return 0;

> On second reading, it would have needed to be a logical AND, not an OR
> in order for my suggestion to have been correct.
> 
> That said, empirical results are definitely a stronger argument in
> this case.  You did test this change in cases with no signal, signal
> lock with weak signal, and signal lock with strong signal, right?

Yes, it was tested and the new code works fine: it returns 0 without signal
and it returns a value between 0 and 65535 depending on the signal strength.

Just like the DVB API, the V4L2 API spec is not clear about what type of
range should be applied for the signal (linea range? dB?). It just says
that it should be between 0 and 65555.

In the case of xc2028/3028, there are only 3 bits for signal strengh. The 
levels are in dB, with an 8dB step, where 0 means a signal weaker than 8dB 
and 7 means 56 dB or upper.

The code should now be coherent with that.

Regards,
Mauro
