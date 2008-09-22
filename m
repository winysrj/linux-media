Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <javier.galvez.guerrero@gmail.com>)
	id 1KhqMN-00032K-Bn
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 20:42:12 +0200
Received: by an-out-0708.google.com with SMTP id c18so148311anc.125
	for <linux-dvb@linuxtv.org>; Mon, 22 Sep 2008 11:42:07 -0700 (PDT)
Message-ID: <145d4e1a0809221142l4bea2ba8oacee793ec9e8855@mail.gmail.com>
Date: Mon, 22 Sep 2008 20:42:07 +0200
From: "=?ISO-8859-1?Q?Javier_G=E1lvez_Guerrero?="
	<javier.galvez.guerrero@gmail.com>
To: "Patrick Boettcher" <patrick.boettcher@desy.de>
In-Reply-To: <alpine.LRH.1.10.0809221902461.6414@pub3.ifh.de>
MIME-Version: 1.0
References: <145d4e1a0809220101j4063c300s7ec63ab13362bdf9@mail.gmail.com>
	<670024.49326.qm@web38804.mail.mud.yahoo.com>
	<145d4e1a0809220502v56020205o54fd186b227bdee7@mail.gmail.com>
	<alpine.LRH.1.10.0809221902461.6414@pub3.ifh.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-H support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1068359241=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1068359241==
Content-Type: multipart/alternative;
	boundary="----=_Part_62382_26015867.1222108927128"

------=_Part_62382_26015867.1222108927128
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

*Barry*, did you refer to this <http://limbos.wiki.sourceforge.net/>?
(Limbos project). I was looking for a specific Terratec DVB-T receiver to
get it working but I can't find it (many versions of Terratec receivers and
Limbos site doesn't specify which one was used). Which device did you used
to receive DVB-H streams?

*Uri,* what I'm trying to develop is a seamless handover framework based in
the future IEEE 802.21 Media Independent Handover standard (now on draft
stage). This standard is aimed to provide seamless access services provided
through IEEE 802 technologies such as 802.11 or 802.16 and cellular 3G ones=
.
In the latest meetings of IEEE 802.21 working group a study group was
created in order to provide with ideas to include in the standard HO suppor=
t
regarding broadcast/multicast services networks such as DMB and DVB-H with
the other technologies. That's why I want to include DVB-H handover
management in my video streaming application with a handover daemon.

Of course signal strength is not intended to be the only parameter to
consider. Many others like the technical ones you said are to be considered
as well. Also commercial parameters should be taken into account (like
number of clients, roaming agreements and others).

*Uri* and *Patrick*, I thought that dvb-utils (LINUX TV) provided with a
scan application that worked both with DVB-T and DVB-H as shown in Limbos
project site. I thought that through the linux TV API and applications I
could get the PIDs and the ESG properly. Anyway, getting the ESG with
MADFLUTE, parsing it with libxml and then getting the IP stream through the
PAT/PID (dvb-utils) could be possible? I don't know exactly the DVB-H
service flow but once I knew that it can be done then I would read the linu=
x
tv documentation as deep as needed and look for help when necessary.

As said in previous mails, I don't know the linux TV utilities and that's
why I ask if I can get information to manage DVB-H handovers and to decode
the video/audio/data stream and use an application like VLC or a streaming
framework like gstreamer to embed the video in a C++/Java GUI.


Your help is much appreciated, thank you all.

Best regards,
Javi


2008/9/22 Patrick Boettcher <patrick.boettcher@desy.de>

> Hi Javier,
>
> On Mon, 22 Sep 2008, Javier G=E1lvez Guerrero wrote:
>
>> Regarding the ESG I don't know how to deal with it as I'm a complete
>> novice with LinuxTV/dvb-utils. First I wanted to know if it was possible=
 to
>> get DVB-H streams with it and what hardware would be proper. I supposed =
that
>> demuxing and selecting the contents would be nearly the same that in DVB=
-T,
>> as the main difference is the time slicing in DVB-H streams.
>>
>
> It is very different from DVB-T (where the audio/video stream is
> transmitted with MPEG-2 packet stream sections).
>
> In DVB-H you need to discover the IP services with some scan utility (*)
> and then you need to feed the service's IP data (which was requested over=
 a
> multicast join request, for example).
>
> Everything you want is existing as of today, though it might not be easy =
to
> find it (*). You can use dvbsnoop to get the information of which section=
 /
