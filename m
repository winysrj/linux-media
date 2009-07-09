Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <qbasic16@gmail.com>) id 1MOpcs-0005wh-5s
	for linux-dvb@linuxtv.org; Thu, 09 Jul 2009 11:09:10 +0200
Received: by ewy10 with SMTP id 10so16060ewy.17
	for <linux-dvb@linuxtv.org>; Thu, 09 Jul 2009 02:08:35 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 9 Jul 2009 11:08:35 +0200
Message-ID: <f659d8b30907090208m776a9782p2a414b802b865054@mail.gmail.com>
From: Peter Janser <qbasic16@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Status of Lite-On TVT-1060 support (unknown frontend)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1004659452=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1004659452==
Content-Type: multipart/alternative; boundary=0016364c765b5a1a79046e423352

--0016364c765b5a1a79046e423352
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi

Maybe some of you have already heard some questions about the linux support
of the DVB-T card "Lite On TVT-1060", but all discussions about this card
said that it is not supported on linux for now, because nobody knows the
frontend (chip). some also said, that you'd have to unsolder the shielding
to get the name of the frontend chip.... and I won't try that as you may
understand ;-)
I've got this "unsupported" tvt-1060 in my Asus G2S and would like to get it
run.....

Operating system:
Kubuntu 9.04 Jaunty Jackalope
Kernel 2.6.28-13-generic


With the help of g00gle i have found some infos about this tv-card:

On one site, "Homocidical Teddy" wrote
"The card itself is sold as a Liteon TL-1060, however it's actually a
reference-design USB Tuner using the DibCom 7700C1 dvb-t chip and an UNKNOWN
frontend."

Found on
http://forums.whirlpool.net.au/forum-replies-archive.cfm/995988.html


After reading that (especially the last posts) I did some tests and edits
(logically in the v4l-dvb source folder):

With the command "lsusb" i got the Vendor and the Product ID: "04ca:f016"

"0x04ca" for "Lite On Technology"
(to find in "~/Progs/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h")

"0xf016" should stand for "TVT-1060" or another name of this dvb-t card...
but with "lsusb -v" the "idProduct" is empty.
This is because there is no entry for "f016" in
"~/Progs/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h".


Well, as the patch mentioned (on the site above) and with a bit imagination
and something like that I added

#define USB_PID_LITEON_TVT_1060                0xf016

to the Product ID section in the file "dvb-usb-ids.h" (mentioned before)
after that i added also

{ USB_DEVICE(USB_VID_LITEON,    USB_PID_LITEON_TVT_1060) },

to the line 1501 (right above the "{ 0 }" entry) in the file
"~/Progs/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c"
As i found out before, there is the struct declaration "struct usb_device_id
dib0700_usb_id_table[] = { ...........}") which is as you know a device
table.

After these steps I took a look at "struct dvb_usb_device_properties
dib0700_devices[] = {...........}" (in "dib0700_devices.c") and there was my
problem!
In this struct you can find entrys for the frontend and tuner attach
describing an adapter and also a devices list for each of these different
adapters......



NOW MY PROBLEM:
In which of these sections (starting with "{
DIB0700_DEFAULT_DEVICE_PROPERTIES,") should I add a device entry for my
Lite-On TVT-1060 ?
Or should I write a complete new one?

I have already tried this entry

            {   "Lite-On TVT-1060",
                { &dib0700_usb_id_table[54], NULL },
                { NULL },
            },

in the device section for the adapter "stk7700d_...._attach" (frontend and
tuner).
Oh, and by the way don't forget to modify "num_device_descs =", it may
prevent from errors I think....don't know exactly why... =)

The device entry above made my dvb-t card appear in dmesg after the command
"sudo modprobe dvb-usb-dib0700".
dmesg output:

[ 2336.075406] dib0700: loaded with support for 9 different device-types
[ 2336.075499] dvb-usb: found a 'Lite-On TVT-1060' in cold state, will try
to load a firmware
[ 2336.075502] usb 1-4: firmware: requesting dvb-usb-dib0700-1.20.fw
[ 2336.189540] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.20.fw'
[ 2336.392856] dib0700: firmware started successfully.
[ 2336.897028] dvb-usb: found a 'Lite-On TVT-1060' in warm state.
[ 2336.897079] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[ 2336.897224] DVB: registering new adapter (Lite-On TVT-1060)
[ 2336.945991] dib0700: stk7700d_frontend_attach: dib7000p_i2c_enumeration
failed.  Cannot continue
[ 2336.945993]
[ 2336.945997] dvb-usb: no frontend was attached by 'Lite-On TVT-1060'
[ 2336.945999] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[ 2336.946320] DVB: registering new adapter (Lite-On TVT-1060)
[ 2336.947040] dvb-usb: no frontend was attached by 'Lite-On TVT-1060'
[ 2336.947094] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1a.7/usb1/1-4/input/input14
[ 2336.989093] dvb-usb: schedule remote query interval to 50 msecs.
[ 2336.989098] dvb-usb: Lite-On TVT-1060 successfully initialized and
connected.
[ 2336.989268] usbcore: registered new interface driver dvb_usb_dib0700

Now the following command shows what I have:
ls -lR /dev/dvb/
/dev/dvb/:
insgesamt 0
drwxr-xr-x 2 root root 100 2009-07-09 10:52 adapter0
drwxr-xr-x 2 root root 100 2009-07-09 10:52 adapter1

/dev/dvb/adapter0:
insgesamt 0
crw-rw----+ 1 root video 212, 0 2009-07-09 10:52 demux0
crw-rw----+ 1 root video 212, 1 2009-07-09 10:52 dvr0
crw-rw----+ 1 root video 212, 2 2009-07-09 10:52 net0

/dev/dvb/adapter1:
insgesamt 0
crw-rw----+ 1 root video 212, 3 2009-07-09 10:52 demux0
crw-rw----+ 1 root video 212, 4 2009-07-09 10:52 dvr0
crw-rw----+ 1 root video 212, 5 2009-07-09 10:52 net0

Unfortunately I can't watch anything on these devices......
Now I reached my borders of knowledge =)

