Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [81.2.121.150] (helo=mail.firshman.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ben@firshman.co.uk>) id 1JTkyK-0007Rf-0W
	for linux-dvb@linuxtv.org; Mon, 25 Feb 2008 22:34:52 +0100
Received: from macbook.intra ([192.168.211.179])
	by mail.firshman.co.uk with esmtpsa (TLS-1.0:RSA_AES_128_CBC_SHA1:16)
	(Exim 4.63) (envelope-from <ben@firshman.co.uk>) id 1JTkyD-000645-Ad
	for linux-dvb@linuxtv.org; Mon, 25 Feb 2008 21:34:47 +0000
Message-Id: <2A6A7C5A-0D64-4E79-9CAF-4CA5FD8412C4@firshman.co.uk>
From: Ben Firshman <ben@firshman.co.uk>
To: linux-dvb@linuxtv.org
In-Reply-To: <47C3161F.4020802@raceme.org>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Mon, 25 Feb 2008 21:34:44 +0000
References: <47A98F3D.9070306@raceme.org> <47C3161F.4020802@raceme.org>
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

Which one disables the remote? I don't use the remote, so I could try  =

disabling it and see if I get any problems.

Ben

On 25 Feb 2008, at 19:25, Christophe Boyanique wrote:

> Christophe Boyanique a =E9crit :
>> I would just confirm the symptom that Jonas Anden reported on the
>> mailing list a few days ago about the Nova-T 500 loosing one tuner.
>>
>> Nothing in the logs or dmesg;
>> MythTV stuck on L__
>>
>> Host:
>> Linux 2.6.22-14-generic
>> Intel(R) Pentium(R) 4 CPU 3.00GHz
>>
>> v4l from 2008/01/27-16:34
>>
> Just for information: I decided to make this test more than 10 days  =

> ago:
>
> - disable EIT on both tuners in MythTV;
> - disable remote (that I do not use anyway)
>
> for that I added in a /etc/modprobe.d/local file:
> --- cut ---
> options dvb-usb-dib0700 force_lna_activation=3D1
> options dvb_usb disable_rc_polling=3D1
> --- cut ---
>
> The result is that both tuners are still up and working.
>
> So it may be either the remote or the EIT which produces the bug I  =

> suppose.
>
> Christophe.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
