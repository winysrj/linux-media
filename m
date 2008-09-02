Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KaMIA-0006Bk-Bq
	for linux-dvb@linuxtv.org; Tue, 02 Sep 2008 05:10:57 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	42E9A180089B
	for <linux-dvb@linuxtv.org>; Tue,  2 Sep 2008 03:10:06 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: lhuizinga@iinet.net.au
Date: Tue, 2 Sep 2008 13:10:05 +1000
Message-Id: <20080902031006.2421D1BF28D@ws1-10.us4.outblaze.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Compro DVB T300 Card support under ArchLinux
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0966587255=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0966587255==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_1220325006117490"

This is a multi-part message in MIME format.

--_----------=_1220325006117490
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

  ----- Original Message -----
  From: "lhuizinga@iinet.net.au"
  To: stev391@email.com
  Subject: Re: [linux-dvb] Compro DVB T300 Card support under ArchLinux
  Date: Tue, 02 Sep 2008 10:31:36 +0800

  Hi Stephen,
  Thanks for that.
  I don't mind looking through that information on those links when i
  get a mo, howerver,...
  The card I have is probably a lot older than the one you mention.
  It is a PCI card, T300
  http://www.comprousa.com/en/product/vmt300.html
  I believe it used the phillips chip saa7134 for dvb.  I am not sure
  which chip the E300 has.
  Should I still be looking through those docs, or is the solution much
  simpler (hopefully ... :) ).
  Larry


  On Tue Sep 2 8:11 , stev391@email.com sent:

    > Hi,
    > Was wondering if anyone knew what was necessary to get a compro
    dvb t-300
    > card working with Freevo, with Archlinux as a base. Do i need
    to download
    > firmware etc. My LC17 Box will be running at 64-bit on an intel
    945 board
    > with p4-D 3.0Ghz. Have only installed Archlinux as yet.
    >
    > Is there support for this card in the latest kernels (and is
    there
    > anectdotal evidence of it working in Freevo or Myth if I have
    to, or
    > should i look at another (newer) card)? Obviously i will really
    only be
    > interested in the digital tv tuner part of this hybrid card,
    and the video
    > capture function. Cheers,
    > Larry

    Larry,

    Is this the card, you are referring to:
    http://www.comprousa.com/en/product/e300/e300.html

    If so at the moment I'm writing patches that should add support
    for this card.

    Could you please read this and complete the steps that I have
    listed for your card:
    http://linuxtv.org/pipermail/linux-dvb/2008-August/028090.html

    If the details generated are similar to:
    http://linuxtv.org/wiki/index.php/Compro_VideoMate_E650
    Or
    http://linuxtv.org/wiki/index.php/Compro_VideoMate_E800F
    You can try the other links below to see if it will work.

    Read (At the bottom, or you can catch up on the conversation,
    note that the main v4l-dvb tree should now be used instead of the
    cx23885-leadtek tree):
    http://linuxtv.org/pipermail/linux-dvb/2008-August/028233.html
    And do the steps listed, please provide the requested feedback to
    me.

    Then if this does not work read this one (At the bottom, or you
    can catch up on the conversation):
    http://linuxtv.org/pipermail/linux-dvb/2008-August/028341.html
    And same deal the feedback would be great.

    As I do not own any of the cards referenced above the previous
    links provide me with the required information to get the DVB-T
    side of the card working.

    At least one person has the E800 working in MythTV (the DVB-T is
    the same on both cards) so I do not see any issues. I'm not
    familiar with Arch Linux or Freevo, but give it a try.

    Thanks, for your time.

    Stephen.


Larry,

Sorry my mistake, I misread the subject line.  The information that I
posted is not relevant for this card.  Maybe somebody else will be able
to help you.

Regards,
Stephen.

--=20
Nothing says Labor Day like 500hp of American muscle
Visit OnCars.com today.


--_----------=_1220325006117490
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div>
<br>
<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: "lhuizinga@iinet.net.au" <lhuizinga@iinet.net.au><br>
To: stev391@email.com<br>
Subject: Re: [linux-dvb] Compro DVB T300 Card support under ArchLinux<br>
Date: Tue, 02 Sep 2008 10:31:36 +0800<br>
<br>