Thanks for any replies!
Peter

--
-------------------------------------------
Greetings from Switzerland
Thanks UBS for ruining a good reputation >:-(

--0016364c765b5a1a79046e423352
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi<br><br clear=3D"all"></div><div>Maybe some of you have already hear=
d some questions about the linux support of the DVB-T card &quot;Lite On TV=
T-1060&quot;, but all discussions about this card said that it is not suppo=
rted on linux for now, because nobody knows the frontend (chip). some also =
said, that you&#39;d have to unsolder the shielding to get the name of the =
frontend chip.... and I won&#39;t try that as you may understand ;-)<br>


</div><div>I&#39;ve got this &quot;unsupported&quot; tvt-1060 in my Asus G2=
S and would like to get it run.....<br><br></div>
<div>Operating system:</div><div>Kubuntu 9.04 Jaunty Jackalope</div><div>Ke=
rnel 2.6.28-13-generic<br><br></div><div><br>With the help of g00gle i have=
 found some infos about this tv-card:</div><div>
</div><div><br>On one site, &quot;Homocidical Teddy&quot; wrote</div>
<div>&quot;The card itself is sold as a Liteon TL-1060, however it&#39;s ac=
tually a reference-design USB Tuner using the DibCom 7700C1 dvb-t chip and =
an UNKNOWN frontend.&quot;</div><div><br>Found on <a href=3D"http://forums.=
whirlpool.net.au/forum-replies-archive.cfm/995988.html" target=3D"_blank">h=
ttp://forums.whirlpool.net.au/forum-replies-archive.cfm/995988.html</a></di=
v>



<div><br><br>After reading that (especially the last posts) I did some test=
s and edits (logically in the v4l-dvb source folder):<br><br>With the comma=
nd &quot;lsusb&quot; i got the Vendor and the Product ID: &quot;04ca:f016&q=
uot;<br>


<br>&quot;0x04ca&quot; for &quot;Lite On Technology&quot;<br>(to find in &q=
uot;~/Progs/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h&quot;)<br=
><br>&quot;0xf016&quot; should stand for &quot;TVT-1060&quot; or another na=
me of this dvb-t card... but with &quot;lsusb -v&quot; the &quot;idProduct&=
quot; is empty.<br>


This is because there is no entry for &quot;f016&quot; in &quot;~/Progs/v4l=
-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h&quot;.<br><br><br>Well, =
as the patch mentioned (on the site above) and with a bit imagination and s=
omething like that I added<br>


<br>#define USB_PID_LITEON_TVT_1060=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =
0xf016<br><br>to the Product ID section in the file &quot;dvb-usb-ids.h&quo=
t; (mentioned before)<br>after that i added also<br><br>{ USB_DEVICE(USB_VI=
D_LITEON,=A0=A0=A0 USB_PID_LITEON_TVT_1060) },<br>


<br>to the line 1501 (right above the &quot;{ 0 }&quot; entry) in the file =
&quot;~/Progs/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c&quo=
t;<br>As i found out before, there is the struct declaration &quot;struct u=
sb_device_id
dib0700_usb_id_table[] =3D { ...........}&quot;) which is as you know a dev=
ice table.<br><br>After these steps I took a look at &quot;struct dvb_usb_d=
evice_properties dib0700_devices[] =3D {...........}&quot; (in &quot;dib070=
0_devices.c&quot;) and there was my problem!<br>


