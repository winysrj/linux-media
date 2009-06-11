Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f225.google.com ([209.85.219.225])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <claesl@gmail.com>) id 1MEe8a-0003qX-OO
	for linux-dvb@linuxtv.org; Thu, 11 Jun 2009 08:51:48 +0200
Received: by ewy25 with SMTP id 25so1484269ewy.17
	for <linux-dvb@linuxtv.org>; Wed, 10 Jun 2009 23:51:15 -0700 (PDT)
Message-ID: <4A30A95D.3040008@gmail.com>
Date: Thu, 11 Jun 2009 08:51:09 +0200
From: Claes Lindblom <claesl@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <621110570904131518w220106d7u67934966dbb8c7dd@mail.gmail.com>	<49E3D16E.3070307@gmail.com>
	<49E3D21D.7010406@gmail.com>
In-Reply-To: <49E3D21D.7010406@gmail.com>
Cc: abraham.manu@gmail.com
Subject: Re: [linux-dvb] SkyStar HD2 issues, signal sensitivity, etc.
Reply-To: linux-media@vger.kernel.org
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

Hi,

Manu Abraham wrote:
> The s2-liplianin tree doesn't use an updated tree for the mantis
> based devices unfortunately. It is stuck with older changesets of
> the mantis tree.
>
> The s2-liplianin tree contains (ed) ? some clock related changes
> which were not favourable for the STB0899 demodulator, which is
> capable of causing potential hardware damage.
>   
Is this still valid that s2-liplianin tree is out of date and if so, 
does anyone have a patch to update it?
It's does not sound so good when we start talking about hardware damage.

I have a problem with the recent s2-liplianin that the driver stops 
working and both scanning and tuning fails and a reboot does not help
and I have to poweroff my computer and restart it for it to work again.
Has anyone had the same issue? It's running on a Gigabyte GA M56S S3 
motherboard if that's any help.

Regards
Claes Lindblom


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
