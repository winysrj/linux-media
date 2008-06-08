Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1K5QuD-0003kx-C5
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 21:50:21 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1330722fga.25
	for <linux-dvb@linuxtv.org>; Sun, 08 Jun 2008 12:50:17 -0700 (PDT)
Message-ID: <854d46170806081250u3e7ca97er32d47be3ccf368fb@mail.gmail.com>
Date: Sun, 8 Jun 2008 21:50:17 +0200
From: "Faruk A" <fa@elwak.com>
To: Goga777 <goga777@bk.ru>
In-Reply-To: <20080608230650.5204d141@bk.ru>
MIME-Version: 1.0
Content-Disposition: inline
References: <484709F3.7020003@schoeller-soft.net>
	<4848C6D2.6040805@schoeller-soft.net>
	<854d46170806060249h1aec73e4s645462a123371c29@mail.gmail.com>
	<48497340.3050602@schoeller-soft.net>
	<854d46170806061050t12eee403re359ecfeac9143ec@mail.gmail.com>
	<48497F86.9020702@schoeller-soft.net>
	<48499E14.8000905@okg-computer.de> <20080608022114.5399c075@bk.ru>
	<484B8E23.302@okg-computer.de> <20080608230650.5204d141@bk.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] scan & szap for new multiproto api (was - How to
	get a PCTV Sat HDTC Pro USB (452e) running?)
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

Hi Goga777!

I'm glad everything worked out for you :).
with szap to tune to DVB-S2 channels use this option "-t 2" default is
"- t 0" which is for DVB-S
to tune to 'Astra HD Promo 2' you do:
szap -r -c 19 -t 2 "Astra HD Promo 2"
instead of using -c 19 create ~/.szap copy or move 19 as channels.conf
in ~/.szap directory. after this u can run szap -r -t 2 "Astra HD Promo 2"

As for scan you don't have do anything as far as i know it finds
DVB-S2  channels as well.

Faruk

On Sun, Jun 8, 2008 at 9:06 PM, Goga777 <goga777@bk.ru> wrote:
> Hi, Jens
>
>> >> For szap you have to download
>> >>
>> >> http://abraham.manu.googlepages.com/szap.c
>> >> then applie the api-v3.3 patch and compile it. This should work too.
>> >>
>> >> Or download the hg tree of dvb-apps and apply the attached patch on the whole tree. After that go to the scan and szap
>> >> directory and run "make". This works for me.
>> >>
>> >
>> > should your patch for scan/szap from dvb-apps work with others dvb-s2 cards - tt3200, vp1041, hvr4000  and the latest
>> > multiproto/multiproto_plus ?
>> >
>>
>> Well, I don't have such a device for testing, but why not? The dvb-apps
>> are not driver dependent.
>
> I hope so
>
>>>Or am I wrong? The HVR4000 I don't know? I
>
> here's information about this card
> http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000
>
>> think this card works only with the szap2-util!? (But I'm not sure!!)
>
> thanks for your patch. It's working with dvb-s
> i applied your patch_scan_szap.diff for HG dvb-apps. And I could run szap & scan with my hvr4000
> But only with dvb-s channels.
>
> And what about dvb-s2 ? I couldn't find any dvb-s2 option in szap & scan
> How can I scan dvb-s2 transponders and switch to dvb-s2 channels ?
>
> btw - there's patched szap2 in
> http://linuxtv.org/hg/dvb-apps/file/9311c900f746/test/szap2.c
> but it doesn't work with my card
>
> /usr/src/dvb-apps/test# ./szap2 -c 19 -n1
> reading channels from file '19'
> zapping to 1 'Astra HD Promo 2':
> sat 0, frequency = 11914 MHz H, symbolrate 27500000, vpid = 0x04ff, apid = 0x0503 sid = 0x0083
> Querying info .. Delivery system=DVB-S
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> ioctl DVBFE_GET_INFO failed: Operation not supported
>
> Goga
>
>
>
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
