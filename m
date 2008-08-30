Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <beth.null@gmail.com>) id 1KZKiK-0001r1-Jh
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 09:17:43 +0200
Received: by wa-out-1112.google.com with SMTP id n7so718580wag.13
	for <linux-dvb@linuxtv.org>; Sat, 30 Aug 2008 00:17:35 -0700 (PDT)
Message-ID: <7641eb8f0808300017o1e571cddse38aceeb9ce7df8f@mail.gmail.com>
Date: Sat, 30 Aug 2008 09:17:35 +0200
From: Beth <beth.null@gmail.com>
To: free_beer_for_all@yahoo.com
In-Reply-To: <7641eb8f0808291634m63fd0d56me3cf1bb4f12d943b@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <7641eb8f0808261538i569a9cc5o1f7a6a106f0b04c8@mail.gmail.com>
	<757904.94437.qm@web46101.mail.sp1.yahoo.com>
	<7641eb8f0808291634m63fd0d56me3cf1bb4f12d943b@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Skystar HD2 (device don't stream data).
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

Hey, good morning to all (well maybe good afternoon, night, here is 9:00am =
;) )

I had been doing some tests this morning on XP and why I didn't made
them before?.

I think that I have two problems, first one is the signal quality, I
have 65% of level and 98% of quality, 65% maybe the problem of the
impossibility of tunning certain transponders, I had tried some of the
problematic ones and the can't lock and scan on XP probrams like
ProgDVB. So first thing I need to increase the signal level.

Second, the incorrect vid&aid, really I don't know what is happening
here, on XP never get wrong vid&aid, so this will not be a dish
installation problem (I think).

Well thats all form XP. Regarddddssss.

