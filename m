Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.230])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bvidinli@gmail.com>) id 1K49HG-0001fZ-Qr
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 08:48:52 +0200
Received: by rv-out-0506.google.com with SMTP id b25so622617rvf.41
	for <linux-dvb@linuxtv.org>; Wed, 04 Jun 2008 23:48:45 -0700 (PDT)
Message-ID: <36e8a7020806042348oe4d11b1r65adc7add8ec2ea6@mail.gmail.com>
Date: Thu, 5 Jun 2008 09:48:45 +0300
From: bvidinli <bvidinli@gmail.com>
To: "hermann pitton" <hermann-pitton@arcor.de>
In-Reply-To: <1212635564.2641.7.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Disposition: inline
References: <36e8a7020806040347t27206049je7e12b233ababf04@mail.gmail.com>
	<200806042002.43971.hubblest@web.de>
	<1212635564.2641.7.camel@pc10.localdom.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] About Avermedia DVB-S Hybrid+FM A700
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-9"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This was only in case somebody may help, and for your information,

As you know, Ubuntu is the most used distribution these days....
i think you should care about it...
Thanks anyway, information provided was usefull.
i will retry soon about my card..


2008/6/5 hermann pitton <hermann-pitton@arcor.de>:
> Hi,
>
> Am Mittwoch, den 04.06.2008, 20:02 +0200 schrieb Peter Meszmer:
>> Hello,
>>
>> to my mind your card _should_ work.
>> I'm using a DVB-S Hybrid+FM A700 card with zzam's driver since version
>> 20080204 without any problems on vanilla kernels 2.6.* and Gentoo-patched
>> kernels. So I'm able to watch freeTV and listen to DVB-S-radio (Astra).
>>
>> Did you ever thought of building your own, fresh vanilla-kernel from the
>> sources?
>>
>> Regards
>> Peter
>
> thanks, this is the only valid rule here :)
>
> bvidinli, you can't file bugs against us from ubuntix.
>
> :)
>
>>
>> Am Mittwoch, 4. Juni 2008 schrieb bvidinli:
>> > What is last status of driver for Avermedia DVB-S Hybrid+FM A700 ?
>> >
>> > as i last tested 20 days ago,
>> > 1- i build using hg, from linuxtv.org, dvb drivers,
>> > 2- i manually copied *.ko files to lib/modules directory, relevant dir=
s,
>> > 3- got satellite channels list/names of channels, using kaffeine, but
>> > no image/sound, i think decode fails...
>> >
>> > is there a recent update that i should try, or is there  a new method
>> > to overcome problem of "make install not working, because of unusual
>> > ubuntu directory structure for video modules...". I mean, lastly i run
>> > make install, but it did not solve driver problem, "symbol not found,
>> > disagrees messages on dmesg" this was because of ubuntu's choice for
>> > new directory structure of media modules...
>> >
>> > shortly, is there  a recent update to dvb drivers for avermedia dvb-s
>> > hybrid+fm a700 ?
>> >
>> > thanks..
>> >
>> > 2008/6/4, Eduard Huguet <eduardhc@gmail.com>:
>> > > Good point. I think the message is more explicative this way.
>> > >
>> > > Best regards,
>> > >   Eduard
>> > >
>> > > 2008/6/4 Matthias Schwarzott <zzam@gentoo.org>:
>> > > > On Samstag, 17. Mai 2008, hermann pitton wrote:
>> > > > > Hello,
>> > > > >
>> > > > > Am Sonntag, den 18.05.2008, 00:23 +0300 schrieb bvidinli:
>> > > > > > Hi,
>> > > > > > thank you for your answer,
>> > > > > >
>> > > > > > may i ask,
>> > > > > >
>> > > > > > what is meant by "analog  input", it is mentioned on logs that=
:"
>> > > > > > only analog inputs supported yet.." like that..
>> > > > > > is that mean: s-video, composit ?
>> > > > >
>> > > > > yes, only s-video and composite is enabled there.
>> > > > > Better we would have print only external analog inputs.
>> > > >
>> > > > If there is still interest to improve the printk message, here is a
>> > > > patch.
>> > > >
>> > > > Regards
>> > > > Matthias
>>
>
> Cheers,
> Hermann
>
>
>



-- =

=DD.Bahattin Vidinli
Elk-Elektronik M=FCh.
-------------------
iletisim bilgileri (Tercih sirasina gore):
skype: bvidinli (sesli gorusme icin, www.skype.com)
msn: bvidinli@iyibirisi.com
yahoo: bvidinli

+90.532.7990607
+90.505.5667711
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
