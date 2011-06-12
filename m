Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:51927 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab1FLWY6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 18:24:58 -0400
Message-ID: <4DF53CB6.109@iki.fi>
Date: Mon, 13 Jun 2011 01:24:54 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Juergen Lock <nox@jelal.kn-bremen.de>
CC: linux-media@vger.kernel.org, hselasky@c2i.net
Subject: Re: [PATCH] [media] af9015: setup rc keytable for LC-Power LC-USB-DVBT
References: <20110612202512.GA63911@triton8.kn-bremen.de> <201106122215.p5CMF0Xr069931@triton8.kn-bremen.de>
In-Reply-To: <201106122215.p5CMF0Xr069931@triton8.kn-bremen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/13/2011 01:15 AM, Juergen Lock wrote:
>> About the repeating bug you mention, are you using latest driver
>> version? I am not aware such bug. There have been this kind of incorrect
>> behaviour old driver versions which are using HID. It was coming from
>> wrong HID interval.
>>
>> Also you can dump remote codes out when setting debug=2 to
>> dvb_usb_af9015 module.
>
>   That doesn't seem to work here so maybe my version is really too old
> to have that fix.  (But the keytable patch should still apply I guess?)

Could you send af9015.c file you have I can check?

Your patch is OK, but I want to know why it repeats.


regards
Antti


-- 
http://palosaari.fi/
