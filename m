Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48130 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab2E1G7D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 02:59:03 -0400
Received: by bkcji2 with SMTP id ji2so1947484bkc.19
        for <linux-media@vger.kernel.org>; Sun, 27 May 2012 23:59:01 -0700 (PDT)
Message-ID: <4FC32233.1040407@googlemail.com>
Date: Mon, 28 May 2012 08:58:59 +0200
From: Thomas Mair <thomas.mair86@googlemail.com>
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: rtl28xxu - rtl2832 frontend attach
References: <4FB92428.3080201@gmail.com> <4FB94F2C.4050905@iki.fi> <4FB95E4B.9090006@googlemail.com> <4FC0443F.8030004@gmail.com>
In-Reply-To: <4FC0443F.8030004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26.05.2012 04:47, poma wrote:
> On 05/20/2012 11:12 PM, Thomas Mair wrote:
>> On 20.05.2012 22:08, Antti Palosaari wrote:
>>> On 20.05.2012 20:04, poma wrote:
>>>> After hard/cold boot:
>>>
>>>> DVB: register adapter0/net0 @ minor: 2 (0x02)
>>>> rtl2832u_frontend_attach:
>>>> rtl28xxu_ctrl_msg: failed=-32
>>>> rtl28xxu_ctrl_msg: failed=-32
>>>> rtl28xxu_ctrl_msg: failed=-32
>>>> rtl28xxu_ctrl_msg: failed=-32
>>>> rtl28xxu_ctrl_msg: failed=-32
>>>> rtl28xxu_ctrl_msg: failed=-32
>>>> rtl28xxu_ctrl_msg: failed=-32
>>>> rtl28xxu_ctrl_msg: failed=-32
>>>> rtl28xxu_ctrl_msg: failed=-32
>>>> rtl28xxu_ctrl_msg: failed=-32
>>>> No compatible tuner found
>>>
>>> These errors are coming from tuner probe. As it still goes to probing and did not jump out earlier when gate is opened it means that demod is answering commands but tuner are not.
>>>
>>> My guess is that tuner is still on the reset or not powered at all. It is almost 100% sure error is wrong tuner GPIO.
>>
>> There is an issue with GPIO, as FC0012 tuner callback will set 
>> the value of one of the GPIO outputs. However fixing that, will
>> not resolve the issue. So I need to debug the problem further.
>>
> True. Whatever a value is changed - 'rtl2832u_power_ctrl', it brakes
> even more.
> Precisely, what breaks a tuner on next soft [re]boot are apps/utils
> which engage tzap/scan[dvb].
> 

To reproduce the bug it is not necessary to reboot the machine. Simply 
unload and load of the dvb_usb_rtl28xxu module will lead to the same 
situation.

I suspect, that when power is turned off, the tuner power is not 
switched on correctly. The mistake is not related to the OUTPUT_VAL
registers but probably to the OUTPUT_DIR or OUTPUT_EN registers.

What makes me wonder is if no tuning operation is performed before
reboot, the driver does work correctly after that, as poma already
noticed.

I have some spare time today and will investigate the problem further.

Regards 
Thomas


