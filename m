Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57188 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbcBGV0w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2016 16:26:52 -0500
Subject: Re: PCTV 292e weirdness
To: Rune Petersen <rune@megahurts.dk>,
	Russel Winder <russel@itzinteractive.com>,
	DVB_Linux_Media <linux-media@vger.kernel.org>
References: <1454523447.1970.15.camel@itzinteractive.com>
 <56B378F0.6020301@iki.fi> <1454612780.4401.66.camel@itzinteractive.com>
 <56B46E25.7070405@megahurts.dk>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <56B7B69A.4070306@iki.fi>
Date: Sun, 7 Feb 2016 23:26:50 +0200
MIME-Version: 1.0
In-Reply-To: <56B46E25.7070405@megahurts.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!
Sounds like device is loosing warm up power during suspend. On USB there 
is two callbacks to resume - resume() and reset_resume(). reset_resume() 
is called when power is lost and on normal case where power has not lost 
resume() is called.

I am not sure what kind of info there is available on I2C 
power-management - but it is one thing to check if there is also that 
same info available.

On power lost chip is reset to default - all registers and firmware also 
is lost. You have to catch that somehow. If I2C power management cannot 
provide that info you could use knowledge registers are set to some 
default value and make decision based of that.

regards
Antti


On 02/05/2016 11:40 AM, Rune Petersen wrote:
> (sent email again since I managed to reply only to Russel)
>
> I have the same issue - haven't had time to look into it much.
>
> the problem is that si2157 & si2168 doesn't resume properly from suspend.
>
> I have attached 2 patches that disable suspend.
>
> What i have found out:
> I can resume the si2157 from suspend by replacing "goto warm" with "goto
> skip_fw_download" in si2157_init()
>
> I can 'resume' the si2168 from suspend if I set "dev->fw_loaded = 0" in
> si2168_sleep()
>
>
> Rune
>
>
> On 04/02/16 20:06, Russel Winder wrote:
>> On Thu, 2016-02-04 at 18:14 +0200, Antti Palosaari wrote:
>> […]
>>>
>>> Are you using DVB-T, T2 or C? I quickly tested T and T2 with dvbv5-
>>> zap
>>> and it worked (kernel media 4.5.0-rc1+).
>>
>> Definitely T and T2. I had been assuming dvbv5-zap switched mode based
>> on the entry in the virtual channel file. In this case "BBC NEWS" is in
>> a T multiplex.
>>
>>> PCTV 282e seems to be dibcom based DVB-T only device, so you are
>>> using
>>> DVB-T?
>>
>> Yes, 282e is T only, ditto Terratec XXS. I haven't been able to get
>> anything working with WinTVSoloHD or WinTVdualHD as yet.
>>
>

-- 
http://palosaari.fi/
