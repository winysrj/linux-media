Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48159 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab2ETVMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 17:12:47 -0400
Received: by bkcji2 with SMTP id ji2so3435224bkc.19
        for <linux-media@vger.kernel.org>; Sun, 20 May 2012 14:12:46 -0700 (PDT)
Message-ID: <4FB95E4B.9090006@googlemail.com>
Date: Sun, 20 May 2012 23:12:43 +0200
From: Thomas Mair <thomas.mair86@googlemail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: poma <pomidorabelisima@gmail.com>, linux-media@vger.kernel.org
Subject: Re: rtl28xxu - rtl2832 frontend attach
References: <4FB92428.3080201@gmail.com> <4FB94F2C.4050905@iki.fi>
In-Reply-To: <4FB94F2C.4050905@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20.05.2012 22:08, Antti Palosaari wrote:
> On 20.05.2012 20:04, poma wrote:
>> After hard/cold boot:
> 
>> DVB: register adapter0/net0 @ minor: 2 (0x02)
>> rtl2832u_frontend_attach:
>> rtl28xxu_ctrl_msg: failed=-32
>> rtl28xxu_ctrl_msg: failed=-32
>> rtl28xxu_ctrl_msg: failed=-32
>> rtl28xxu_ctrl_msg: failed=-32
>> rtl28xxu_ctrl_msg: failed=-32
>> rtl28xxu_ctrl_msg: failed=-32
>> rtl28xxu_ctrl_msg: failed=-32
>> rtl28xxu_ctrl_msg: failed=-32
>> rtl28xxu_ctrl_msg: failed=-32
>> rtl28xxu_ctrl_msg: failed=-32
>> No compatible tuner found
> 
> These errors are coming from tuner probe. As it still goes to probing and did not jump out earlier when gate is opened it means that demod is answering commands but tuner are not.
> 
> My guess is that tuner is still on the reset or not powered at all. It is almost 100% sure error is wrong tuner GPIO.

There is an issue with GPIO, as FC0012 tuner callback will set 
the value of one of the GPIO outputs. However fixing that, will
not resolve the issue. So I need to debug the problem further.

Thanks for the bug report.

Regards
Thomas
