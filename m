Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.176])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zdenek.kabelac@gmail.com>) id 1JjcoT-0007dO-0j
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 18:06:17 +0200
Received: by el-out-1112.google.com with SMTP id o28so1868582ele.2
	for <linux-dvb@linuxtv.org>; Wed, 09 Apr 2008 09:05:57 -0700 (PDT)
Message-ID: <c4e36d110804090905t3574e09ao8cadadacc9c12080@mail.gmail.com>
Date: Wed, 9 Apr 2008 18:05:57 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <47FCE5FB.9080003@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <7dd90a210804070554t6d8b972xa85eb6a75b0663cd@mail.gmail.com>
	<47FA3A7A.3010002@iki.fi> <47FAFDDA.4050109@iki.fi>
	<c4e36d110804081627s21cc5683l886e2a4a8782cd59@mail.gmail.com>
	<47FC373F.5060006@iki.fi>
	<c4e36d110804090130s5b66a357s3ec754a1d617b30@mail.gmail.com>
	<47FCE5FB.9080003@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] USB 1.1 support for AF9015 DVB-T tuner
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

2008/4/9, Antti Palosaari <crope@iki.fi>:
> Zdenek Kabelac wrote:
>
> > 2008/4/9, Antti Palosaari <crope@iki.fi>:
> >
> > > Zdenek Kabelac wrote:
> > >
> > >
> > > > As it looks like my AverTV Hybrid Volar HX is a little bit of no use
> > > >
> > >
> >
>
>
> > Well it's AF9013 - but as could be seen in the source - the code looks
> like
> > it should support both chips  AF9015 & AF9013 - do I had to set manually
> > some bits somewhere ?
> >
>
>  AF9013 is DVB-T demodulator and AF9015 is integrated USB-bridge + AF9013
> demodulator. Your device does not have AF9015 at all. DVB-T USB-device needs
> logically three "chips". USB-bridge, demodulator and tuner. As I can
> understand there is CY7C68013 USB-bridge, AF9013 demodulator and TDA18271
> tuner. First you should try to find driver for demodulator. After thats is
> OK we can try to connect AF9013 demodulator to USB-bridge and TDA18271 tuner
> to AF9013 demodulator.

Yep - that's what I needed to know - I have no idea how these things
are connected so I'll try to find something for CY7C USB-bridge first.

Thanks for hint

Zdenek

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
