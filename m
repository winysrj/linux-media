Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f168.google.com ([209.85.218.168])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <armel.frey@gmail.com>) id 1M3QTG-0003TQ-TU
	for linux-dvb@linuxtv.org; Mon, 11 May 2009 10:02:55 +0200
Received: by bwz12 with SMTP id 12so2497497bwz.17
	for <linux-dvb@linuxtv.org>; Mon, 11 May 2009 01:02:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8566f5bc0905070618u6db97047qfd245f83c07316aa@mail.gmail.com>
References: <8566f5bc0905060103g250086a2v12d038e9163cabb8@mail.gmail.com>
	<alpine.DEB.2.00.0905070221080.21713@ybpnyubfg.ybpnyqbznva>
	<8566f5bc0905070618u6db97047qfd245f83c07316aa@mail.gmail.com>
Date: Mon, 11 May 2009 10:02:13 +0200
Message-ID: <8566f5bc0905110102k31192171kd25d415316aa0297@mail.gmail.com>
From: armel frey <armel.frey@gmail.com>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
Cc: DVB mailin' list thingy <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] szap2 and Band L???
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0992131802=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0992131802==
Content-Type: multipart/alternative; boundary=001636c923d75d577904699e6528

--001636c923d75d577904699e6528
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi everyone,

I guess it was a mistake. As I said, I have put the LO frequency in the low
range of Universal Ku band LNBs to 0 and when i try to tune my card in
DVB-S2 I don't have the error message anymore but szap-s2 didn't tune my
card.
I also try to this tune by adding 9750 MHz on my frequency, but it didn't
work neither...
The problem doesn't linked with the frontend as I believed first, but on th=
e
szap-s2 which doesn't tune DVB-S2 on L-BAND...
2009/5/7 armel frey <armel.frey@gmail.com>

> Thanks,
>
> I have put the LO frequency in the low range of Universal Ku band LNBs to=
 0
> and when i try to tune my card in DVB-S2 I don't have the error message
> anymore...
>
> Yet, I have an other problem...
> If I try to tune my card to catch my DVB-S2 signal with the parameter
> DVB-S2 d=E9modulation on szap-s2 (that seems normal...), szap-s2 don't se=
e and
> don't lock anything.
> But, if I try to tune my card to catch the same DVB-S2 signal with the
> parameter DVB-S demodulation on szap-s2, it lock the signal well ... of
> course, it doesn't succeed to demodulated.
> That why I guess my problem is linked to the frontend, but I don't know h=
ow
> to check and correct...
> If someone have an idea?
>
> For more information, in one hand, I have an Dektec Dta-107S2 modulator
> card, and on the other hand I have an Hauppauge HVR-4000.
>
> The application szap-s2 I try to use is :
>
> http://mercurial.intuxication.org/hg/szap-s2
>
>
>
> 2009/5/7 BOUWSMA Barry <freebeer.bouwsma@gmail.com>
>
>  On Wed, 6 May 2009, armel frey wrote:
>>
>> > I have a Hauppauge HVR-4000 and i would like to receive DVB-S2 !
>> > The card works well in DVB-S and seems to work with szap-s2, but my
>> problem
>> > is that i have to receive DVB-S2 in Band L (950...2150MHz) and szap2
>> don't
>> > tune this low fr=E9quency.
>>
>> When I see the range of 950-2150MHz, I think of the intermediate
>> frequency delivered from mixing the local oscillator with the
>> received signal, which is passed from the LNB output through
>> the attached cable.
>>
>> In reality, this is what is tuned, although most commonly one
>> makes use of the frequencies of the Ku band, which the tuning
>> utility then converts to the IF frequency:
>> tuning DVB-S to Freq: 2062000, Pol:H Srate=3D22000000, 22kHz tone=3Doff,=
 LNB:
>> 1
>> Event:  Frequency: 12662350
>>
>> The same should be true for an LNB/dish to receive C-Band
>> signals, for example, something I've not had any personal
>> experience, so I don't know how well it would be supported
>> by the different utilities.
>>
>> Do you have an example of a particular DVB-S2 service which
>> you want to receive?
>>
>> My guess would be that if you need to tune a particular
>> frequency in that range, say, 2062MHz in the above example,
>> you can achieve this by adding 9750 MHz -- the LO frequency
>> in the low range of Universal Ku band LNBs, and then
>> attempting to tune that frequency, whether that comes as the
>> IF from a Ku, or C or Ka band LNB of whatever type -- Universal
>> or otherwise.
>>
>> Though I should hope that some utility will directly support
>> specifying a frequency within the above bands directly, if
>> that's what you're trying to do, or a non-universal-LNB LO
>> frequency...
>>
>>
>> barry bouwsma
>>
>
>

