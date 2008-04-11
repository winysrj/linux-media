Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [203.200.233.138] (helo=nkindia.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gurumurti@nkindia.com>) id 1JkIrs-0007sI-BM
	for linux-dvb@linuxtv.org; Fri, 11 Apr 2008 15:00:37 +0200
Message-ID: <40998.203.200.233.130.1207919846.squirrel@203.200.233.138>
In-Reply-To: <15e616860804090759m76c05539q8945d30208f8daeb@mail.gmail.com>
References: <200804081441.49529.christophpfister@gmail.com>
	<60949.203.200.233.130.1207662815.squirrel@203.200.233.138>
	<42688.203.200.233.130.1207715070.squirrel@203.200.233.138>
	<1207728466.12385.213.camel@rommel.snap.tv>
	<15e616860804090759m76c05539q8945d30208f8daeb@mail.gmail.com>
Date: Fri, 11 Apr 2008 18:47:26 +0530 (IST)
From: "Gurumurti Laxman Maharana" <gurumurti@nkindia.com>
To: "Zaheer Merali" <zaheermerali@gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Extract Satelite Info
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


Hi Alll
is there any answer to the above subject?
Bye


> Another solution is, assuming the NIT is in the transport stream, is to
> do:
>
> gst-launch -m filesrc location=blah.ts ! mpegtsparse ! fakesink | grep nit
>
> It will give you something like:
>
> Got Message from element "mpegtsparse0" (element): nit,
> network-id=(guint)1, version-number=(guint)0,
> current-next-indicator=(guint)1, actual-network=(boolean)true,
> network-name=(string)"GC\ SPAIN\ 1", descriptors=(GValueArray)(NULL),
> transports=(structure){ transport-21, transport-stream-id=(guint)21,
> original-network-id=(guint)1, delivery=(structure)satellite,
> orbital=(float)30.5, east-or-west=(string)west,
> modulation=(string)QAM16, frequency=(guint)11615000,
> polarization=(string)horizontal, symbol-rate=(guint)27500,
> inner-fec=(string)3/4;, descriptors=(GValueArray)(NULL); };
>
> Zaheer
>
>
>
> On Wed, Apr 9, 2008 at 9:07 AM, Sigmund Augdal <sigmund@snap.tv> wrote:
>> ons, 09.04.2008 kl. 09.54 +0530, skrev Gurumurti Laxman Maharana:
>>
>> > Hi All
>>  > I want to know weather is it possible to extract satellite
>> information from
>>  > streams captured by DVB-S card?
>>  > Can any body help in this regard?
>>
>>  Use dvbsnoop.
>>
>>  dvbsnoop -s ts -tssubdecode -if capture.ts 16|less
>>
>>  Regards
>>
>>  Sigmund
>>
>>
>> > bye
>>  >
>>  >
>>  > > Hi
>>  > > I want to weather is it possoble to extract satellite information
>> from
>>  > > streams capture by DVB card?
>>  > > bye
>>  > >> From a kaffeine user ...
>>  > >>
>>  > >> Christoph
>>  > >>
>>  > >>
>>  > >> ----------  Weitergeleitete Nachricht  ----------
>>  > >>
>>  > >> Betreff: [kaffeine-user] Satellites at 80E and 90E
>>  > >> Datum: Sonntag 06 April 2008
>>  > >> Von: Roman Kashcheev <kashcheevr@rambler.ru>
>>  > >> An: kaffeine-user@lists.sf.net
>>  > >>
>>  > >> Hello!
>>  > >> There are files for dvb-s folder of kaffeine - Siberian
>> satellites, most
>>  > >> popular in eastern Russia.
>>  > >> Thanks for good program - Kaffeine. I use it to look satellite tv
>> since
>>  > >> spring 2006.
>>  > >> Forgive me for my bad english.
>>  > >>
>>  > >> Best regards,
>>  > >> Roman Kashcheev
>>  > >> Bodajbo city, Irkutsk region, Russia
>>  > >>
>>  > >> -------------------------------------------------------
>>  > >> _______________________________________________
>>  > >> linux-dvb mailing list
>>  > >> linux-dvb@linuxtv.org
>>  > >> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>  > >
>>  > >
>>  > > --
>>  > > gurumurti@nkindia.com
>>  > >
>>  > >
>>  > > _______________________________________________
>>  > > linux-dvb mailing list
>>  > > linux-dvb@linuxtv.org
>>  > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>  > >
>>  >
>>  >
>>
>>
>>  _______________________________________________
>>  linux-dvb mailing list
>>  linux-dvb@linuxtv.org
>>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>


-- 
G. L. Maharana


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
