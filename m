Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KPF7t-0004P5-9Z
	for linux-dvb@linuxtv.org; Sat, 02 Aug 2008 13:18:23 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	D4D1918013AE
	for <linux-dvb@linuxtv.org>; Sat,  2 Aug 2008 11:17:44 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "Jonathan Hummel" <jhhummel@bigpond.com>
Date: Sat, 2 Aug 2008 21:17:44 +1000
Message-Id: <20080802111744.C36DF47808F@ws1-5.us4.outblaze.com>
Cc: linux dvb mailing list <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Leadtek Winfast PxDVR 3200 H
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0113065547=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0113065547==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_121767586464750"

This is a multi-part message in MIME format.

--_----------=_121767586464750
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

 Jon,

Your email got my interest.  I was looking for a card with those specs
here in Australia, so I went and bought one... (However, thankyou for
your photo)

I was unable to get RegSpy to work with this card in windows for some
reason, so I was unable to verify those results.

So far I have only spend an hour or so working on a driver, I have worked
out the tuner and demod i2c addresses. However I need to work out how it
selects analog or digital mode and gets the video. So in other words the
easy bits are done but nothing is working yet...

When I get a working driver done, I will let you (and the mailing list)
know.=20

Anybody can provide any guidance it would be useful.

Regards,
Stephen.

  ----- Original Message -----
  From: "Jonathan Hummel"
  To: stev391@email.com
  Subject: Re: [linux-dvb] Leadtek Winfast PxDVR 3200 H
  Date: Sat, 02 Aug 2008 17:43:45 +1000


  Hi Stephen

  There was already a page of sorts:
  http://www.linuxtv.org/wiki/index.php/Leadtek_Winfast_PxDVR_3200_H
  I've added to it. I don't have winodws on that machine, but it apears
  someone has done that for me already.
  I have some more photos, of even higher res is you want them, but
  won't
  clutter up everyone's inbox if not need/ wanted.

  Cheers

  Jon



  On Mon, 2008-07-28 at 08:55 +1000, stev391@email.com wrote:
  > Jon,
  >
  > It appears that this card uses the CX23885 PCIe controller.
  >
  > From initial research on the Leadtek site it appears that this card
  > utilises the following main chips:
  > Conexant CX23885 - PCIe Interface
  > Conexant CX23417 - Analog Video to MPEG2 Encoder
  > Intel CE6353 - Digital TV Demodulator (Formerly known as Zarlink
  > 10353)
  > Xceive ????? - Digital TV Tuner,
  >
  > All of the above that I have identified have drivers in linux in
  > various stages of development.
  >
  > Can you take a high res photo of the card showing all chip IDs?
  > Can you identify which tuner from Xceive it is?
  > Do you have a partition set up with windows and the card working?
  > If so can you use regspy (Google "Dscaler Regspy" to find the
  > correct program), and record what the values are for:
  > - Card sitting idle straight after bootup
  > - Watching Digital TV
  > - Watching Analog TV
  > - Sitting idle after watching TV
  >
  > What is the output of `lspci -vnn` when in linux regarding this
  card?
  >
  > What does `dmesg | grep cx23885` give you?
  >
  > It might also be useful for others who have this card if you make
  an
  > entry the linuxtv wiki for this card, with all of the information
  that
  > I have requested linked to or included.
  >
  > I may be able to knock up a driver that you can use for the digital
  TV
  > side as this seems similar to other existing cards, I'm not
  familiar
  > with the Analog side though. (No gurantees, but it should be
  > relatively simple to achieve).
  >
  > Regards,
  >
  > Stephen.
  >
  >
  > --- Original Message ---
  > Hi,
  >
  > I was wondering if anyone could help me get this card up and
  > working in
  > kubuntu 8.04. I've tried setting it up much like a Leadtek
  > DTV2000H,
  > version J, as per instructions here:
  > http://wiki.linuxmce.org/index.php/Leadtek_DTV2000H
  > (I've been using that card for a while in another box)
  >
  > System:
  > Gibagyte moher board (all in one) GA-MA78GM-S2H
  > AMD Athlon X2 6000 (2 core, 3GHz)
  > 4G ram, heaps of hard disk
  > 64bit KDE 4 kubuntu, kernel: 2.6.24-20 generic
  >
  > http://www.linuxtv.org/wiki/index.php/DVB-T_PCIe_Cards
  > suggested I email this address.
  >
  >
  > cheers
  >
  > Jon
  >
  >
  >
  >
  > -- Be Yourself @ mail.com!
  > Choose From 200+ Email Addresses
  > Get a Free Account at www.mail.com!

--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_121767586464750
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div>
Jon,<br><br>Your email got my interest.&nbsp; I was looking for a card with=
 those specs here in Australia, so I went and bought one... (However, thank=
you for your photo)<br><br>I was unable to get RegSpy to work with this car=
d in windows for some reason, so I was unable to verify those results.<br><=
br>So far I have only spend an hour or so working on a driver, I have worke=
d out the tuner and demod i2c addresses. However I need to work out how it =
selects analog or digital mode and gets the video. So in other words the ea=
sy bits are done but nothing is working yet...<br><br>When I get a working =
driver done, I will let you (and the mailing list) know.&nbsp; <br><br>Anyb=
ody can provide any guidance it would be useful.<br><br>Regards,<br>Stephen=
.<br>
<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: "Jonathan Hummel" <jhhummel@bigpond.com><br>
To: stev391@email.com<br>
Subject: Re: [linux-dvb] Leadtek Winfast PxDVR 3200 H<br>
Date: Sat, 02 Aug 2008 17:43:45 +1000<br>
<br>

<br>
Hi Stephen<br>
<br>
There was already a page of sorts:<br>
http://www.linuxtv.org/wiki/index.php/Leadtek_Winfast_PxDVR_3200_H<br>
I've added to it. I don't have winodws on that machine, but it apears<br>
someone has done that for me already.<br>
I have some more photos, of even higher res is you want them, but won't<br>
clutter up everyone's inbox if not need/ wanted.<br>
<br>
Cheers<br>
<br>
Jon<br>
<br>
<br>
<br>
On Mon, 2008-07-28 at 08:55 +1000, stev391@email.com wrote:<br>
&gt; Jon,<br>
&gt;<br>
&gt; It appears that this card uses the CX23885 PCIe controller.<br>
&gt;<br>
&gt; From initial research on the Leadtek site it appears that this card<br>
&gt; utilises the following main chips:<br>
&gt; Conexant CX23885 - PCIe Interface<br>
&gt; Conexant CX23417 - Analog Video to MPEG2 Encoder<br>
&gt; Intel CE6353 - Digital TV Demodulator (Formerly known as Zarlink<br>
&gt; 10353)<br>
&gt; Xceive ????? - Digital TV Tuner,<br>
&gt;<br>
&gt; All of the above that I have identified have drivers in linux in<br>
&gt; various stages of development.<br>
&gt;<br>
&gt; Can you take a high res photo of the card showing all chip IDs?<br>
&gt; Can you identify which tuner from Xceive it is?<br>
&gt; Do you have a partition set up with windows and the card working?<br>
&gt;    If so can you use regspy (Google "Dscaler Regspy" to find the<br>
&gt; correct program), and record what the values are for:<br>
&gt;       - Card sitting idle straight after bootup<br>
&gt;       - Watching Digital TV<br>
&gt;       - Watching Analog TV<br>
&gt;       - Sitting idle after watching TV<br>
&gt;<br>
&gt; What is the output of `lspci -vnn` when in linux regarding this card?<=
br>
&gt;<br>
&gt; What does `dmesg | grep cx23885` give you?<br>
&gt;<br>
&gt; It might also be useful for others who have this card if you make an<b=
r>
&gt; entry the linuxtv wiki for this card, with all of the information that=
<br>
&gt; I have requested linked to or included.<br>
&gt;<br>
&gt; I may be able to knock up a driver that you can use for the digital TV=
<br>
&gt; side as this seems similar to other existing cards, I'm not familiar<b=
r>
&gt; with the Analog side though. (No gurantees, but it should be <br>
&gt; relatively simple to achieve).<br>
&gt;<br>
&gt; Regards,<br>
&gt;<br>
&gt; Stephen.<br>
&gt;<br>
&gt;<br>
&gt; --- Original Message ---<br>
&gt; Hi,<br>
&gt;<br>
&gt;          I was wondering if anyone could help me get this card up and<=
br>
&gt;          working in<br>
&gt;          kubuntu 8.04. I've tried setting it up much like a Leadtek<br>
&gt;          DTV2000H,<br>
&gt;          version J, as per instructions here:<br>
&gt;          http://wiki.linuxmce.org/index.php/Leadtek_DTV2000H<br>
&gt;          (I've been using that card for a while in another box)<br>
&gt;<br>
&gt;          System:<br>
&gt;          Gibagyte moher board (all in one) GA-MA78GM-S2H<br>
&gt;          AMD Athlon X2 6000 (2 core, 3GHz)<br>
&gt;          4G ram, heaps of hard disk<br>
&gt;          64bit KDE 4 kubuntu, kernel: 2.6.24-20 generic<br>
&gt;<br>
&gt;          http://www.linuxtv.org/wiki/index.php/DVB-T_PCIe_Cards<br>
&gt;          suggested I email this address.<br>
&gt;<br>
&gt;<br>
&gt;          cheers<br>
&gt;<br>
&gt;          Jon<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; -- Be Yourself @ mail.com!<br>
&gt; Choose From 200+ Email Addresses<br>
&gt; Get a Free Account at www.mail.com!<br>
</jhhummel@bigpond.com></blockquote>
</div>
<BR>

--=20
<div> Be Yourself @ mail.com!<br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com/Product.aspx" t=
arget=3D"_blank">www.mail.com</a>!</div>

--_----------=_121767586464750--



--===============0113065547==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0113065547==--
