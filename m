Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alireza.torabi@gmail.com>) id 1K7Ee3-00006K-Jj
	for linux-dvb@linuxtv.org; Fri, 13 Jun 2008 21:09:11 +0200
Received: by py-out-1112.google.com with SMTP id a29so1641568pyi.0
	for <linux-dvb@linuxtv.org>; Fri, 13 Jun 2008 12:08:31 -0700 (PDT)
Message-ID: <cffd8c580806131208t783b8b6claab689cecc48747c@mail.gmail.com>
Date: Fri, 13 Jun 2008 20:08:30 +0100
From: "Alireza Torabi" <alireza.torabi@gmail.com>
To: "Claudio Luck" <cluck@ethz.ch>
In-Reply-To: <48529A3E.9080407@ethz.ch>
MIME-Version: 1.0
Content-Disposition: inline
References: <cffd8c580806130739s6f23cc11mc96db647e522f072@mail.gmail.com>
	<cffd8c580806130755t21f428e5qdb83daa47f4d6665@mail.gmail.com>
	<cffd8c580806130817v35b813cay5440485baf55e526@mail.gmail.com>
	<cffd8c580806130829q8ea461fg57e040482ae8af7c@mail.gmail.com>
	<48529A3E.9080407@ethz.ch>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fwd: Mantis kernel modules and VP-1041/SP400 CI,
	HD2 card
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

On Fri, Jun 13, 2008 at 5:03 PM, Claudio Luck <cluck@ethz.ch> wrote:
> Alireza Torabi wrote:
>> Err! I can't load the module...
>> HELP please...
>>
>> Jun 13 17:24:26 alpha kernel: stv0299: Unknown symbol i2c_transfer
>> Jun 13 17:24:26 alpha kernel: stb0899: Unknown symbol i2c_transfer
>> Jun 13 17:24:26 alpha kernel: stb6100: Unknown symbol i2c_transfer
>> Jun 13 17:24:26 alpha kernel: mb86a16: Unknown symbol i2c_transfer
>
> i2c problems -> try older kernels, start with latest 2.6.24.
>

Yes, Thanks Claudio. You just spared me the embarrassment of answering
to myself again. I've changed some i2c settings on the kernel and it's
working with that kernel.

Alireza

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
