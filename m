Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:32835 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab1FCM7O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2011 08:59:14 -0400
Message-ID: <4DE8DA9F.8050706@iki.fi>
Date: Fri, 03 Jun 2011 15:59:11 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: Steve Kerrison <steve@stevekerrison.com>,
	linux-media@vger.kernel.org
Subject: Re: [bug-report] unconditionally calling cxd2820r_get_tuner_i2c_adapter()
 from em28xx-dvb.c creates a hard module dependency
References: <87vcwpnavc.fsf@nemi.mork.no> <4DE60B36.9040507@iki.fi>	<87mxi1n7ql.fsf@nemi.mork.no> <87tyc9lbb1.fsf@nemi.mork.no>	<4DE8D1E6.4000300@iki.fi> <87hb87xeni.fsf@nemi.mork.no>
In-Reply-To: <87hb87xeni.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/03/2011 03:50 PM, Bjørn Mork wrote:
> Antti Palosaari<crope@iki.fi>  writes:
>
>> There is some other FEs having also I2C adapter, I wonder how those
>> handle this situation. I looked example from cx24123 and s5h1420
>> drivers, both used by flexcop.
>>
>> Did you see what is magic used those devices?
>
> None.  They have the same problem, creating hard module dependencies
> even if they use dvb_attach() and CONFIG_MEDIA_ATTACH is set:
>
> bjorn@canardo:~$ modinfo b2c2-flexcop
> filename:       /lib/modules/2.6.32-5-amd64/kernel/drivers/media/dvb/b2c2/b2c2-flexcop.ko
> license:        GPL
> description:    B2C2 FlexcopII/II(b)/III digital TV receiver chip
> author:         Patrick Boettcher<patrick.boettcher@desy.de
> depends:        s5h1420,dvb-core,cx24113,cx24123,i2c-core
> vermagic:       2.6.32-5-amd64 SMP mod_unload modversions
> parm:           debug:set debug level (1=info,2=tuner,4=i2c,8=ts,16=sram,32=reg (|-able)). (debugging is not enabled) (int)
> parm:           adapter_nr:DVB adapter numbers (array of short)
>
>
>
> This probably means that a generic i2c_tuner wrapper, similar to
> dvb_attach, would be useful.

For the cxd2820r it is also possible to return I2C adapter as pointer 
from dvb_attach like pointer to FE0 is carried for FE1 dvb_attach. What 
you think about that?

regards,
Antti

-- 
http://palosaari.fi/