> PID carries which IP service and then you can run dvbnet to have this
> MPE-section demuxed and get the IP-data on the IP-stack.
>
> In dvb-apps you'll find a project called libesg which can be used to
> process the ESG which is carried in a certain section. To receive the ESG
> you need to use a FLUTE-application (e.g. mad flute).
>
> Patrick.
>
> (*) - I'm currently working on a very very basic implementation of a daem=
on
> which is doing the service recovery and the ip-request-to-mpe-section loo=
kup
> for DVB-H. The project was on standby, but I'm planning to fix the latest
> stuff and commit it to dvb-apps this weekend...

------=_Part_62382_26015867.1222108927128
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr">Hi,<br><br><b>Barry</b>, did you refer to <a href=3D"http:=
//limbos.wiki.sourceforge.net/">this</a>? (Limbos project). I was looking f=
or a specific Terratec DVB-T receiver to get it working but I can&#39;t fin=
d it (many versions of Terratec receivers and Limbos site doesn&#39;t speci=
fy which one was used). Which device did you used to receive DVB-H streams?=
<br>
<br><b>Uri,</b> what I&#39;m trying to develop is a seamless handover frame=
work based in the future IEEE 802.21 Media Independent Handover standard (n=
ow on draft stage). This standard is aimed to provide seamless access servi=
ces provided through IEEE 802 technologies such as 802.11 or 802.16 and cel=
lular 3G ones. In the latest meetings of IEEE 802.21 working group a study =
group was created in order to provide with ideas to include in the standard=
 HO support regarding broadcast/multicast services networks such as DMB and=
 DVB-H with the other technologies. That&#39;s why I want to include DVB-H =
handover management in my video streaming application with a handover daemo=
n.<br>
<br>Of course signal strength is not intended to be the only parameter to c=
onsider. Many others like the technical ones you said are to be considered =
as well. Also commercial parameters should be taken into account (like numb=
er of clients, roaming agreements and others).<br>
<br><b>Uri</b> and <b>Patrick</b>, I thought that dvb-utils (LINUX TV) prov=
ided with a scan application that worked both with DVB-T and DVB-H as shown=
 in Limbos project site. I thought that through the linux TV API and applic=
ations I could get the PIDs and the ESG properly. Anyway, getting the ESG w=
ith MADFLUTE, parsing it with libxml and then getting the IP stream through=
 the PAT/PID (dvb-utils) could be possible? I don&#39;t know exactly the DV=
B-H service flow but once I knew that it can be done then I would read the =
linux tv documentation as deep as needed and look for help when necessary.<=
br>
<br>As said in previous mails, I don&#39;t know the linux TV utilities and =
that&#39;s why I ask if I can get information to manage DVB-H handovers and=
 to decode the video/audio/data stream and use an application like VLC or a=
 streaming framework like gstreamer to embed the video in a C++/Java GUI. <=
br>
<br><br>Your help is much appreciated, thank you all.<br><br>Best regards,<=
br>Javi<br><br><br><div class=3D"gmail_quote">2008/9/22 Patrick Boettcher <=
span dir=3D"ltr">&lt;<a href=3D"mailto:patrick.boettcher@desy.de">patrick.b=
oettcher@desy.de</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hi Javier,<div cl=
ass=3D"Ih2E3d"><br>
<br>
On Mon, 22 Sep 2008, Javier G=E1lvez Guerrero wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Regarding the ESG I don&#39;t know how to deal with it as I&#39;m a complet=
e novice with LinuxTV/dvb-utils. First I wanted to know if it was possible =
to get DVB-H streams with it and what hardware would be proper. I supposed =
that demuxing and selecting the contents would be nearly the same that in D=
VB-T, as the main difference is the time slicing in DVB-H streams.<br>

</blockquote>
<br></div>
It is very different from DVB-T (where the audio/video stream is transmitte=
d with MPEG-2 packet stream sections).<br>
<br>
In DVB-H you need to discover the IP services with some scan utility (*) an=
d then you need to feed the service&#39;s IP data (which was requested over=
 a multicast join request, for example).<br>
<br>
Everything you want is existing as of today, though it might not be easy to=
 find it (*). You can use dvbsnoop to get the information of which section =
/ PID carries which IP service and then you can run dvbnet to have this MPE=
-section demuxed and get the IP-data on the IP-stack.<br>

<br>
In dvb-apps you&#39;ll find a project called libesg which can be used to pr=
ocess the ESG which is carried in a certain section. To receive the ESG you=
 need to use a FLUTE-application (e.g. mad flute).<br>
<br>
Patrick.<br>
<br>
(*) - I&#39;m currently working on a very very basic implementation of a da=
emon which is doing the service recovery and the ip-request-to-mpe-section =
lookup for DVB-H. The project was on standby, but I&#39;m planning to fix t=
he latest stuff and commit it to dvb-apps this weekend...</blockquote>
</div><br></div>

------=_Part_62382_26015867.1222108927128--


--===============1068359241==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1068359241==--
