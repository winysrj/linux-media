Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1KWtd1-0002as-Jo
	for linux-dvb@linuxtv.org; Sat, 23 Aug 2008 15:58:08 +0200
Received: by fk-out-0910.google.com with SMTP id f40so566854fka.1
	for <linux-dvb@linuxtv.org>; Sat, 23 Aug 2008 06:58:03 -0700 (PDT)
Message-ID: <48B01765.8020104@gmail.com>
Date: Sat, 23 Aug 2008 15:57:57 +0200
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48B00D6C.8080302@gmx.de>
In-Reply-To: <48B00D6C.8080302@gmx.de>
From: e9hack <e9hack@googlemail.com>
Subject: Re: [linux-dvb] Support of Nova S SE DVB card missing
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Eberhard Kaltenhaeuser schrieb:
> Actual kernel does not support the Hauppauge WinTV Nova S SE PCI card 
> anymore:
> 

I think it is a problem of this changeset http://linuxtv.org/hg/v4l-dvb/rev/358d281e6a3d 
from Patrick Boettcher. The S5H1420 isn't able to understand repeated start conditions. 
The i2c-read code was changed from:

	if ((ret = i2c_transfer (state->i2c, &msg1, 1)) != 1)
		return ret;

	if ((ret = i2c_transfer (state->i2c, &msg2, 1)) != 1)
		return ret;

to:
	if (state->config->repeated_start_workaround) {
		ret = i2c_transfer(state->i2c, msg, 3);
		if (ret != 3)
			return ret;
	} else {
		ret = i2c_transfer(state->i2c, &msg[1], 2);
		if (ret != 2)
			return ret;
	}

-Hartmut



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
