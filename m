Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ombos.raceme.org ([212.85.152.43])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tof+linux-dvb@raceme.org>) id 1JTixF-0006mz-Ii
	for linux-dvb@linuxtv.org; Mon, 25 Feb 2008 20:25:37 +0100
Received: from localhost (mail.raceme.org [192.168.1.17])
	by ombos.raceme.org (Postfix) with ESMTP id 6EDB2144351
	for <linux-dvb@linuxtv.org>; Mon, 25 Feb 2008 20:25:33 +0100 (CET)
Received: from ombos.raceme.org ([192.168.1.17])
	by localhost (ombos.raceme.org [192.168.1.17]) (amavisd-new, port 10024)
	with ESMTP id YeXjuNIIAf0Z for <linux-dvb@linuxtv.org>;
	Mon, 25 Feb 2008 20:25:28 +0100 (CET)
Received: from [192.168.1.4] (abidos.raceme.org [81.57.143.226])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ombos.raceme.org (Postfix) with ESMTP id D222E144231
	for <linux-dvb@linuxtv.org>; Mon, 25 Feb 2008 20:25:27 +0100 (CET)
Message-ID: <47C3161F.4020802@raceme.org>
Date: Mon, 25 Feb 2008 20:25:19 +0100
From: Christophe Boyanique <tof+linux-dvb@raceme.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47A98F3D.9070306@raceme.org>
In-Reply-To: <47A98F3D.9070306@raceme.org>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Christophe Boyanique a =E9crit :
> I would just confirm the symptom that Jonas Anden reported on the =

> mailing list a few days ago about the Nova-T 500 loosing one tuner.
>
> Nothing in the logs or dmesg;
> MythTV stuck on L__
>
> Host:
> Linux 2.6.22-14-generic
> Intel(R) Pentium(R) 4 CPU 3.00GHz
>
> v4l from 2008/01/27-16:34
>   =

Just for information: I decided to make this test more than 10 days ago:

- disable EIT on both tuners in MythTV;
- disable remote (that I do not use anyway)

for that I added in a /etc/modprobe.d/local file:
--- cut ---
options dvb-usb-dib0700 force_lna_activation=3D1
options dvb_usb disable_rc_polling=3D1
--- cut ---

The result is that both tuners are still up and working.

So it may be either the remote or the EIT which produces the bug I suppose.

Christophe.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
