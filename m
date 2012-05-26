Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61226 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2EZCrb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 22:47:31 -0400
Received: by weyu7 with SMTP id u7so919285wey.19
        for <linux-media@vger.kernel.org>; Fri, 25 May 2012 19:47:30 -0700 (PDT)
Message-ID: <4FC0443F.8030004@gmail.com>
Date: Sat, 26 May 2012 04:47:27 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: rtl28xxu - rtl2832 frontend attach
References: <4FB92428.3080201@gmail.com> <4FB94F2C.4050905@iki.fi> <4FB95E4B.9090006@googlemail.com>
In-Reply-To: <4FB95E4B.9090006@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/20/2012 11:12 PM, Thomas Mair wrote:
> On 20.05.2012 22:08, Antti Palosaari wrote:
>> On 20.05.2012 20:04, poma wrote:
>>> After hard/cold boot:
>>
>>> DVB: register adapter0/net0 @ minor: 2 (0x02)
>>> rtl2832u_frontend_attach:
>>> rtl28xxu_ctrl_msg: failed=-32
>>> rtl28xxu_ctrl_msg: failed=-32
>>> rtl28xxu_ctrl_msg: failed=-32
>>> rtl28xxu_ctrl_msg: failed=-32
>>> rtl28xxu_ctrl_msg: failed=-32
>>> rtl28xxu_ctrl_msg: failed=-32
>>> rtl28xxu_ctrl_msg: failed=-32
>>> rtl28xxu_ctrl_msg: failed=-32
>>> rtl28xxu_ctrl_msg: failed=-32
>>> rtl28xxu_ctrl_msg: failed=-32
>>> No compatible tuner found
>>
>> These errors are coming from tuner probe. As it still goes to probing and did not jump out earlier when gate is opened it means that demod is answering commands but tuner are not.
>>
>> My guess is that tuner is still on the reset or not powered at all. It is almost 100% sure error is wrong tuner GPIO.
> 
> There is an issue with GPIO, as FC0012 tuner callback will set 
> the value of one of the GPIO outputs. However fixing that, will
> not resolve the issue. So I need to debug the problem further.
> 
True. Whatever a value is changed - 'rtl2832u_power_ctrl', it brakes
even more.
Precisely, what breaks a tuner on next soft [re]boot are apps/utils
which engage tzap/scan[dvb].

· · · — — — · · ·

cheers,
poma
