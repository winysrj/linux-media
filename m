Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1L3a3Z-0005z0-UH
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 18:44:38 +0100
Date: Fri, 21 Nov 2008 18:44:00 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0811210928n204dd6a3hdc7d20bcacdfe7bd@mail.gmail.com>
Message-ID: <alpine.LRH.1.10.0811211839040.18931@pub1.ifh.de>
References: <412bdbff0811210928n204dd6a3hdc7d20bcacdfe7bd@mail.gmail.com>
MIME-Version: 1.0
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Hardware pid filters: are they worth it?
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

Hi Devin,

On Fri, 21 Nov 2008, Devin Heitmueller wrote:

> Hello,
>
> I am doing some driver work, and the USB device I am working on has
> hardware pid filter support.

Just in case you didn't see and in case you are using dvb-usb: it is quite 
simple to add support for a hardware PID filter driven board, you just 
need to fill in two or three functions and set the capability that this 
board needs or can do PID filtering.

Otherwise I can only agree to Micheal's comments. Especially having 
multipe USBs in use it can be useful.

regards,
Patrick.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