Hi Stephen,<br>
Thanks for that.<br>
I don't mind looking through that information on those links when i get a m=
o, howerver,...<br>
The card I have is probably a lot older than the one you mention.<br>
It is a PCI card, T300 <a href=3D"http://www.comprousa.com/en/product/vmt30=
0.html">http://www.comprousa.com/en/product/vmt300.html</a><br>
I believe it used the phillips chip saa7134 for dvb.&nbsp; I am not sure wh=
ich chip the E300 has.<br>
Should I still be looking through those docs, or is the solution much simpl=
er (hopefully ... :) ).<br>
Larry<br>
<br>
<br>
<b>On Tue Sep 2 8:11 , stev391@email.com sent:<br>
<br>
</b>
<blockquote style=3D"border-left: 2px solid rgb(245, 245, 245); padding-rig=
ht: 0px; padding-left: 5px; margin-left: 5px; margin-right: 0px;">&gt; Hi,<=
br>
&gt; Was wondering if anyone knew what was necessary to get a compro dvb t-=
300<br>
&gt; card working with Freevo, with Archlinux as a base. Do i need to downl=
oad<br>
&gt; firmware etc. My LC17 Box will be running at 64-bit on an intel 945 bo=
ard<br>
&gt; with p4-D 3.0Ghz. Have only installed Archlinux as yet.<br>
&gt; <br>
&gt; Is there support for this card in the latest kernels (and is there<br>
&gt; anectdotal evidence of it working in Freevo or Myth if I have to, or<b=
r>
&gt; should i look at another (newer) card)? Obviously i will really only b=
e<br>
&gt; interested in the digital tv tuner part of this hybrid card, and the v=
ideo<br>
&gt; capture function. Cheers,<br>
&gt; Larry<br>
<br>
Larry,<br>
<br>
Is this the card, you are referring to:<br>
<a href=3D"parse.pl?redirect=3Dhttp%3A%2F%2Fwww.comprousa.com%2Fen%2Fproduc=
t%2Fe300%2Fe300.html" target=3D"_blank"><span style=3D"color: rgb(255, 0, 0=
);">http://www.comprousa.com/en/product/e300/e300.html</span></a><br>
<br>
If so at the moment I'm writing patches that should add support for this ca=
rd.<br>
<br>
Could you please read this and complete the steps that I have listed for yo=
ur card:<br>
<a href=3D"parse.pl?redirect=3Dhttp%3A%2F%2Flinuxtv.org%2Fpipermail%2Flinux=
-dvb%2F2008-August%2F028090.html" target=3D"_blank"><span style=3D"color: r=
gb(255, 0, 0);">http://linuxtv.org/pipermail/linux-dvb/2008-August/028090.h=
tml</span></a><br>
<br>
If the details generated are similar to:<br>
<a href=3D"parse.pl?redirect=3Dhttp%3A%2F%2Flinuxtv.org%2Fwiki%2Findex.php%=
2FCompro_VideoMate_E650" target=3D"_blank"><span style=3D"color: rgb(255, 0=
, 0);">http://linuxtv.org/wiki/index.php/Compro_VideoMate_E650</span></a><b=
r>
Or<br>
<a href=3D"parse.pl?redirect=3Dhttp%3A%2F%2Flinuxtv.org%2Fwiki%2Findex.php%=
2FCompro_VideoMate_E800F" target=3D"_blank"><span style=3D"color: rgb(255, =
0, 0);">http://linuxtv.org/wiki/index.php/Compro_VideoMate_E800F</span></a>=
<br>
You can try the other links below to see if it will work.<br>
<br>
Read (At the bottom, or you can catch up on the conversation, note that the=
 main v4l-dvb tree should now be used instead of the cx23885-leadtek tree):=
<br>
<a href=3D"parse.pl?redirect=3Dhttp%3A%2F%2Flinuxtv.org%2Fpipermail%2Flinux=
-dvb%2F2008-August%2F028233.html" target=3D"_blank"><span style=3D"color: r=
gb(255, 0, 0);">http://linuxtv.org/pipermail/linux-dvb/2008-August/028233.h=
tml</span></a><br>
And do the steps listed, please provide the requested feedback to me.<br>
<br>
Then if this does not work read this one (At the bottom, or you can catch u=
p on the conversation):<br>
<a href=3D"parse.pl?redirect=3Dhttp%3A%2F%2Flinuxtv.org%2Fpipermail%2Flinux=
-dvb%2F2008-August%2F028341.html" target=3D"_blank"><span style=3D"color: r=
gb(255, 0, 0);">http://linuxtv.org/pipermail/linux-dvb/2008-August/028341.h=
tml</span></a><br>
And same deal the feedback would be great.<br>
<br>
As I do not own any of the cards referenced above the previous links provid=
e me with the required information to get the DVB-T side of the card workin=
g.<br>
<br>
At least one person has the E800 working in MythTV (the DVB-T is the same o=
n both cards) so I do not see any issues. I'm not familiar with Arch Linux =
or Freevo, but give it a try.<br>
<br>
Thanks, for your time.<br>
<br>
Stephen.<br>
</blockquote></lhuizinga@iinet.net.au></blockquote><lhuizinga@iinet.net.au>=
</lhuizinga@iinet.net.au><br>Larry,<br><br>Sorry my mistake, I misread the =
subject line.&nbsp; The information that I posted is not relevant for this =
card.&nbsp; Maybe somebody else will be able to help you.<br><br>Regards,<b=
r>Stephen.<br>
</div>
<BR>

--=20
<div> Nothing says Labor Day like 500hp of American muscle<br>
Visit <a href=3D"http://www.oncars.com/video/134/2008-Ford-Mustang-Shelby-G=
T500-Part-3-of-3-Performance" target=3D"_blank">OnCars.com</a> today.</div>

--_----------=_1220325006117490--



--===============0966587255==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0966587255==--
