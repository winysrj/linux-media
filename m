Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1K3tCu-0007Zv-FM
	for linux-dvb@linuxtv.org; Wed, 04 Jun 2008 15:39:17 +0200
Received: by yw-out-2324.google.com with SMTP id 3so48917ywj.41
	for <linux-dvb@linuxtv.org>; Wed, 04 Jun 2008 06:39:09 -0700 (PDT)
Message-ID: <37219a840806040639q737327c7r9cab46cfdd88eaae@mail.gmail.com>
Date: Wed, 4 Jun 2008 09:39:08 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Sigmund Augdal" <sigmund@snap.tv>
In-Reply-To: <1212584764.32385.36.camel@pascal>
MIME-Version: 1.0
Content-Disposition: inline
References: <1212535332.32385.29.camel@pascal>
	<1212584764.32385.36.camel@pascal>
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Re: Ooops in tda827x.c
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

> On Wed, 2008-06-04 at 01:22 +0200, Sigmund Augdal wrote:
>> changeset 49ba58715fe0 (7393) introduces an ooops in tda827x.c in
>> tda827xa_lna_gain. The initialization of the "msg" variable accesses
>> priv->cfg before the NULL check causing an oops when it is in fact
>> NULL.
>>
>> Best regards
>>
>> Sigmund Augdal


2008/6/4 Sigmund Augdal <sigmund@snap.tv>:
> Attached patch fixes the problem.
>
> Best regards
>
> Sigmund Augdal
>


Sigmund,

The driver was only able to get into this function without priv->cfg
being defined, because m920x passes in NULL as cfg.

In my opinion, this is flawed by design, and m920x should pass in an
empty structure rather than a NULL pointer, but I understand why
people might disagree with that.

With that said, your patch looks good and I see that it fixes the
issue. Please provide a sign-off so that your fix can be integrated
and you will receive credit for your work.

Use the form:

Signed-off-by: Your Name <email@addre.ss>

Regards,
Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