2008/8/30 Beth <beth.null@gmail.com>:
> Hi barry, I am finally at home, umm home sweet home, how are you?
>
> I had made some of the "to-do" things:
>
> First, I added the channels:
>
> Das Erste:11836:h:0:27500:101:102:28106:0
> Bayerisches FS Sued:11836:h:0:27500:201:202:28107:0
> hr-fernsehen:11836:h:0:27500:301:302:28108:0
> Bayerisches FS Nord:11836:h:0:27500:201:202:28110:0
> WDR Koeln:11836:h:0:27500:601:602:28111:0
> BR-alpha*:11836:h:0:27500:701:702:28112:0
> SWR Fernsehen BW:11836:h:0:27500:801:802:28113:0
>
> And I get a strange behavior, that remembers me the two problems you
> said: dish installation or driver installation, that was the problem:
>
> I was trying to tune the channels and I had the following pattern, one
> time it works and one time didn't works alternatively, yes, I can tune
> and see the channels each time I try it, and the next I can't. After
> that I realized that this wasn't the problem, the problem was the time
> between calls to szap2, If I wait less than 3 seconds more and less, I
> get this behavior, if I wait 4 or more szap lock the frontend
> successfully. Sometimes this time interval is bigger, or needs more
> szap2 calls to catch the channel.
>
> I realized too something in the /var/log/messages file, if the channel
> is successfully tunned I get the following output:
>
>
> Aug 30 01:04:43 nemesis kernel: [10520.275555] newfec_to_oldfec:
> Unsupported FEC 9
> Aug 30 01:04:43 nemesis kernel: [10520.275563] dvb_frontend_ioctl:
> FESTATE_RETUNE: fepriv->state=3D2
> Aug 30 01:04:43 nemesis kernel: [10520.275598] mantis start feed & dma
> Aug 30 01:04:43 nemesis kernel: [10520.299097] stb6100_set_bandwidth:
> Bandwidth=3D61262500
> Aug 30 01:04:43 nemesis kernel: [10520.303361] stb6100_get_bandwidth:
> Bandwidth=3D62000000
> Aug 30 01:04:43 nemesis kernel: [10520.326053] stb6100_get_bandwidth:
> Bandwidth=3D62000000
> Aug 30 01:04:43 nemesis kernel: [10520.390307] stb6100_set_frequency:
> Frequency=3D1236000
> Aug 30 01:04:43 nemesis kernel: [10520.394568] stb6100_get_frequency:
> Frequency=3D1235988
> Aug 30 01:04:43 nemesis kernel: [10520.406471] stb6100_get_bandwidth:
> Bandwidth=3D62000000
>
> And stays here until I stop szap2, and I get:
>
> Aug 30 01:04:47 nemesis kernel: [10524.580406] mantis stop feed and dma
>
> But if the channels isn't tunned I get:
>
> Aug 30 01:06:03 nemesis kernel: [10600.603748] newfec_to_oldfec:
> Unsupported FEC 9
> Aug 30 01:06:03 nemesis kernel: [10600.603754] dvb_frontend_ioctl:
> FESTATE_RETUNE: fepriv->state=3D2
> Aug 30 01:06:03 nemesis kernel: [10600.603990] mantis start feed & dma
> Aug 30 01:06:03 nemesis kernel: [10600.648523] stb6100_set_bandwidth:
> Bandwidth=3D61262500
> Aug 30 01:06:03 nemesis kernel: [10600.652720] stb6100_get_bandwidth:
> Bandwidth=3D62000000
> Aug 30 01:06:03 nemesis kernel: [10600.678113] stb6100_get_bandwidth:
> Bandwidth=3D62000000
> Aug 30 01:06:03 nemesis kernel: [10600.744773] stb6100_set_frequency:
> Frequency=3D1236000
> Aug 30 01:06:03 nemesis kernel: [10600.748951] stb6100_get_frequency:
> Frequency=3D1235988
> Aug 30 01:06:03 nemesis kernel: [10600.760337] stb6100_get_bandwidth:
> Bandwidth=3D62000000
> Aug 30 01:06:04 nemesis kernel: [10601.576304] stb6100_set_bandwidth:
> Bandwidth=3D61262500
> Aug 30 01:06:04 nemesis kernel: [10601.580481] stb6100_get_bandwidth:
> Bandwidth=3D62000000
> Aug 30 01:06:04 nemesis kernel: [10601.603144] stb6100_get_bandwidth:
> Bandwidth=3D62000000
> Aug 30 01:06:04 nemesis kernel: [10601.667229] stb6100_set_frequency:
> Frequency=3D1236000
> Aug 30 01:06:04 nemesis kernel: [10601.671408] stb6100_get_frequency:
> Frequency=3D1235988
> Aug 30 01:06:04 nemesis kernel: [10601.684111] stb6100_get_bandwidth:
> Bandwidth=3D62000000
>
> ...
>
> And repeat over and over util I break the szap2 program, getting the same
>
>
> Aug 30 01:06:08 nemesis kernel: [10605.094697] mantis stop feed and dma
>
> This happens with your channels, but if I try our beloved TV GALICIA,
> I never get this behaviour, well, in some occasion I get two repeats
> of the loop :
>
> Aug 30 01:08:08 nemesis kernel: [10725.129081] newfec_to_oldfec:
> Unsupported FEC 9
> Aug 30 01:08:08 nemesis kernel: [10725.129088] dvb_frontend_ioctl:
> FESTATE_RETUNE: fepriv->state=3D2
> Aug 30 01:08:08 nemesis kernel: [10725.135534] mantis start feed & dma
> Aug 30 01:08:08 nemesis kernel: [10725.152567] stb6100_set_bandwidth:
> Bandwidth=3D51610000
> Aug 30 01:08:08 nemesis kernel: [10725.156950] stb6100_get_bandwidth:
> Bandwidth=3D52000000
> Aug 30 01:08:08 nemesis kernel: [10725.179650] stb6100_get_bandwidth:
> Bandwidth=3D52000000
> Aug 30 01:08:08 nemesis kernel: [10725.243778] stb6100_set_frequency:
> Frequency=3D1935000
> Aug 30 01:08:08 nemesis kernel: [10725.247950] stb6100_get_frequency:
> Frequency=3D1934982
> Aug 30 01:08:08 nemesis kernel: [10725.259936] stb6100_get_bandwidth:
> Bandwidth=3D52000000
> Aug 30 01:08:09 nemesis kernel: [10726.119567] stb6100_set_bandwidth:
> Bandwidth=3D51610000
> Aug 30 01:08:09 nemesis kernel: [10726.123741] stb6100_get_bandwidth:
> Bandwidth=3D52000000
> Aug 30 01:08:09 nemesis kernel: [10726.146308] stb6100_get_bandwidth:
> Bandwidth=3D52000000
> Aug 30 01:08:09 nemesis kernel: [10726.210778] stb6100_set_frequency:
> Frequency=3D1935000
> Aug 30 01:08:09 nemesis kernel: [10726.214952] stb6100_get_frequency:
> Frequency=3D1934982
> Aug 30 01:08:09 nemesis kernel: [10726.226934] stb6100_get_bandwidth:
> Bandwidth=3D52000000
> Aug 30 01:08:14 nemesis kernel: [10731.430950] mantis stop feed and dma
>
> But finally it works.
>
> It seems that I had problems with certain channels, and I think that
> it would be a dish or driver problem.
>
> Next I had made the changes to the scan.c following your code, and
> launch the scan_test, having the same problems, the same scanning
> time, and the same :0:0: problems. :(
>
> The file http://sites.google.com/site/bethnull/Home/scan_test_second_try.=
tgz?attredirects=3D0
> had the test (I was a bit impatient and there are only 3 scans).
>
> And dvbtune, dammit, or it doesnt works for me or I am not using it corre=
ctly:
>
> dvbtune -m -f 11685000 -p v -s 22000 -v 167 -a 108
>
> Using DVB card "STB0899 Multistandard"
> tuning DVB-S to L-Band:0, Pol:V Srate=3D22000000, 22kHz=3Doff
> polling....
> Getting frontend event
> FE_STATUS:
> polling....
> polling....
>
> I am pooolliiingg youuuuuu, and I needddd to sleeppppp, :D,
>
> I was trying that a friend of mine with a satellite spectrum analyzer
> comes to my house and check the installation, but with my cheap and
> inaccurate satellite finder I think that I can't do anything more.
>
> Is there another way to see the signal level and noise?
>
> Well is late, more tomorrow, good night barry (and everyone over
> there), see you ;)
>
> 2008/8/27 barry bouwsma <free_beer_for_all@yahoo.com>:
>> I finally knocked over the beer bottle long enough to try
>> and make sense of why `scan' sometimes fails for me in the
>> same way it fails for Beth.
>>
>> I get immediate signal lock on all Astra 19E2 DVB-S transponders
>> and from them, when `scan' behaves today, I'm getting 1421
>> received services, taking slightly over 5 minutes when using
>> the `Astra SDT' frequency as the seed.
>>
>> In general, I should never see the word `timeout' in the
>> stderr output when running `scan -v'.  When my `scan' has
>> been misbehaving and delivering PIDs of 0 and ghost services,
>> I see these timeouts, and plenty of them.
>>
>> After several hacks to `scan' to try and get it to read and
>> discard data, without perfect success, I've had three
>> consecutive scans without the problems, that in my last scan,
>> resulted in three transponders with bad data.  More on that
>> soon.
>>
>> I don't know what I'm doing, and have no clue what `scan' is
>> doing, nor what the underlying API and driver are doing, so my
>> hacks are certainly wrong.  Also, I don't see these problems
>> with two other DVB-S cards I have, only with my newest one.
>>
>> At best, this is a workaround in `scan' and not a fix.
>>
>>
>>
>> I ran `scan -v -v -v -v -v v- v-v v-v-v' (you get the idea)
>> fed by the Astra SDT frequency.  What do you know, the
>> first frequency scanned had problems, allowing me to repeat
>> the scan simply and get correct results.
>>
>> Here's the basics of the `diff' of stderr of these results...
>>
>> --- /tmp/success        2008-08-27 16:26:08.244916390 +0200
>> +++ /tmp/parse  2008-08-27 14:30:30.264896960 +0200
>> @@ -18,31 +18,31 @@
>>  update_poll_fds:1418: poll fd 6
>>  update_poll_fds:1418: poll fd 5
>>  update_poll_fds:1418: poll fd 4
>> -parse_section:1257: pid 0x00 tid 0x00 table_id_ext 0x0454, 0/0 (version=
 15)
