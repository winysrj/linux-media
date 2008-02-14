Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1JPd6G-0000oW-S5
	for linux-dvb@linuxtv.org; Thu, 14 Feb 2008 13:22:01 +0100
Received: by wa-out-1112.google.com with SMTP id m28so529705wag.13
	for <linux-dvb@linuxtv.org>; Thu, 14 Feb 2008 04:21:56 -0800 (PST)
Message-ID: <8ad9209c0802140421k26bc5964p6687b4e5b7ab09f1@mail.gmail.com>
Date: Thu, 14 Feb 2008 13:21:56 +0100
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <cc22fa3b0802140351l6cf9da2au5200ff97e0560b36@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <456F8CC7-BB99-4833-B540-8D1396C0E8C3@thedesignshop.biz>
	<cc22fa3b0802140351l6cf9da2au5200ff97e0560b36@mail.gmail.com>
Subject: Re: [linux-dvb] Nova-T-500 disconnect issues
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I will definently look in to this and will try to upgrade the kernel.
(will prob. screw it up but anyways).

Ps. Got a good kernel upgrade-how to for 7.10 ? Ds.

On 2/14/08, Simeon Walker <simbloke@googlemail.com> wrote:
> On 14/02/2008, General <mail@thedesignshop.biz> wrote:
> > Hi. I have been following the discussion regarding the mt2060 I2C
> >  read / write failed errors. I am running Ubuntu and get the same
> >  behaviour since I upgraded to the latest kernel (2.6.24.1) to resolve
> >  some wireless driver issues I was having. When I was running the
> >  standard Ubuntu kernel (2.6.22-14-generic) I never had the disconnect
> >  issues in 3 or 4 months of 24/7 usage. This was using the latest v4l-
> >  dvb sources as per the wiki.
> >
> >  Perhaps this would suggest that the error is not with the dib0700
> >  driver but elsewhere?
> >
> >  So my dilemma is do I have a constant wireless connection but a dvb
> >  driver that drops out or a constant dvb driver with a wireless
> >  connection that drops out?!
> >
> Ah but you can get the latest wireless drivers for your current kernel:
>
> http://linuxwireless.org/en/users/Download
>
> Sim
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
