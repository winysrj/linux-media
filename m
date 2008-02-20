Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.231])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1JRnIH-0005Dj-8I
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 12:39:21 +0100
Received: by wx-out-0506.google.com with SMTP id s11so2115347wxc.17
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 03:39:16 -0800 (PST)
Message-ID: <8ad9209c0802200339m3e5e36dew8700c1d980f367d5@mail.gmail.com>
Date: Wed, 20 Feb 2008 12:39:15 +0100
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1203500605.6682.12.camel@acropora>
MIME-Version: 1.0
Content-Disposition: inline
References: <8ad9209c0802111207t51e82a3eg53cf93c0bda0515b@mail.gmail.com>
	<1202762738.8087.8.camel@youkaida> <1203458171.8019.20.camel@anden.nu>
	<8ad9209c0802192338v66cfb4c4n42d733629421fe6c@mail.gmail.com>
	<1203499521.6682.2.camel@acropora>
	<1203500199.10076.29.camel@anden.nu>
	<1203500605.6682.12.camel@acropora>
Subject: Re: [linux-dvb] Very quiet around Nova-T 500
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

I have now set the debug to 15 and will test this tonight.

On 2/20/08, Nicolas Will <nico@youplala.net> wrote:
>
> On Wed, 2008-02-20 at 10:36 +0100, Jonas Anden wrote:
> > > The strange thing is that modinfo does not say anything about a
> > level 15
> > > debug for the dvb_usb_dib0700 module.
> > >
> > >
> > http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500#dvb_usb_dib0700
> >
> > The debug value is a bit field, with each bit representing a different
> > category. With all bits on (ie full debugging) the decimal value
> > becomes
> > 15.
>
> I should have guessed.
>
> Documented for poor souls with slow brains like me.
>
> Nico
>
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
