Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.234])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <picholicho@gmail.com>) id 1LH27r-0005qP-2x
	for linux-dvb@linuxtv.org; Sun, 28 Dec 2008 21:20:40 +0100
Received: by rv-out-0506.google.com with SMTP id b25so4455744rvf.41
	for <linux-dvb@linuxtv.org>; Sun, 28 Dec 2008 12:20:33 -0800 (PST)
Message-ID: <7b1b1f8d0812281220o3a8f1558ga330905c063ff069@mail.gmail.com>
Date: Sun, 28 Dec 2008 22:20:33 +0200
From: "Ilia Penev" <picholicho@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] Gigabyte U8000 remote control how to use it?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0850513229=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0850513229==
Content-Type: multipart/alternative;
	boundary="----=_Part_77282_22957556.1230495633469"

------=_Part_77282_22957556.1230495633469
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

i downloaded 1.20 from the link . nothing happens with the remote.


---------
You can get the firmware from here:

http://www.wi-bw.tfh-wildau.de/~pboettch/home/files/dvb-usb-dib0700-1.20.fw<http://www.wi-bw.tfh-wildau.de/%7Epboettch/home/files/dvb-usb-dib0700-1.20.fw>

Note that the firmware has not changed recently - the bug was in the
Linux driver and how it interacted with the 1.20 firmware.

Devin

2008/12/14 Devin Heitmueller <devin.heitmueller@gmail.com>

> 2008/12/14 Ilia Penev <picholicho@gmail.com>:
> > Hello there.
> > i decide to find out how to run remote control.
> > dmesg says some codes.
> > dib0700: Unknown remote controller key : 18 43
> >
> > i write them in dib0700_device.c
> > /*Gigabyte keys*/
> >     { 0x18,0x43, KEY_POWER },
> >     { 0x1e, 0x7d, KEY_0 },
> >     { 0x14, 0x7f, KEY_1 },
> >     { 0x19, 0x7c, KEY_2 },
> >     { 0x1d, 0x7d, KEY_3 },
> >     { 0x1c, 0x72, KEY_4 },
> >     { 0x13, 0x4e, KEY_5 },
> >     { 0x1b, 0x4c, KEY_6 },
> >     { 0x14, 0x70, KEY_7 },
> >     { 0x1e, 0x72, KEY_8 },
> >     { 0x11, 0x4e, KEY_9 },
> >     { 0x14, 0x40, KEY_VOLUMEUP },
> >     { 0x1c, 0x42, KEY_VOLUMEDOWN },
> >     { 0x10, 0x41, KEY_CHANNELUP },
> >     { 0x1b, 0x7c, KEY_CHANNELDOWN },
> >     { 0x13, 0x7e, KEY_MUTE },
> > //    { 0x12, 0x7e, KEY_FM },
> > //    { 0x1d, 0x42, KEY_VIDEOS },
> >     { 0x15, 0x40, KEY_TV },
> > //    { 0x1a, 0x7c, KEY_SNAPSHOT },
> >     { 0x11, 0x41, KEY_LAST },
> >     { 0x18, 0x7c, KEY_EPG },
> >     { 0x1a, 0x43, KEY_BACK },
> >     { 0x19, 0x4c, KEY_OK },
> >     { 0x16, 0x70, KEY_UP },
> >     { 0x12, 0x41, KEY_DOWN },
> >     { 0x16, 0x7F, KEY_LEFT },
> >     { 0x19, 0x43, KEY_RIGHT },
> >
> > how to define commented keys? in ir-keymaps.c? or somewhere else.
> > i have problem when i put 1.20 firmware nothing happens with the remote
> > control. with 1.10 when i press 5 apears 5 in console or where it is the
> > cursor.
> > remote appears as /dev/input/eventXX
> > tell me some suggestions.
> > many thanks :)
> >
> > Ilia
>
> Hell Ilia,
>
> Given the way dib0700 does remote controls, the change you proposed is
> the correct way to add new remotes.  If you send a patch to the
> mailing list, Patrick Boettcher is the person likely to merge it since
> he is the dib0700 maintainer.
>
> I really should work on getting the dib0700 driver integrated with
> ir_keymaps.c so that the it is consistent with other drivers.
>
> Regarding the 1.20 firmware, are you running the latest v4l-dvb code
> from http://linuxtv.org/hg/v4l-dvb?  There were bugs in firmware
> version 1.20 IR support that have been fixed in the last couple of
> weeks.
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>

------=_Part_77282_22957556.1230495633469
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

