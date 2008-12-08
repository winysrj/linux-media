Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1L9mcC-0004VA-4s
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 21:22:01 +0100
Received: by nf-out-0910.google.com with SMTP id g13so695313nfb.11
	for <linux-dvb@linuxtv.org>; Mon, 08 Dec 2008 12:21:56 -0800 (PST)
Message-ID: <493D81DF.4010601@googlemail.com>
Date: Mon, 08 Dec 2008 21:21:51 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <492168D8.4050900@googlemail.com>	
	<19a3b7a80812020834t265f2cc0vcf485b05b23b6724@mail.gmail.com>	
	<c74595dc0812020849p4d779677ge468871489e7d44@mail.gmail.com>	
	<49358FE8.9020701@googlemail.com>	
	<c74595dc0812021205x22936540w9ce74549f07339ff@mail.gmail.com>	
	<4935B1B3.40709@googlemail.com>	
	<c74595dc0812022323w1df844cegc0c0ef269babed66@mail.gmail.com>	
	<4936BE27.10800@googlemail.com>	
	<9ac6f40e0812031104q1b3a419ub5c1a58d19f96239@mail.gmail.com>
	<c74595dc0812031328i32bc9997t632e0f63a8849b03@mail.gmail.com>
In-Reply-To: <c74595dc0812031328i32bc9997t632e0f63a8849b03@mail.gmail.com>
Subject: Re: [linux-dvb] [PATCH]Fix a bug in scan,
 which outputs the wrong frequency if the current tuned transponder
 is scanned only
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

Alex Betis schrieb:

> There is no need for NIT message. I've added query from driver for currently
> tuned parameters - should work for DVB-T and DVB-C users. DVB-S/S2 will get
> IF frequency, which is not the real transponder frequency.
> Please update to latest version.
> Your other patch for DVB-C scan is also there.
> 
> Let me know if it helps.
> 

It works with the stv0297 and the tda10021 frontend. If the transponder was tuned with the
modulation QAM_AUTO, it would be better to read the current modulation from the frontend.
Currently, QAM_AUTO isn't implemented for a DVB-C frontend, but I'm working on an
implementation for the stv0297.

Regards,
Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
