Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36003 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbbH1Og0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 10:36:26 -0400
Received: by ioej130 with SMTP id j130so12710714ioe.3
        for <linux-media@vger.kernel.org>; Fri, 28 Aug 2015 07:36:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55E060DF.3030202@xs4all.nl>
References: <55D730F4.80100@xs4all.nl>
	<CAPybu_2hn8LuKy-n74cpQ1UOFvxgTv8SmXka6PwPY+U1XnZeDg@mail.gmail.com>
	<55D85325.80607@xs4all.nl>
	<CALzAhNVSY=yDWFk1fZnibOuThGW3J_s0sTQNhGGN8z1_U_regw@mail.gmail.com>
	<55D86F3C.6090004@xs4all.nl>
	<CALzAhNWhu-w+3x6S-_0ToAUAzELZSuQqo7q5NmpxXfCdciY0hw@mail.gmail.com>
	<55DDBB73.5010902@xs4all.nl>
	<CALzAhNVxrWOsU72jin4_ygwazX2cnqBaMoPGZ_Kv77xgGx7KmA@mail.gmail.com>
	<55E014E6.5000801@xs4all.nl>
	<CALzAhNUMN6BhNZQgGE57-ujoi2O1-baVW_AWFYep7Xd0b4Okrg@mail.gmail.com>
	<55E060DF.3030202@xs4all.nl>
Date: Fri, 28 Aug 2015 10:36:25 -0400
Message-ID: <CALzAhNX6WhY4HO=V=72Atp6o67HJQh2AAhbq4C0HpnG0dScu1Q@mail.gmail.com>
Subject: Re: [PATCH] saa7164: convert to the control framework
From: Steven Toth <stoth@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>> but the default firmware with size 4919072 fails to work (image corrupt), instead
>>> I need to use the firmware with size 4038864 (v4l-saa7164-1.0.3-3.fw).
>>>
>>> For that I have to patch the driver.
>>
>> Take a look at your board, on the main large PCIe IC, its probably
>> marked as either a REV2 or a REV3, or a -02 or -03, what do you have?
>>
>> I suspect you have a rev-02 chip. Not many of them go out into
>> production. (A few thousand, compared to significantly more -03
>> chips).
>
> The text on the chip is:
>
> SAA7164E/2
> P60962.00       10
> ESG07271Y
>
> I suspect the /2 means REV2.

Correct, thanks for confirming. I'll look into this.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