In this struct you can find entrys for the frontend and tuner attach descri=
bing an adapter and also a devices list for each of these different adapter=
s......<br><br><br><br>NOW MY PROBLEM:<br>In which of these sections (start=
ing with &quot;{ DIB0700_DEFAULT_DEVICE_PROPERTIES,&quot;) should I add a d=
evice entry for my Lite-On TVT-1060 ?<br>
Or should I write a complete new one?<br>

<br>I have already tried this entry<br><br>=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 {=
=A0=A0 &quot;Lite-On TVT-1060&quot;,<br>=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=
=A0=A0 { &amp;dib0700_usb_id_table[54], NULL },<br>=A0=A0=A0 =A0=A0=A0 =A0=
=A0=A0 =A0=A0=A0 { NULL },<br>=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 },<br><br>in th=
e device section for the adapter &quot;stk7700d_...._attach&quot; (frontend=
 and tuner).<br>


Oh, and by the way don&#39;t forget to modify &quot;num_device_descs =3D&qu=
ot;, it may prevent from errors I think....don&#39;t know exactly why... =
=3D)<br><br>The device entry above made my dvb-t card appear in dmesg after=
 the command &quot;sudo modprobe dvb-usb-dib0700&quot;.<br>


dmesg output:<br><br>[ 2336.075406] dib0700: loaded with support for 9 diff=
erent device-types<br>[ 2336.075499] dvb-usb: found a &#39;Lite-On TVT-1060=
&#39; in cold state, will try to load a firmware<br>[ 2336.075502] usb 1-4:=
 firmware: requesting dvb-usb-dib0700-1.20.fw<br>
[ 2336.189540] dvb-usb: downloading firmware from file &#39;dvb-usb-dib0700=
-1.20.fw&#39;<br>[ 2336.392856] dib0700: firmware started successfully.<br>=
[ 2336.897028] dvb-usb: found a &#39;Lite-On TVT-1060&#39; in warm state.<b=
r>
[ 2336.897079] dvb-usb: will pass the complete MPEG2 transport stream to th=
e software demuxer.<br>[ 2336.897224] DVB: registering new adapter (Lite-On=
 TVT-1060)<br>[ 2336.945991] dib0700: stk7700d_frontend_attach: dib7000p_i2=
c_enumeration failed.=A0 Cannot continue<br>
[ 2336.945993]<br>[ 2336.945997] dvb-usb: no frontend was attached by &#39;=
Lite-On TVT-1060&#39;<br>[ 2336.945999] dvb-usb: will pass the complete MPE=
G2 transport stream to the software demuxer.<br>[ 2336.946320] DVB: registe=
ring new adapter (Lite-On TVT-1060)<br>
[ 2336.947040] dvb-usb: no frontend was attached by &#39;Lite-On TVT-1060&#=
39;<br>[ 2336.947094] input: IR-receiver inside an USB DVB receiver as /dev=
ices/pci0000:00/0000:00:1a.7/usb1/1-4/input/input14<br>[ 2336.989093] dvb-u=
sb: schedule remote query interval to 50 msecs.<br>
[ 2336.989098] dvb-usb: Lite-On TVT-1060 successfully initialized and conne=
cted.<br>[ 2336.989268] usbcore: registered new interface driver dvb_usb_di=
b0700<br><br>Now the following command shows what I have:<br>ls -lR /dev/dv=
b/<br>
/dev/dvb/:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 <br>insgesamt 0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 <br>drwxr-xr-x 2 root root 100 2009-07-09 10:52 adapter0<br>dr=
wxr-xr-x 2 root root 100 2009-07-09 10:52 adapter1<br><br>/dev/dvb/adapter0=
:<br>
insgesamt 0=A0=A0=A0=A0=A0=A0 <br>crw-rw----+ 1 root video 212, 0 2009-07-0=
9 10:52 demux0<br>crw-rw----+ 1 root video 212, 1 2009-07-09 10:52 dvr0=A0 =
<br>crw-rw----+ 1 root video 212, 2 2009-07-09 10:52 net0=A0 <br><br>/dev/d=
vb/adapter1:<br>
insgesamt 0=A0=A0=A0=A0=A0=A0 <br>crw-rw----+ 1 root video 212, 3 2009-07-0=
9 10:52 demux0<br>crw-rw----+ 1 root video 212, 4 2009-07-09 10:52 dvr0=A0 =
<br>crw-rw----+ 1 root video 212, 5 2009-07-09 10:52 net0<br><br>Unfortunat=
ely I can&#39;t watch anything on these devices......<br>
Now I reached my borders of knowledge =3D)<br><br>Thanks for any replies!<b=
r>Peter<br><br></div><div></div><div>--</div><div>-------------------------=
------------------<br></div>Greetings from Switzerland <br>Thanks UBS for r=
uining a good reputation &gt;:-(<br>



--0016364c765b5a1a79046e423352--


--===============1004659452==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1004659452==--
