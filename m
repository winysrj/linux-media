Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34392 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab0BTALA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 19:11:00 -0500
Received: by vws11 with SMTP id 11so232642vws.19
        for <linux-media@vger.kernel.org>; Fri, 19 Feb 2010 16:10:59 -0800 (PST)
Message-ID: <4B7F2890.30204@pelagicore.com>
Date: Fri, 19 Feb 2010 17:10:56 -0700
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	sameo@linux.intel.com
Subject: Re: [PATCH] mfd: Add timb-radio to the timberdale MFD
References: <4B7845F0.1070800@pelagicore.com> <4B7E7B75.3040205@redhat.com> <4B7F13B2.50804@pelagicore.com> <4B7F1711.6030303@xenotime.net>
In-Reply-To: <4B7F1711.6030303@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/19/2010 03:56 PM, Randy Dunlap wrote:
> On 02/19/10 14:41, Richard Röjfors wrote:
>> On 02/19/2010 04:52 AM, Mauro Carvalho Chehab wrote:
>>> Richard Röjfors wrote:
>>>> This patch addes timb-radio to all configurations of the timberdale MFD.
>>>>
>>>> Connected to the FPGA is a TEF6862 tuner and a SAA7706H DSP, the I2C
>>>> board info of these devices is passed via the timb-radio platform data.
>>>
>>> Hi Richard,
>>>
>>> I'm trying to apply it to my git tree
>>> (http://git.linuxtv.org/v4l-dvb.git),
>>> but it is failing:
>>
>> Hi Mauro,
>>
>> Right now my mail client, icedove, confuses me. Just upgraded to ver 3.
>> It seem to add in an extra space to lines not starting with a plus in
>> the patch.
>
> I had that problem with something called Thunderbird.  Perhaps you could
> use the hints in Documentation/email-clients.txt but change Thunderbird
> to icedove.  (?)

icedove is debians fork of thunderbird, so I think it's basically the
same client. So if people using it isn't aware of it I think we should
change it to Thunderbird/Icedove in the documentation

--Richard
