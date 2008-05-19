Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bvidinli@gmail.com>) id 1Jy6gS-0008Co-8Y
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 16:49:53 +0200
Received: by el-out-1112.google.com with SMTP id v27so428124ele.14
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 07:49:48 -0700 (PDT)
Message-ID: <36e8a7020805190749g7a5505bcn9ded40288c919913@mail.gmail.com>
Date: Mon, 19 May 2008 17:49:43 +0300
From: bvidinli <bvidinli@gmail.com>
To: "Eduard Huguet" <eduardhc@gmail.com>, linux-dvb@linuxtv.org,
	ozbilen@gmail.com
In-Reply-To: <617be8890805190702v2743f533p258d79423172d20f@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <617be8890805171034t539f9c67qe339f7b4f79d8e62@mail.gmail.com>
	<36e8a7020805171423q42051749y5f6c82da88b695cd@mail.gmail.com>
	<200805191344.14445.zzam@gentoo.org>
	<617be8890805190505i1d4d9857y8220ee6b5e48c214@mail.gmail.com>
	<36e8a7020805190536i40a438f2k604e148edaca88c0@mail.gmail.com>
	<617be8890805190702v2743f533p258d79423172d20f@mail.gmail.com>
Subject: Re: [linux-dvb] merhaba: About Avermedia DVB-S Hybrid+FM A700
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

Thank you very much for your guidance, it is very usefull.


To start my work more correctly, may i ask a few small questions:
(sory that, i am not very familiar with kernel compile/patch, so i ask
some questions...)
1- i will do hg clone, i.e, i will grab repository of v4l-dvb,  my
question: on which kernel will I do this ? on latest 2.6.26.rc2, or
does it work also on ubuntu 8.04's current kernel of 2.6.24.17 ?
    shortly, which kernel should i have, to be able to apply these
patches/makes....

