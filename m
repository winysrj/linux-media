Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1L7YCr-0006F4-Be
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 17:34:37 +0100
Received: by nf-out-0910.google.com with SMTP id g13so1851493nfb.11
	for <linux-dvb@linuxtv.org>; Tue, 02 Dec 2008 08:34:34 -0800 (PST)
Message-ID: <19a3b7a80812020834t265f2cc0vcf485b05b23b6724@mail.gmail.com>
Date: Tue, 2 Dec 2008 17:34:33 +0100
From: "Christoph Pfister" <christophpfister@gmail.com>
To: e9hack <e9hack@googlemail.com>
In-Reply-To: <492168D8.4050900@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <492168D8.4050900@googlemail.com>
Cc: linux-dvb@linuxtv.org
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

2008/11/17 e9hack <e9hack@googlemail.com>:
> Hi,
>
> if the current tuned transponder is scanned only and the output needs the frequency of the
> transponder, it is used the last frequency, which is found during the NIT scanning. This
> is wrong. The attached patch will fix this problem.

Any opinion about this patch? It seems ok from a quick look, so I'll
apply it soon if nobody objects.

> Regards,
> Hartmut

Thanks,

Christoph

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