--001636c923d75d577904699e6528
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi everyone,</div>
<div>=A0</div>
<div>I guess it was a mistake. As I said, I have put the LO frequency in th=
e low range of Universal Ku band LNBs to 0 and when i try to tune my card i=
n DVB-S2 I don&#39;t have the error message anymore but szap-s2 didn&#39;t =
tune my card.<br>
I also try to this tune by adding 9750 MHz on my frequency, but it didn&#39=
;t work=A0neither...</div>
<div>The problem doesn&#39;t linked with the frontend as I believed first, =
but on the szap-s2 which doesn&#39;t tune DVB-S2 on L-BAND...=A0<br></div>
<div class=3D"gmail_quote">2009/5/7 armel frey <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:armel.frey@gmail.com">armel.frey@gmail.com</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div>Thanks, </div>
<div>=A0</div>
<div>I have put the LO frequency in the low range of Universal Ku band LNBs=
 to 0 and when i try to tune my card in DVB-S2 I don&#39;t have the error m=
essage anymore... </div>
<div>=A0</div>
<div>Yet, I have an other problem...=A0</div>
<div>If I try to tune=A0my card to catch my DVB-S2 signal=A0with the parame=
ter DVB-S2 d=E9modulation on szap-s2 (that seems normal...), szap-s2=A0don&=
#39;t see and don&#39;t lock anything. </div>
<div>But, if I try to tune my card to catch the same DVB-S2 signal with the=
 parameter DVB-S demodulation on szap-s2, it lock the signal well ... of co=
urse, it doesn&#39;t succeed to demodulated. </div>
<div>That why I guess my problem is linked to the frontend, but I don&#39;t=
 know how to check and correct...</div>
<div>If someone have an idea?</div>
<div>=A0</div>
<div>For more information, in one hand, I have an Dektec Dta-107S2 modulato=
r card, and on the other hand=A0I have an Hauppauge HVR-4000.</div>
<div>=A0</div>
<div>The application szap-s2 I try to use is :</div>
<div>=A0</div>
<div><a href=3D"http://mercurial.intuxication.org/hg/szap-s2" target=3D"_bl=
ank">http://mercurial.intuxication.org/hg/szap-s2</a></div>
<div><br><br>=A0</div>
<div class=3D"gmail_quote">2009/5/7 BOUWSMA Barry <span dir=3D"ltr">&lt;<a =
href=3D"mailto:freebeer.bouwsma@gmail.com" target=3D"_blank">freebeer.bouws=
ma@gmail.com</a>&gt;</span>=20
<div>
<div></div>
<div class=3D"h5"><br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div>On Wed, 6 May 2009, armel frey wrote:<br><br>&gt; I have a Hauppauge H=
VR-4000 and i would like to receive DVB-S2 !<br>&gt; The card works well in=
 DVB-S and seems to work with szap-s2, but my problem<br>&gt; is that i hav=
e to receive DVB-S2 in Band L (950...2150MHz) and szap2 don&#39;t<br>
&gt; tune this low fr=E9quency.<br><br></div>When I see the range of 950-21=
50MHz, I think of the intermediate<br>frequency delivered from mixing the l=
ocal oscillator with the<br>received signal, which is passed from the LNB o=
utput through<br>
the attached cable.<br><br>In reality, this is what is tuned, although most=
 commonly one<br>makes use of the frequencies of the Ku band, which the tun=
ing<br>utility then converts to the IF frequency:<br>tuning DVB-S to Freq: =
2062000, Pol:H Srate=3D22000000, 22kHz tone=3Doff, LNB: 1<br>
Event: =A0Frequency: 12662350<br><br>The same should be true for an LNB/dis=
h to receive C-Band<br>signals, for example, something I&#39;ve not had any=
 personal<br>experience, so I don&#39;t know how well it would be supported=
<br>
by the different utilities.<br><br>Do you have an example of a particular D=
VB-S2 service which<br>you want to receive?<br><br>My guess would be that i=
f you need to tune a particular<br>frequency in that range, say, 2062MHz in=
 the above example,<br>
you can achieve this by adding 9750 MHz -- the LO frequency<br>in the low r=
ange of Universal Ku band LNBs, and then<br>attempting to tune that frequen=
cy, whether that comes as the<br>IF from a Ku, or C or Ka band LNB of whate=
ver type -- Universal<br>
or otherwise.<br><br>Though I should hope that some utility will directly s=
upport<br>specifying a frequency within the above bands directly, if<br>tha=
t&#39;s what you&#39;re trying to do, or a non-universal-LNB LO<br>frequenc=
y...<br>
<font color=3D"#888888"><br><br>barry bouwsma<br></font></blockquote></div>=
</div></div><br></blockquote></div><br>

--001636c923d75d577904699e6528--


--===============0992131802==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0992131802==--
