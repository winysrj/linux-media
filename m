Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <beth.null@gmail.com>) id 1KYGKe-0001N2-UC
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 10:24:51 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1481614fga.25
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 01:24:45 -0700 (PDT)
Message-ID: <7641eb8f0808270124sbc79535x53f65552ec8e94cb@mail.gmail.com>
Date: Wed, 27 Aug 2008 10:24:45 +0200
From: Beth <beth.null@gmail.com>
To: free_beer_for_all@yahoo.com
In-Reply-To: <819681.11033.qm@web46106.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <7641eb8f0808231328s3b265741p4e5d57e7b6ca8c8c@mail.gmail.com>
	<819681.11033.qm@web46106.mail.sp1.yahoo.com>
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

Hi barry, good morning.

As you said, the file that I attached is too bigger than the limit of
the mailing list, so I uploadet it to
http://sites.google.com/site/bethnull/ , for someone that it will be
interested in, on this page there is a tgz file that holds ten scans
runs with the output and error redirected into two files
(channels_x.conf and channels_x.err).


2008/8/27 barry bouwsma <free_beer_for_all@yahoo.com>:
>
> Sorry for the delay; I've been in a different OS without reliable
> access to the 'net
>

Hehe, I am writting you from a friends computer, and I will have two
days of oscurity ;)

>
>  76 /tmp/scan_test/all
>
>  63 /tmp/scan_test/channels_0.conf.cut
>  65 /tmp/scan_test/channels_1.conf.cut
>  62 /tmp/scan_test/channels_2.conf.cut
>  68 /tmp/scan_test/channels_3.conf.cut
>  62 /tmp/scan_test/channels_4.conf.cut
>  63 /tmp/scan_test/channels_5.conf.cut
>  66 /tmp/scan_test/channels_6.conf.cut
>  65 /tmp/scan_test/channels_7.conf.cut
>  65 /tmp/scan_test/channels_8.conf.cut
>  64 /tmp/scan_test/channels_9.conf.cut
>
> And none of them include, for example, the ARD 11836 transponder.
>
> Could be a driver problem, or could be a weak signal installation.
>

As I said as soon as I arrive at home I will do some test on this
transponder, and make a dish realign.

>
> The only thing that might be a concern, is that the attached file
> was rather large, and was probably best not sent to the mailing
> list, but instead made available on a web page if you have one, or
> mailed by request to anyone interested.  That way the many subscribers
> to the list who cannot help, or cannot understand the logfiles, do
> not have to download the entire tarball.
>

Late but there are uploaded to http://sites.google.com/site/bethnull/

>
>> It takes about 24 minutes for each scan, =BFis this normal?,
>
> No, but...  There were a lot of transponders where you were not
> able to obtain a lock.  Nearly all of these are valid frequencies.
> Your `scan' decided to wait for quite some number of seconds on
> each of these transponders before giving up, when it should have
> been able to tune and lock and parse the data rather quickly.
>
> Here is another question:  Can you add the following channels to
> your .conf file and tune these programs?
>
> Das Erste:11836:h:0:27500:101:102:28106
> Bayerisches FS Sued:11836:h:0:27500:201:202:28107
> hr-fernsehen:11836:h:0:27500:301:302:28108
> Bayerisches FS Nord:11836:h:0:27500:201:202:28110
> WDR Koeln:11836:h:0:27500:601:602:28111
> BR-alpha*:11836:h:0:27500:701:702:28112
> SWR Fernsehen BW:11836:h:0:27500:801:802:28113
>
> You may need to add `:0' at the end, after the Service ID.
>
> You could also try, if I remember, `dvbtune -m' with the correct
> frequency, symbol-rate, etc., and compare the values you see with
> that of the TV Galicia transponder, to see how Linux sees the signal
> strength and error rate.
>

Sir Yes Sir :D, of course as I arrive home (on friday)

> Also, can you scan, find, and watch these programs under 'Doze?
>

Doze? what does means?


>
>> The scan program I am using was compiled using the
>> instructions found
>
> I have done a bit more thinking, or what passes for it at this time
> of day.  The way I invoke `scan' is from a script like...
>
> /usr/bin/awk -v DVB=3D"$DVB" '{ if ( $0 ~ /^S/ ) \
>  { print DVB " #" $0 > "/tmp/ast" ; system ( " /bin/sleep 1 ; \
> ( /bin/echo -e -n \\\\n\ \ Scanning ; \
> /usr/bin/tail -1 /tmp/ast | /bin/sed -e s,^.*#S,, ) >&2 ; \
> /bin/echo -e -n \\\\n\ \ Scanning ; /usr/bin/tail -1 /tmp/ast | \
> /bin/sed -e s,^.*#S,, ; ( /bin/echo -e -n Scanning ; \
> /usr/bin/tail -1 /tmp/ast | /bin/sed -e s,^.*#S,, ) >&3 ; \
> DVB=3D`/usr/bin/tail -1 /tmp/ast | /usr/bin/cut -f1 -d \\# ` ; \
> /usr/bin/tail -1 /tmp/ast | /usr/bin/cut -f2 -d \\# | \
> /mnt/home/beer/bin/dvbscan-NIT-dump-MPEG4video_parse \
>  -s 4  $DVB   -v -5 -1 -D /dev/stdin | \
> /usr/bin/sort -n -k 8 -t : ; if [ $? -ne 0 ] ; \
>  then /bin/echo \ \ \ \ \ \ \ \ FAILED >&3 ; fi ; /bin/echo >&2" ) } } ' \
> /home/beer/Satellite-lists/scan-astra3-complete 3>&1 \
>  > /home/beer/Satellite-lists/scan-result-astra3-`/bin/date +%F` \
>  2> /home/beer/Satellite-lists/scan-stderr-astra3-`/bin/date +%F`
>
>
> Do not try this at home.
>

Mamma mia :D

> This means that I'm invoking a new `scan' for each frequency
> read from a list of frequencies -- necessary with my old `scan'
> on this satellite as normally `scan' used to think that hor. and
> vertical polarisations at the same frequency were not different,
> and would not scan one of them.  This also means that `scan' is
> not remembering old PMT data from the previous transponder, as it
> only scans one (the -1 hack) and then quits, and we wait one second
> before starting anew.

Ummm I know, and make sense as you said that the PMT data is
remembered from the last transponder.

>
> Actually, in the case of the ARD channel Bayerisches Fernsehen Nord
> that I listed above, this normally uses the video and audio and TTX
> PIDs of BR-Sued at 201, 202, 203, 204, and 206 for most of the day.
>
> But for a few hours for regional programming, the Nord (Franken)
> channel changes to use video PID 501, audio PID 502, no 2nd audio or
> AC3, and remains at 204 for teletext.
>
> Such a program would notice and track this change and switch
> automagically.  That is, it does what `scan' does, not just once,
> but all the time it's running.
>
> This also means that if a program is in `not running' status at the
> time you make a successful scan, such as EinsFestival HD at the time
> you made your scans, that when it starts sending programming in a
> day or two, you will not need to make a new `scan' to find the
> correct PIDs.
>

Ummm, I understand, I thought that they were always "running".

Ok barry, as I said, I will do the "todo" list as soon as I get home.

Thanks for your kind support and best regards.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
