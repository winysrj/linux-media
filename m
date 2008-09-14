Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1Kes14-0005v4-T0
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 15:51:56 +0200
Received: by yx-out-2324.google.com with SMTP id 8so478859yxg.41
	for <linux-dvb@linuxtv.org>; Sun, 14 Sep 2008 06:51:50 -0700 (PDT)
Message-ID: <d9def9db0809140651l392282d4u87098881ce4ca382@mail.gmail.com>
Date: Sun, 14 Sep 2008 15:51:50 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: free_beer_for_all@yahoo.com
In-Reply-To: <391631.73780.qm@web46111.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <d9def9db0809131910h2ff43b9auf86eb340adb2fac8@mail.gmail.com>
	<391631.73780.qm@web46111.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

On Sun, Sep 14, 2008 at 12:51 PM, barry bouwsma
<free_beer_for_all@yahoo.com> wrote:
> --- On Sun, 9/14/08, Markus Rechberger <mrechberger@gmail.com> wrote:
>
>> >>> (Also to be noted is that, some BSD chaps also have shown interest in
>
> Does BSD == NetBSD here?  Or are there other developments
> as well that I'm not aware of?
>

for now it's netBSD, we're offering support to everyone who's interested.


>
>> As for the em28xx driver I agreed with pushing all my code
>
> Do you want to have patches for your repository, like the
> following (just an example, based on the NetBSD SOC source)
>

If you look at the chipdrivers, manufacturers often have independent
code there, as code can be kept independent in that area.
The bridge driver will contain operating system dependent code of course,
The drx driver which you mention mostly uses the Code which came from
Micronas, the module interface code which you looked at is linux
specific yes, but it's more or less just a wrapper against the
original source. It's the same with upcoming drivers.

Its just like Chipdriver - Linuxwrapper - linuxdriver; whereas it can
be the same with any operating system. This also keeps the incomplete
API (of any OS) separated from the available features of the
chipdriver logic. That way it's also rather easy to catch updates from
the manufacturers of the corresponding ICs.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
