Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49272 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab1KZNbW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 08:31:22 -0500
Received: by faas1 with SMTP id s1so2460120faa.19
        for <linux-media@vger.kernel.org>; Sat, 26 Nov 2011 05:31:20 -0800 (PST)
Message-ID: <4ED0EA25.1020901@gmail.com>
Date: Sat, 26 Nov 2011 14:31:17 +0100
From: Fredrik Lingvall <fredrik.lingvall@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-900 HD
References: <4ED00072.7070702@gmail.com> <CAGoCfiwHoVs0JQXchw-gA+0tZ2+1_nnj8P1qsP4XR-81iQis5g@mail.gmail.com>
In-Reply-To: <CAGoCfiwHoVs0JQXchw-gA+0tZ2+1_nnj8P1qsP4XR-81iQis5g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/25/11 23:14, Devin Heitmueller wrote:
> On Fri, Nov 25, 2011 at 3:54 PM, Fredrik Lingvall
> <fredrik.lingvall@gmail.com>  wrote:
>> Hi All,
>>
>> I have a Hauppauge HVR-900 HD with ID 2040:b138. Is this device supported,
>> and if so, which driver and firmware do I need?
> Hi Frank,
>
> It's not currently supported under Linux as it uses a demodulator that
> there is currently no driver for.  As far as I know, nobody's working
> on it.
>
> Regards,
>
> Devin
>
Thanks for the info Devin. I had some hope since I found this page:

  http://forum.ubuntu-it.org/index.php/topic,423395.5/wap2.html

The dmesg output at least shows much more than I have been able to get 
(I use 3.2.0-rc3 from the linuxtv git rep). They seem to be able to at 
least load firmware into the device. It's in Italian so I don't 
understand much of what they are discussing though.

/Fredrik
