Return-path: <mchehab@pedra>
Received: from canardo.mork.no ([148.122.252.1]:50171 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701Ab1FCMuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 08:50:32 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Antti Palosaari <crope@iki.fi>
Cc: Steve Kerrison <steve@stevekerrison.com>,
	linux-media@vger.kernel.org
Subject: Re: [bug-report] unconditionally calling cxd2820r_get_tuner_i2c_adapter() from em28xx-dvb.c creates a hard module dependency
References: <87vcwpnavc.fsf@nemi.mork.no> <4DE60B36.9040507@iki.fi>
	<87mxi1n7ql.fsf@nemi.mork.no> <87tyc9lbb1.fsf@nemi.mork.no>
	<4DE8D1E6.4000300@iki.fi>
Date: Fri, 03 Jun 2011 14:50:25 +0200
In-Reply-To: <4DE8D1E6.4000300@iki.fi> (Antti Palosaari's message of "Fri, 03
	Jun 2011 15:21:58 +0300")
Message-ID: <87hb87xeni.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Antti Palosaari <crope@iki.fi> writes:

> There is some other FEs having also I2C adapter, I wonder how those
> handle this situation. I looked example from cx24123 and s5h1420
> drivers, both used by flexcop.
>
> Did you see what is magic used those devices?

None.  They have the same problem, creating hard module dependencies
even if they use dvb_attach() and CONFIG_MEDIA_ATTACH is set:

bjorn@canardo:~$ modinfo b2c2-flexcop
filename:       /lib/modules/2.6.32-5-amd64/kernel/drivers/media/dvb/b2c2/b2c2-flexcop.ko
license:        GPL
description:    B2C2 FlexcopII/II(b)/III digital TV receiver chip
author:         Patrick Boettcher <patrick.boettcher@desy.de
depends:        s5h1420,dvb-core,cx24113,cx24123,i2c-core
vermagic:       2.6.32-5-amd64 SMP mod_unload modversions 
parm:           debug:set debug level (1=info,2=tuner,4=i2c,8=ts,16=sram,32=reg (|-able)). (debugging is not enabled) (int)
parm:           adapter_nr:DVB adapter numbers (array of short)



This probably means that a generic i2c_tuner wrapper, similar to
dvb_attach, would be useful.



Bjørn
