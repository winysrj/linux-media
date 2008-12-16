Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-fx0-f18.google.com ([209.85.220.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alannisota@gmail.com>) id 1LCaoN-0007qX-Py
	for linux-dvb@linuxtv.org; Tue, 16 Dec 2008 15:22:12 +0100
Received: by fxm11 with SMTP id 11so842311fxm.17
	for <linux-dvb@linuxtv.org>; Tue, 16 Dec 2008 06:21:38 -0800 (PST)
Message-ID: <4947B92E.2040705@gmail.com>
Date: Tue, 16 Dec 2008 06:20:30 -0800
From: Alan Nisota <alannisota@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4931745D.5030008@gmail.com>
In-Reply-To: <4931745D.5030008@gmail.com>
Subject: Re: [linux-dvb] [PATCH] Convert GP8PSK module to use S2API
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

Alan Nisota wrote:
> This patch converts the gp8psk module to use the S2API.
> It pretends to be  DVB-S2 capable in order to allow the various 
> supported modulations (8PSK, QPSK-Turbo, etc), and keep software 
> compatibility with the S2API patches for Mythtv and VDR.
>
> Signed-off by: Alan Nisota <alannisota@gmail.com>
>
Is there anything I need to do to get this committed?  There are many 
folks using this hardware, who would love to not need to patch their 
kernel to use it.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
