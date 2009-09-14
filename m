Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f223.google.com ([209.85.219.223])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <peterjolson@gmail.com>) id 1MnCgd-00008p-J4
	for linux-dvb@linuxtv.org; Mon, 14 Sep 2009 16:37:48 +0200
Received: by ewy23 with SMTP id 23so2832645ewy.26
	for <linux-dvb@linuxtv.org>; Mon, 14 Sep 2009 07:37:14 -0700 (PDT)
MIME-Version: 1.0
From: "Peter J. Olson" <peterjolson@gmail.com>
Date: Mon, 14 Sep 2009 09:36:54 -0500
Message-ID: <64a476a80909140736k159fddffle1d6ccbcaa3cecfb@mail.gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Compile error when I get to snd-go7007.c
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1793662930=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1793662930==
Content-Type: multipart/alternative; boundary=001636c5a7fb0d622d04738a9a52

--001636c5a7fb0d622d04738a9a52
Content-Type: text/plain; charset=ISO-8859-1

Hey all,

I have a Mythbuntu 8.10 system w/ a pctv 800i (pci card) and a pctv hd stick
(800e). Had both running just fine for about 8 months... then the stick
stopped working.  Or rather, it works but wont pick up a signal.

I decided I would update my system a little and figure out what broke my
800e. I updated my kernel and went to recompile v4l-dvb and got this error:

  CC [M]  /home/mythbox/Firmware/v4l-dvb/v4l/snd-go7007.o

/home/mythbox/Firmware/v4l-dvb/v4l/snd-go7007.c: In function
'go7007_snd_init':

/home/mythbox/Firmware/v4l-dvb/v4l/snd-go7007.c:251: error: implicit
declaration of function 'snd_card_create'

make[3]: *** [/home/mythbox/Firmware/v4l-dvb/v4l/snd-go7007.o] Error 1

make[2]: *** [_module_/home/mythbox/Firmware/v4l-dvb/v4l] Error 2

make[2]: Leaving directory `/usr/src/linux-headers-2.6.28-15-generic'

make[1]: *** [default] Error 2

make[1]: Leaving directory `/home/mythbox/Firmware/v4l-dvb/v4l'

make: *** [all] Error 2

I was using the old copy of v4l I had so I thought it might have been the
new kernel fighting w/ the old v4l. So I updated v4l (did a pull via hg)...
same error.

I dinked w/ it for a long time and finally gave up and upgraded to 9.0.4.
Same error, now neither of my cards will work (brutal!)  My 800i is acting
like the 800e was.  I can see the card in mythbackend setup but always gets
no signal in mythtv.

I dont even know what the snd-go7007 would go with... I dont even have that
type of hardware (i dont think).

Anyone have any ideas?

Thanks,
Peter

--001636c5a7fb0d622d04738a9a52
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hey all,<br><br>I have a Mythbuntu 8.10 system w/ a pctv 800i (pci card) an=
d a pctv hd
stick (800e). Had both running just fine for about 8 months... then the
stick stopped working.=A0 Or rather, it works but wont pick up a signal.<br=
><br>I decided I would update my system a little and figure out what broke
my 800e. I updated my kernel and went to recompile v4l-dvb and got this
error:<br><br>=A0 CC [M]=A0 /home/mythbox/Firmware/v4l-dvb/v4l/snd-go7007.o=
<br><br>/home/mythbox/Firmware/v4l-dvb/v4l/snd-go7007.c: In function &#39;g=
o7007_snd_init&#39;:<br><br>/home/mythbox/Firmware/v4l-dvb/v4l/snd-go7007.c=
:251: error: implicit declaration of function &#39;snd_card_create&#39;<br>

<br>make[3]: *** [/home/mythbox/Firmware/v4l-dvb/v4l/snd-go7007.o] Error 1<=
br><br>make[2]: *** [_module_/home/mythbox/Firmware/v4l-dvb/v4l] Error 2<br=
><br>make[2]: Leaving directory `/usr/src/linux-headers-2.6.28-15-generic&#=
39;<br>

<br>make[1]: *** [default] Error 2<br><br>make[1]: Leaving directory `/home=
/mythbox/Firmware/v4l-dvb/v4l&#39;<br><br>make: *** [all] Error 2<br><br>I =
was using the old copy of v4l I had so I thought it might have been
the new kernel fighting w/ the old v4l. So I updated v4l (did a pull via hg=
)... same error.
<br>
<br>
I dinked w/ it for a long time and finally gave up and upgraded to
9.0.4. Same error, now neither of my cards will work (brutal!)=A0 My 800i i=
s acting like the 800e was.=A0 I can see the card in mythbackend setup but =
always gets no signal in mythtv. <br>
<br>
I dont even know what the snd-go7007 would go with... I dont even have that=
 type of hardware (i dont think).<br>
<br>
Anyone have any ideas?<br><br>Thanks,<br>Peter<br>

--001636c5a7fb0d622d04738a9a52--


--===============1793662930==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1793662930==--
