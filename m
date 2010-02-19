Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39923 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab0BSQjt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 11:39:49 -0500
Received: by pwj8 with SMTP id 8so248739pwj.19
        for <linux-media@vger.kernel.org>; Fri, 19 Feb 2010 08:39:48 -0800 (PST)
Message-ID: <4B7EBECA.5020609@pelagicore.com>
Date: Fri, 19 Feb 2010 09:39:38 -0700
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	sameo@linux.intel.com
Subject: Re: [PATCH] mfd: Add timb-radio to the timberdale MFD
References: <4B7845F0.1070800@pelagicore.com> <4B7E7B75.3040205@redhat.com>
In-Reply-To: <4B7E7B75.3040205@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/19/2010 04:52 AM, Mauro Carvalho Chehab wrote:
> Richard Röjfors wrote:
>> This patch addes timb-radio to all configurations of the timberdale MFD.
>>
>> Connected to the FPGA is a TEF6862 tuner and a SAA7706H DSP, the I2C
>> board info of these devices is passed via the timb-radio platform data.
>
> Hi Richard,
>
> I'm trying to apply it to my git tree (http://git.linuxtv.org/v4l-dvb.git),
> but it is failing:

Ah, this patch was against your linux-next.git at kernel.org.

I will generate a new patch against the proper git.

--Richard
