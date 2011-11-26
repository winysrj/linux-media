Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:48035 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117Ab1KZOUt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 09:20:49 -0500
References: <4ED00072.7070702@gmail.com> <CAGoCfiwHoVs0JQXchw-gA+0tZ2+1_nnj8P1qsP4XR-81iQis5g@mail.gmail.com> <4ED0EA25.1020901@gmail.com>
In-Reply-To: <4ED0EA25.1020901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Hauppauge HVR-900 HD
From: Andy Walls <awalls@md.metrocast.net>
Date: Sat, 26 Nov 2011 09:20:50 -0500
To: Fredrik Lingvall <fredrik.lingvall@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Message-ID: <0ef2dae0-a014-4bcb-85c8-09c67fed156f@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fredrik Lingvall <fredrik.lingvall@gmail.com> wrote:

>On 11/25/11 23:14, Devin Heitmueller wrote:
>> On Fri, Nov 25, 2011 at 3:54 PM, Fredrik Lingvall
>> <fredrik.lingvall@gmail.com>  wrote:
>>> Hi All,
>>>
>>> I have a Hauppauge HVR-900 HD with ID 2040:b138. Is this device
>supported,
>>> and if so, which driver and firmware do I need?
>> Hi Frank,
>>
>> It's not currently supported under Linux as it uses a demodulator
>that
>> there is currently no driver for.  As far as I know, nobody's working
>> on it.
>>
>> Regards,
>>
>> Devin
>>
>Thanks for the info Devin. I had some hope since I found this page:
>
>  http://forum.ubuntu-it.org/index.php/topic,423395.5/wap2.html
>
>The dmesg output at least shows much more than I have been able to get 
>(I use 3.2.0-rc3 from the linuxtv git rep). They seem to be able to at 
>least load firmware into the device. It's in Italian so I don't 
>understand much of what they are discussing though.
>
>/Fredrik
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

On that page they seem to have the unit recognized and a configuration for the analog side of the unit.  They also mention a Silabs SI2165 DVB-T/-C demodulator which is obviously not supported.

Regards,
Andy