i downloaded 1.20 from the link . nothing happens with the remote.<br><br><br>---------<br>You can get the firmware from here:<br>
<br>
<a href="http://www.wi-bw.tfh-wildau.de/%7Epboettch/home/files/dvb-usb-dib0700-1.20.fw" target="_blank">http://www.wi-bw.tfh-wildau.de/~pboettch/home/files/dvb-usb-dib0700-1.20.fw</a><br>
<br>
Note that the firmware has not changed recently - the bug was in the<br>
Linux driver and how it interacted with the 1.20 firmware.<br>
<font color="#888888"><br>
Devin</font><br><br><div class="gmail_quote">2008/12/14 Devin Heitmueller <span dir="ltr">&lt;<a href="mailto:devin.heitmueller@gmail.com">devin.heitmueller@gmail.com</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
2008/12/14 Ilia Penev &lt;<a href="mailto:picholicho@gmail.com">picholicho@gmail.com</a>&gt;:<br>
<div><div></div><div class="Wj3C7c">&gt; Hello there.<br>
&gt; i decide to find out how to run remote control.<br>
&gt; dmesg says some codes.<br>
&gt; dib0700: Unknown remote controller key : 18 43<br>
&gt;<br>
&gt; i write them in dib0700_device.c<br>
&gt; /*Gigabyte keys*/<br>
&gt; &nbsp; &nbsp; { 0x18,0x43, KEY_POWER },<br>
&gt; &nbsp; &nbsp; { 0x1e, 0x7d, KEY_0 },<br>
&gt; &nbsp; &nbsp; { 0x14, 0x7f, KEY_1 },<br>
&gt; &nbsp; &nbsp; { 0x19, 0x7c, KEY_2 },<br>
&gt; &nbsp; &nbsp; { 0x1d, 0x7d, KEY_3 },<br>
&gt; &nbsp; &nbsp; { 0x1c, 0x72, KEY_4 },<br>
&gt; &nbsp; &nbsp; { 0x13, 0x4e, KEY_5 },<br>
&gt; &nbsp; &nbsp; { 0x1b, 0x4c, KEY_6 },<br>
&gt; &nbsp; &nbsp; { 0x14, 0x70, KEY_7 },<br>
&gt; &nbsp; &nbsp; { 0x1e, 0x72, KEY_8 },<br>
&gt; &nbsp; &nbsp; { 0x11, 0x4e, KEY_9 },<br>
&gt; &nbsp; &nbsp; { 0x14, 0x40, KEY_VOLUMEUP },<br>
&gt; &nbsp; &nbsp; { 0x1c, 0x42, KEY_VOLUMEDOWN },<br>
&gt; &nbsp; &nbsp; { 0x10, 0x41, KEY_CHANNELUP },<br>
&gt; &nbsp; &nbsp; { 0x1b, 0x7c, KEY_CHANNELDOWN },<br>
&gt; &nbsp; &nbsp; { 0x13, 0x7e, KEY_MUTE },<br>
&gt; // &nbsp; &nbsp;{ 0x12, 0x7e, KEY_FM },<br>
&gt; // &nbsp; &nbsp;{ 0x1d, 0x42, KEY_VIDEOS },<br>
&gt; &nbsp; &nbsp; { 0x15, 0x40, KEY_TV },<br>
&gt; // &nbsp; &nbsp;{ 0x1a, 0x7c, KEY_SNAPSHOT },<br>
&gt; &nbsp; &nbsp; { 0x11, 0x41, KEY_LAST },<br>
&gt; &nbsp; &nbsp; { 0x18, 0x7c, KEY_EPG },<br>
&gt; &nbsp; &nbsp; { 0x1a, 0x43, KEY_BACK },<br>
&gt; &nbsp; &nbsp; { 0x19, 0x4c, KEY_OK },<br>
&gt; &nbsp; &nbsp; { 0x16, 0x70, KEY_UP },<br>
&gt; &nbsp; &nbsp; { 0x12, 0x41, KEY_DOWN },<br>
&gt; &nbsp; &nbsp; { 0x16, 0x7F, KEY_LEFT },<br>
&gt; &nbsp; &nbsp; { 0x19, 0x43, KEY_RIGHT },<br>
&gt;<br>
&gt; how to define commented keys? in ir-keymaps.c? or somewhere else.<br>
&gt; i have problem when i put 1.20 firmware nothing happens with the remote<br>
&gt; control. with 1.10 when i press 5 apears 5 in console or where it is the<br>
&gt; cursor.<br>
&gt; remote appears as /dev/input/eventXX<br>
&gt; tell me some suggestions.<br>
&gt; many thanks :)<br>
&gt;<br>
&gt; Ilia<br>
<br>
</div></div>Hell Ilia,<br>
<br>
Given the way dib0700 does remote controls, the change you proposed is<br>
the correct way to add new remotes. &nbsp;If you send a patch to the<br>
mailing list, Patrick Boettcher is the person likely to merge it since<br>
he is the dib0700 maintainer.<br>
<br>
I really should work on getting the dib0700 driver integrated with<br>
ir_keymaps.c so that the it is consistent with other drivers.<br>
<br>
Regarding the 1.20 firmware, are you running the latest v4l-dvb code<br>
from <a href="http://linuxtv.org/hg/v4l-dvb" target="_blank">http://linuxtv.org/hg/v4l-dvb</a>? &nbsp;There were bugs in firmware<br>
version 1.20 IR support that have been fixed in the last couple of<br>
weeks.<br>
<br>
Devin<br>
<font color="#888888"><br>
--<br>
Devin J. Heitmueller<br>
<a href="http://www.devinheitmueller.com" target="_blank">http://www.devinheitmueller.com</a><br>
AIM: devinheitmueller<br>
</font></blockquote></div><br>

------=_Part_77282_22957556.1230495633469--


--===============0850513229==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0850513229==--
