Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1JzaFh-0002MN-LE
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 18:36:22 +0200
Received: by fg-out-1718.google.com with SMTP id e21so478459fga.25
	for <linux-dvb@linuxtv.org>; Fri, 23 May 2008 09:36:14 -0700 (PDT)
Message-ID: <854d46170805230936n4b48ae3dy50fb86780eded5d4@mail.gmail.com>
Date: Fri, 23 May 2008 18:36:14 +0200
From: "Faruk A" <fa@elwak.com>
To: "Anssi Hannula" <anssi.hannula@gmail.com>
In-Reply-To: <4836E4E3.70405@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <4836DBC1.5000608@gmail.com> <4836E28B.5000405@linuxtv.org>
	<4836E4E3.70405@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [multiproto patch] add support for using multiproto
	drivers with old api
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

2008/5/23 Anssi Hannula <anssi.hannula@gmail.com>:
> Andreas Oberritter wrote:
>> Hello Anssi,
>>
>> Anssi Hannula wrote:
>>> The attached adds support for using multiproto drivers with the old api.
>>
>> there seems to be a needlessly duplicated line in your patch:
>>
>> +     /* set delivery system to the default old-API one */
>> +     if (fe->ops.set_delsys) {
>> +             switch(fe->ops.info.type) {
>> +             case FE_QPSK:
>> +                     fe->ops.set_delsys(fe, DVBFE_DELSYS_DVBS);
>> +                     fe->ops.set_delsys(fe, DVBFE_DELSYS_DVBS);
>
> Strange, the latter one should be 'break;'.
>
> Attached again.
>
> --
> Anssi Hannula

Thank you so much :)
I can't believe I'm watching tv in kaffeine with my multiproto card.

My card is Technotred TT Connect S2-3650 CI
Using this drivers:
dvb-core.ko
dvb-pll.ko
stb6100.ko
insmod stb0899.ko
lnbp22.ko
idvb-usb.ko
dvb-usb-pctv452e.ko

Faruk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