2- does (http://dev.gentoo.org/~zzam/dvb/) include the patches of
matthias ? does it support dvb input too? do you know ?

3- after (i hope) a successful compile, is command "modprobe saa7134
i2c_scan=3D1  "  enaugh for  driver to load, or should i use something
"modprobe saa7134 i2c_scan=3D1 card=3D141 tuner=3D....."   since my card
number is 141 on listofcards, ... and... what is tuner number... is
that option needed... ?

i ask so much in detail because i tried so many things in last two
weeks, so, i need to know every point, i hope you understand me...


Thank you a lot...

19 May=FDs 2008 Pazartesi 17:02 tarihinde Eduard Huguet
<eduardhc@gmail.com> yazd=FD:
> Hi,
>     You should take a look at the wiki section "Installing LinuxTV DVB
> drivers", but more or less you need to do the following:
>
> 1.- install Mercurial to access the repository
> 2.- grab a copy of the repository by doing "hg clone
> http://linuxtv.org/hg/v4l-dvb"
> 3.- download DIFF patchset from ZZam's repository
> (http://dev.gentoo.org/~zzam/dvb/)
> 4.- enter the v4l-dvb folder created at step 2 and patch using "patch -p1=
 <
> path-to-diff-file "
> 5.- compile, install, etc...: "make && sudo make install && sudo make rmm=
od
> && sudo modprobe saa7134 i2c_scan=3D1"
>
> Good luck :D
> Regards,
>   Eduard
>
>
> 2008/5/19, bvidinli <bvidinli@gmail.com>:
>>
>> Can somebody tell me, how to apply Matthias Schwarzott's patches;
>> * where is patches ?
>> * what is base package/patch ?
>> * is there any special command/way, or is it standard patch -p1 command,=
 ?
>>
>> to inform you, my linux knowledge:
>> i am a linux system programmer, system engineer,
>> but i have no much knowledge about kernel compile, kernel patching,
>> only in last week, i did (firstly in my life) 2 successfull compiles
>> of kernel 2.6.26.rc2 (but i could not get sound... )
>> i use ubuntu hardy 8.04, i used
>> http://www.howtoforge.com/kernel_compilation_ubuntu to compile new
>> kernel.
>>
>>
>> i hope i will be able to apply matthias' patches... if i can get correct
>> info...
>>
>> how i can help you/v4l/dvb/linuxtv/linux/kernel community:
>> (i am no kernel developer, but i can test basic codes, or apply basic
>> patches, i have basic c programming skills.. i program php, bash,
>> python, )
>> * i can test new drivers with my hardware, i currently have avertv
>> dvb-s hybrid+fm  card..
>> * i can make small fixes to code, drivers, but  i need assistance
>> firstly an assistance on how to start, howto do...
>> * ?? anything else... ??
>>
>>
>> See you,
>>
>>
>> 2008/5/19 Eduard Huguet <eduardhc@gmail.com>:
>>
>> > Thanks for your clarification, Matthias.
>> > For your information, I've been tested extensively the driver these la=
st
>> > days and I can say it has been working really fine  for me. I've had no
>> > glitches while using it inside MythTV, changing channels works fine,
>> > also
>> > recording shows, etc... No issues on this part.
>> >
>> > The only minor issue is the one I yet mentioned in a previous mail: I
>> > can't
>> > find any channels on Astra 19.2 when using the default frequency table
>> > file
>> > located in /usr/share/dvb/dvb-s/Astra 19.2, but ir works fine when usi=
ng
>> > the
>> > alternative file obtained from
>> > http://joshyfun.peque.org/transponders/kaffeine.html.
>> >
>> > Regards,
>> >   Eduard
>> >
>> >
>> >
>> >
>> > 2008/5/19, Matthias Schwarzott <zzam@gentoo.org>:
>> >>
>> >> On Samstag, 17. Mai 2008, bvidinli wrote:
>> >> > Hi,
>> >> > thank you for your answer,
>> >> >
>> >> > may i ask,
>> >> >
>> >> > what is meant by "analog  input", it is mentioned on logs that:" on=
ly
>> >> > analog inputs supported yet.." like that..
>> >> > is that mean: s-video, composit ?
>> >> >
>> >>
>> >> Yeah. The patch already merged into v4l-dvb repository and also merged
>> >> into
>> >> kernel 2.6.26 does only support s-video and compite input of both A700
>> >> cards
>> >> (Avermedia AverTV dvb-s Pro and AverTV DVB-S Hybrid+FM).
>> >>
>> >> The other pending patches do add support for DVB-S input to both card
>> >> versions. But this is not yet ready for being merged.
>> >> At least here the tuning is not yet reliable for some frequencies (or
>> >> does
>> >> get
>> >> no lock depending very hardly on some tuner gain settings). But most
>> >> transponders of Astra-19.2=B0E I can get a good lock.
>> >>
>> >> This is the latest version of the patch:
>> >> http://dev.gentoo.org/~zzam/dvb/a700_full_20080519.diff
>> >>
>> >>
>> >> About RF analog input I cannot do much, as I do not have the hardware,
>> >> and
>> >> for
>> >> XC2028 tuner one needs to check out the GPIO configuration.
>> >>
>> >> If you would like to help you could try out or trace gpio lines some
>> >> way
>> >> to
>> >> get RF input running. As far as I know to get XC2028 running you need
>> >> to
>> >> find
>> >> out which pin does reset the tuner to finish firmware uploading.
>> >>
>> >> Regards
>> >>
>> >> Matthias
>> >
>> >
>>
>>
>>
>>
>> --
>>
>> =DD.Bahattin Vidinli
>> Elk-Elektronik M=FCh.
>> -------------------
>> iletisim bilgileri (Tercih sirasina gore):
>> skype: bvidinli (sesli gorusme icin, www.skype.com)
>> msn: bvidinli@iyibirisi.com
>> yahoo: bvidinli
>>
>> +90.532.7990607
>> +90.505.5667711
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