>> +parse_section:1257: pid 0x00 tid 0x00 table_id_ext 0x0004, 0/0 (version=
 16)
>>  PAT
>> -add_filter:1498: add filter pid 0x002a
>> -start_filter:1438: start filter pid 0x002a table_id 0x02
>> +add_filter:1498: add filter pid 0x0067
>> +start_filter:1438: start filter pid 0x0067 table_id 0x02
>>  update_poll_fds:1418: poll fd 7
>>  update_poll_fds:1418: poll fd 6
>>  update_poll_fds:1418: poll fd 5
>>  update_poll_fds:1418: poll fd 4
>> -add_filter:1498: add filter pid 0x0034
>> -start_filter:1438: start filter pid 0x0034 table_id 0x02
>> +add_filter:1498: add filter pid 0x006c
>> +start_filter:1438: start filter pid 0x006c table_id 0x02
>>
>> And on it goes.
>>
>> The incorrect lines above are those preceded by `+'; notably,
>> the PID 0 (PAT) table_id_ext is different, as are the PIDs to
>> be found within.
>>
>> However the correct SDT is read, which is the next filter (PID 0x11)
>> to be added.  In the code of scan.c (my line numbers will be off)...
>>
>>   1971 static void scan_tp_dvb (void)
>>   1972 {
>>   1973         struct section_buf s0;
>>   1974         struct section_buf s1;
>>   1975         struct section_buf s2;
>>   1976         struct section_buf s3;
>>   1977
>>   1978         /**
>>   1979          *  filter timeouts > min repetition rates specified in E=
TR211
>>   1980          */
>>   1981         setup_filter (&s0, demux_devname, 0x00, 0x00, -1, 1, 0, 5=
); /* P
>>   1981 AT */
>>   1982         setup_filter (&s1, demux_devname, 0x11, 0x42, -1, 1, 0, 5=
); /* S
>>   1982 DT */
>>   1983
>>   1984         add_filter (&s0);
>>   1985         add_filter (&s1);
>>
>>
>> What happens for me is that with every twenty or so attempts
>> to tune a new transponder with `scan', even at the start of a
>> scan, the first filter set up for PID 0 delivers the PAT table
>> from the previously-tuned DVB-S transponder.
>>
>> However, the second filter, the SDT table, delivers the correct
>> data.  The following filters added are based on the incorrect
>> PAT PIDs, and therefore timeout without receiving anything.  The
>> SDT entries don't get filled out by matching PIDs from the PAT
>> and they too appear in the result without the proper PIDs, but
>> with the correct names from the SDT.
>>
>>
>> This has not been observed to be a problem with two other cards
>> I have, ever -- only with one card, the Opera DVB-USB tuner, and
>> at the time of my tests, on lightly-hacked 2.6.27-rc4 as of 23.Aug
>> (and had been present on all previous kernels I tested).
>>
>> My attempt to read and discard and re-read from these PIDs was a
>> half-success (I got valid PIDs for all proper services, but I still
>> saw leftovers).  My latest hack is simply adding these filters,
>> promptly deleting them, and adding them again, and so far has not
>> failed, but more testing is needed.
>>
>> A few more scans have revealed no problems, and my 'net connectivity
>> has disappeared, preventing me from verifying the source for other
>> flavours of `scan'.  So I submit this patch from my hacked scan.c:
>>
>>
>> @@ -1842,15 +1981,39 @@ static void scan_tp_dvb (void)
>>        setup_filter (&s0, demux_devname, 0x00, 0x00, -1, 1, 0, 5); /* PA=
T */
>>        setup_filter (&s1, demux_devname, 0x11, 0x42, -1, 1, 0, 5); /* SD=
T */
>>
>>        add_filter (&s0);
>>        add_filter (&s1);
>>
>> +/* XXX HACK  sometimes, filter s0 gets stale data, while the SDT filter
>> + * gets the correct data.  Then nothing gets proper PIDs.  what to do...
>> + * try removing the filters, and re-adding... */
>> +
>> +       remove_filter (&s0);
>> +       remove_filter (&s1);
>> +
>> +#if 0  /* this partly helped, but not completely  */
>> +//     do {
>> +//             read_filters ();
>> +//     } while (!(list_empty(&running_filters) &&
>> +//                list_empty(&waiting_filters)));
>> +#endif
>> +
>> +       setup_filter (&s0, demux_devname, 0x00, 0x00, -1, 1, 0, 5); /* P=
AT */
>> +       setup_filter (&s1, demux_devname, 0x11, 0x42, -1, 1, 0, 5); /* S=
DT */
>> +
>> +       add_filter (&s0);
>> +       add_filter (&s1);
>> +
>> +/* XXX  */
>> +
>>        if (!current_tp_only || output_format !=3D OUTPUT_PIDS) {
>> +             if (!no_nits) {
>>                setup_filter (&s2, demux_devname, 0x10, 0x40, -1, 1, 0, 1=
5); /* NIT */
>>                add_filter (&s2);
>> +             }
>>                if (get_other_nits) {
>>                        /* get NIT-others
>>                         * Note: There is more than one NIT-other: one per
>>                         * network, separated by the network_id.
>>                         */
>>                         setup_filter (&s3, demux_devname, 0x10, 0x41, -1=
, 1, 1, 15);
>>
>>
>>
>> You certainly need to apply this by hand; in particular,
>> you don't want to apply past the last `XXX', the !no_nits
>> test is a local hack I have.
>>
>> In my script I've eliminated the `sleep' that was supposed to
>> clear out the old data, and a full scan of all 120 transponders
>> (including non-DVB-S) takes me less than 6 1/2 min, and only
>> occasionally results in a random `timeout' message from a single
>> service, that is probably momentarily missing the needed PIDs,
>> as it's the same in some four successful scans.
>>
>> It turns out I had already downloaded the DVB-S2-aware `scan', and
>> the code above seems to be pretty much identical.
>>
>>
>>
>> Beth, as you know, you suffer two problems --
>>
>> * services with 0:0 PIDs that should be something else, and
>>  related to this, extra services that should not be there;
>>
>> * Difficulty tuning certain transponders, either a driver
>>  issue if your other OSen work well, or perhaps a dish issue.
>>
>> The first of these problems *may* be `fixed' (ha) by the hack
>> above.  Please try it; I don't think it will break anything.
>> In any case, you should be able to get correct PIDs for TVGalicia
>> and others with every one of repeated scans -- at least, it has
>> worked for me.
>>
>>
>> With my last scan, I saw 295 services which had 0:0 PIDs, out
>> of the 1421 DVB-S services.  Most of these are data services.
>> Some of these aren't, and may be different at a different time
>> of day or with a different `scan' program...
>>
>> ### SCRAMBLED!!!  ###  NOT RUNNING!  #Blue Hustler:10920:h:1:22000:0:0:2=
0353
>> Pr0n that only is shown at night, at which time a different
>> service on this transponder gets 0:0 PIDs as it stops running
>> for the evening.
>>
>> ##  NOT RUNNING!  #.:12246:v:1:27500:0:0:10128
>> I really hate the way APS manages their transponders, keeping
>> off-the-air programs around, or recycling service IDs so that
>> Volksmusik TV is replaced by pr0n and I have to hastily reprogram
>> all the receivers I installed for grandparents.  Some receivers
>> will show these status not-running channels and I can't delete
>> them and have them stay deleted.  At some time these may return
>> as a new service, pr0n, most likely.  Is it okay if I rant about
>> APS here?
>>
>> NDR FS HH+:12421:h:1:27500:0:0:28325
>> Placeholders from recently discontinued programs to allow EPG
>> info about the frequency change to appear; will, like all the
>> others, disappear within some weeks.
>>
>> Radio 4 Surround:12515:h:1:22000:0:0:4047
>> Like Oe1 DD, an AC3-only audio service, while `scan' only prints
>> the primary audio PID for me.
>>
>> ### SCRAMBLED!!!  #BiB:12574:h:1:22000:0:0:5029
>> This gave me timeouts the last few scans; used to have proper PIDs
>>
>> ### SCRAMBLED!!!  #RADIOROPA-H<F6>rbuch 2:12603:h:1:22000:0:0:6002
>> No longer broadcasting; some other services should start here
>>
>> ### SCRAMBLED!!!  ###  NOT RUNNING!  #Bundesliga 9:12662:h:1:22000:0:0:1=
3110
>> Again, sometimes you'll see it, sometimes not.
>>
>>
>> Most of what you'll see will be data services, and in general,
>> if you can receive all active transponders from 19E2, you should
>> see somewhat less than 300 PIDs of 0:0 at the time I write this.
>> That's about one data service out of every five services.
>>
>>
>>
>> --- On Tue, 8/26/08, Beth <beth.null@gmail.com> wrote:
>>
>>> > a different card, with the same `scan' that works
>>> fine with two
>>> > other cards on a different machine (much older
>>> kernel).
>>>
>>> Can I try another scan? from where?
>>
>> I don't think so, as your card supports DVB-S2 -- but, as I
>> don't have hands-on experience with any of those cards and
>> related drivers, I don't even have an overview.
>>
>> At best, a normal `scan' would give you only DVB-S results;
>> at worst, you wouldn't see anything...
>>
>>
>>
>> barry bouwsma
>>
>>
>>
>>
>>
>
>
>
> --
> ---------------------------------------------------
> Jos=E9 Antonio Robles
>
> beth.null@gmail.com
>
> 661 960 119
>
> Sometimes something happens ...
> ---------------------------------------------------
>



-- =

---------------------------------------------------
Jos=E9 Antonio Robles

beth.null@gmail.com

661 960 119

Sometimes something happens ...
---------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
