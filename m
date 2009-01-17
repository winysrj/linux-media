Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout05.t-online.de ([194.25.134.82]:58745 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758763AbZAQXKL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 18:10:11 -0500
Message-ID: <49726547.7020903@t-online.de>
Date: Sun, 18 Jan 2009 00:09:59 +0100
From: Detlef Rohde <rohde.d@t-online.de>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Jochen Friedrich <jochen@scram.de>, linux-media@vger.kernel.org,
	Roberto Ragusa <mail@robertoragusa.it>
Subject: Re: [PATCHv4] Add Freescale MC44S803 tuner driver
References: <496F9A1C.7040602@scram.de> <49722758.8030801@iki.fi>
In-Reply-To: <49722758.8030801@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi All,
I have to apologize being a stupid newbie not able to put Antti's latest 
source (mc44s803-71b0ef33303a) into my kernel (2.6.27-11-generic).
Have performed successfully a "make", but running "install" failed 
because of missed option settings for this operation. I am uncertain if 
I must set a path directory. Is'nt there a symbolic link to the right 
directory? "make" compiled lots of not needed stuff here, but my system 
needs only a firmware file:
(Copied from /var/log/messages)
Jan 17 23:22:21 detlef-laptop kernel: [  155.512517] dvb-usb: found a 
'TerraTec Cinergy T USB XE' in cold state, will try to load a firmware
Jan 17 23:22:21 detlef-laptop kernel: [  155.512530] firmware: 
requesting dvb-usb-af9015.fw
Jan 17 23:22:21 detlef-laptop kernel: [  155.526289] dvb_usb_af9015: 
probe of 4-3.3:1.0 failed with error -2

Maybe Antti can post me one which I simply can paste into /lib/firmware? 
Hopefully one of you can give an advice..
regards,
Detlef

Antti Palosaari schrieb: 2.6.27-11-generic
> Hello Jochen,
> I just reviewed this patch and here is my comments;
>
> Jochen Friedrich wrote:
>> +    buf[0] = (val & 0xFF0000) >> 16;
>
> I am not sure where it comes I have seen comments sometimes that we 
> should use lower case hex numbers.
>
>> +        return -EREMOTEIO;
> [...]
>> +    u8 ret, id;
>
> Error status (-EREMOTEIO) is stored to the u8, which leads ~254. This 
> seems not to be problem currently because mc44s803_readreg() is used 
> only in mc44s803_attach() that returns NULL in error case. Anyhow, I 
> think it would be better to use int for clarity.
>
> regards,
> Antti


