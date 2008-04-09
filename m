Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.239])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zdenek.kabelac@gmail.com>) id 1JjVhX-0001i2-B5
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 10:30:40 +0200
Received: by wx-out-0506.google.com with SMTP id s11so2591443wxc.17
	for <linux-dvb@linuxtv.org>; Wed, 09 Apr 2008 01:30:32 -0700 (PDT)
Message-ID: <c4e36d110804090130s5b66a357s3ec754a1d617b30@mail.gmail.com>
Date: Wed, 9 Apr 2008 10:30:30 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <47FC373F.5060006@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <7dd90a210804070554t6d8b972xa85eb6a75b0663cd@mail.gmail.com>
	<47FA3A7A.3010002@iki.fi> <47FAFDDA.4050109@iki.fi>
	<c4e36d110804081627s21cc5683l886e2a4a8782cd59@mail.gmail.com>
	<47FC373F.5060006@iki.fi>
Cc: linux-dvb@linuxtv.org, Benoit Paquin <benoitpaquindk@gmail.com>
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
> > As it looks like my AverTV Hybrid Volar HX is a little bit of no use
> > for quite some time -
> > and your afatech driver seems to helpfull to many other users - maybe you
> could
> > try to make it help for me as well ??
> >
>
>  I can try :)

Great ;)

>
>  version 4.95 is the latest one.
> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/

Yep that should be the one I'm using I guess

>  Are you really sure it is Afatech AF9015? Looks like all USB-messages are
> failing. The only thing this could happen is that device is not AF9015 or it
> is badly broken.

Well it's AF9013 - but as could be seen in the source - the code looks like
it should support both chips  AF9015 & AF9013 - do I had to set manually
some bits somewhere ?


>  Open stick and see chips used. Taking good resolution photo or two from PCB
> (stick motherboard) would be also nice.

Yep - I've already described chips in this device in my December post.

Now there are even some articles about this AvetTV Hybrid Volar HX device
- this one is in Czech - but the chip names should be understandable I guess :)

Here is article:

http://www.tvfreak.cz/art_doc-706394B9D247B386C12573F9003B14B5.html


And here is detailed photo of the AF9013 chip in there:

http://www.tvfreak.cz/tvf/media.nsf/v/B0DE86EDCE9E9972C12573F900407CF3/$file/dsc_0145_large.jpg


Regards

Zdenek

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
