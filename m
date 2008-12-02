Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1L7b9r-00053u-JN
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 20:43:44 +0100
Received: by nf-out-0910.google.com with SMTP id g13so1899744nfb.11
	for <linux-dvb@linuxtv.org>; Tue, 02 Dec 2008 11:43:40 -0800 (PST)
Message-ID: <49358FE8.9020701@googlemail.com>
Date: Tue, 02 Dec 2008 20:43:36 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <492168D8.4050900@googlemail.com>	
	<19a3b7a80812020834t265f2cc0vcf485b05b23b6724@mail.gmail.com>
	<c74595dc0812020849p4d779677ge468871489e7d44@mail.gmail.com>
In-Reply-To: <c74595dc0812020849p4d779677ge468871489e7d44@mail.gmail.com>
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
 > I don't understand what's wrong with NIT advartised frequency?
> For example, many satelite sites (such as lyngsat) have different
> frequencies listed for the same channel, generally a difference of 1 MHz
> here and there. 

If I do scan the tuned transponder only (parameter '-c'), scan will copy all NIT entries
to the same transponder data. The output contains the last frequency, which was found. On
DVB-C, the NIT contains the frequencies of all transponders. If VDR has tuned to the
113MHz transponder and I scan this transponder, I should got 113MHz and QAM64 modulation,
but I get e.g. 466MHz and QAM256 modulation. The frequency changes on every scan.

-Hartmut



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
