Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:45562 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbbBWLVe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 06:21:34 -0500
Received: by mail-ob0-f176.google.com with SMTP id wo20so35783618obc.7
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2015 03:21:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54EB016D.8040105@grumpydevil.homelinux.org>
References: <54E8F8F4.1010601@grumpydevil.homelinux.org>
	<54E9F59A.4070407@grumpydevil.homelinux.org>
	<CAJbz7-2efvftG4=UAphyLFjjuFpLZQKCFDzqXrwb-mfDg4A7SQ@mail.gmail.com>
	<54EB016D.8040105@grumpydevil.homelinux.org>
Date: Mon, 23 Feb 2015 12:21:33 +0100
Message-ID: <CAJbz7-0U-s543mQ+a+sNt1V2m8T23X=ST5VYJ7LF0tk-n_yd8g@mail.gmail.com>
Subject: Re: DVB Simulcrypt
From: =?UTF-8?Q?Honza_Petrou=C5=A1?= <jpetrous@gmail.com>
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-02-23 11:31 GMT+01:00 Rudy Zijlstra <rudy@grumpydevil.homelinux.org>:
> On 23-02-15 08:44, Honza Petrouš wrote:
>
> Hi Rudy.
>
> 2015-02-22 16:28 GMT+01:00 Rudy Zijlstra <rudy@grumpydevil.homelinux.org>:
>>
>> Some more info
>>
>> On 21-02-15 22:30, Rudy Zijlstra wrote:
>>>
>>> Dears (Hans?)
>>>
>>> My setup, where the cable operator was using only irdeto, was working
>>> good. Then the cable operator merged with another, and now the networks are
>>> being merged. As a result, the encryption has moved from irdeto only to
>>> simulcyrpt with Irdeto and Nagra.
>>>
>>> Current status:
>>> - when i put the CA card in a STB, it works
>>> - when trying to record an encrypted channel from PC, it no longer works.
>>
>> Recording system has 3 tuners. All equal, all with same permissions on the
>> smartcard. On cards 0 and 2 does not work, but card 1 does work, on all
>> channels tested.
>>
>
> Does it mean that descrambling is not working for you? If so,
> how do you manage descrambling? By CI-CAM module
> or by some "softcam" like oscam?
>
> Or do you record ENCRYPTED stream and decrypt the recordings
> later on?
>
>
> Each tuner has its own legal CI-CAM module. And yes, except for the second
> tuner descrambling no longer works
>

I'm not much familiar with MythTV, so I'm guessing from the mux setup changes,
but did you check to descramble the same channel on different tuners?
To eliminate
the particular change inside one service only.

Of course there can be also software issue in CI-CAM module itself
(fail in parsing
PMT CA descriptors etc).

TBH, I think it must be application layer issue, not kernel one.

/Honza
