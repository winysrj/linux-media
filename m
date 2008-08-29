Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 203.161.84.42.static.amnet.net.au ([203.161.84.42]
	helo=goeng.com.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tom@goeng.com.au>) id 1KYuyX-0006az-OS
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 05:48:42 +0200
From: "Thomas Goerke" <tom@goeng.com.au>
To: "'Devin Heitmueller'" <devin.heitmueller@gmail.com>
References: <004f01c90921$248fe2b0$6dafa810$@com.au>	
	<007f01c90965$344da360$9ce8ea20$@com.au>	
	<412bdbff0808281638h7e911b37n4d5043bf40b42d65@mail.gmail.com>	
	<008001c9096a$f315df10$d9419d30$@com.au>	
	<412bdbff0808281731t7641e4d1kf86058e071c7d5fb@mail.gmail.com>	
	<008101c90971$ca7e5080$5f7af180$@com.au>	
	<412bdbff0808281905w1a76f8eald99de203fd0c18be@mail.gmail.com>	
	<008201c90980$9b7ffd10$d27ff730$@com.au>	
	<412bdbff0808281950r48f40835w3f81f506c32eaff3@mail.gmail.com>	
	<008301c90987$866b3e60$9341bb20$@com.au>
	<412bdbff0808282043y572a74b4o69fdc71a956131f0@mail.gmail.com>
In-Reply-To: <412bdbff0808282043y572a74b4o69fdc71a956131f0@mail.gmail.com>
Date: Fri, 29 Aug 2008 11:49:12 +0800
Message-ID: <008401c9098a$35ccf090$a166d1b0$@com.au>
MIME-Version: 1.0
Content-Language: en-au
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge WinTV-NOVA-T-500 New Firmware
	(dvb-usb-dib0700-1.20.fw) causes problems
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

> 
> Thanks for doing this test.  I've done some additional reading which
> suggests the mt2060 has an extended history of flaky i2c behavior.
> Given that I don't have the hardware, I don't think I'm going to be
> able to debug it further.  I'm going to submit to have that device
> fall back to the legacy interface, so it shouldn't be any worse with
> 1.20, but at least it won't block other devices that use 1.20 from
> being committed.
> 
> Thanks,
> 
> Devin
> 
> 
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller

OK np.  For the time being I will roll back to the .10 firmware and use the
v4l-dvb tree.  I am not sure of then benefit of the .20 firmware as the .10
version has been very stable.

Let me know in the future if you want any additional testing.

Tom


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
