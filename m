Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.232])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <picholicho@gmail.com>) id 1LBuSu-0006rF-M6
	for linux-dvb@linuxtv.org; Sun, 14 Dec 2008 18:09:13 +0100
Received: by rv-out-0506.google.com with SMTP id b25so2200708rvf.41
	for <linux-dvb@linuxtv.org>; Sun, 14 Dec 2008 09:09:07 -0800 (PST)
Message-ID: <7b1b1f8d0812140909s63e74ab8g838f755f891c073f@mail.gmail.com>
Date: Sun, 14 Dec 2008 19:09:06 +0200
From: "Ilia Penev" <picholicho@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Gigabyte U8000 remote control who to use it?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0927799980=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0927799980==
Content-Type: multipart/alternative;
	boundary="----=_Part_22929_4290039.1229274546824"

------=_Part_22929_4290039.1229274546824
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello there.
i decide to find out how to run remote control.
dmesg says some codes.
*dib0700*: *Unknown remote controller* key : 18 43

i write them in dib0700_device.c
/*Gigabyte keys*/
    { 0x18,0x43, KEY_POWER },
    { 0x1e, 0x7d, KEY_0 },
    { 0x14, 0x7f, KEY_1 },
    { 0x19, 0x7c, KEY_2 },
    { 0x1d, 0x7d, KEY_3 },
    { 0x1c, 0x72, KEY_4 },
    { 0x13, 0x4e, KEY_5 },
    { 0x1b, 0x4c, KEY_6 },
    { 0x14, 0x70, KEY_7 },
    { 0x1e, 0x72, KEY_8 },
    { 0x11, 0x4e, KEY_9 },
    { 0x14, 0x40, KEY_VOLUMEUP },
    { 0x1c, 0x42, KEY_VOLUMEDOWN },
    { 0x10, 0x41, KEY_CHANNELUP },
    { 0x1b, 0x7c, KEY_CHANNELDOWN },
    { 0x13, 0x7e, KEY_MUTE },
//    { 0x12, 0x7e, KEY_FM },
//    { 0x1d, 0x42, KEY_VIDEOS },
    { 0x15, 0x40, KEY_TV },
//    { 0x1a, 0x7c, KEY_SNAPSHOT },
    { 0x11, 0x41, KEY_LAST },
    { 0x18, 0x7c, KEY_EPG },
    { 0x1a, 0x43, KEY_BACK },
    { 0x19, 0x4c, KEY_OK },
    { 0x16, 0x70, KEY_UP },
    { 0x12, 0x41, KEY_DOWN },
    { 0x16, 0x7F, KEY_LEFT },
    { 0x19, 0x43, KEY_RIGHT },

how to define commented keys? in ir-keymaps.c? or somewhere else.
i have problem when i put 1.20 firmware nothing happens with the remote
control. with 1.10 when i press 5 apears 5 in console or where it is the
cursor.
remote appears as /dev/input/eventXX
tell me some suggestions.
many thanks :)

Ilia

------=_Part_22929_4290039.1229274546824
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello there. <br>i decide to find out how to run remote control. <br>dmesg says some codes.<br><em>dib0700</em>: <em>Unknown remote controller</em> key : 18 43 <br><br>i write them in dib0700_device.c<br>/*Gigabyte keys*/<br>
&nbsp;&nbsp;&nbsp; { 0x18,0x43, KEY_POWER },<br>&nbsp;&nbsp;&nbsp; { 0x1e, 0x7d, KEY_0 },<br>&nbsp;&nbsp;&nbsp; { 0x14, 0x7f, KEY_1 },<br>&nbsp;&nbsp;&nbsp; { 0x19, 0x7c, KEY_2 },<br>&nbsp;&nbsp;&nbsp; { 0x1d, 0x7d, KEY_3 },<br>&nbsp;&nbsp;&nbsp; { 0x1c, 0x72, KEY_4 },<br>&nbsp;&nbsp;&nbsp; { 0x13, 0x4e, KEY_5 },<br>&nbsp;&nbsp;&nbsp; { 0x1b, 0x4c, KEY_6 },<br>
&nbsp;&nbsp;&nbsp; { 0x14, 0x70, KEY_7 },<br>&nbsp;&nbsp;&nbsp; { 0x1e, 0x72, KEY_8 },<br>&nbsp;&nbsp;&nbsp; { 0x11, 0x4e, KEY_9 },<br>&nbsp;&nbsp;&nbsp; { 0x14, 0x40, KEY_VOLUMEUP },<br>&nbsp;&nbsp;&nbsp; { 0x1c, 0x42, KEY_VOLUMEDOWN },<br>&nbsp;&nbsp;&nbsp; { 0x10, 0x41, KEY_CHANNELUP },<br>&nbsp;&nbsp;&nbsp; { 0x1b, 0x7c, KEY_CHANNELDOWN },<br>
&nbsp;&nbsp;&nbsp; { 0x13, 0x7e, KEY_MUTE },<br>//&nbsp;&nbsp;&nbsp; { 0x12, 0x7e, KEY_FM },<br>//&nbsp;&nbsp;&nbsp; { 0x1d, 0x42, KEY_VIDEOS },<br>&nbsp;&nbsp;&nbsp; { 0x15, 0x40, KEY_TV },<br>//&nbsp;&nbsp;&nbsp; { 0x1a, 0x7c, KEY_SNAPSHOT },<br>&nbsp;&nbsp;&nbsp; { 0x11, 0x41, KEY_LAST },<br>&nbsp;&nbsp;&nbsp; { 0x18, 0x7c, KEY_EPG },<br>
&nbsp;&nbsp;&nbsp; { 0x1a, 0x43, KEY_BACK },<br>&nbsp;&nbsp;&nbsp; { 0x19, 0x4c, KEY_OK },<br>&nbsp;&nbsp;&nbsp; { 0x16, 0x70, KEY_UP },<br>&nbsp;&nbsp;&nbsp; { 0x12, 0x41, KEY_DOWN },<br>&nbsp;&nbsp;&nbsp; { 0x16, 0x7F, KEY_LEFT },<br>&nbsp;&nbsp;&nbsp; { 0x19, 0x43, KEY_RIGHT },<br><br>how to define commented keys? in ir-keymaps.c? or somewhere else. <br>
i have problem when i put 1.20 firmware nothing happens with the remote control. with 1.10 when i press 5 apears 5 in console or where it is the cursor. <br>remote appears as /dev/input/eventXX<br>tell me some suggestions. <br>
many thanks :)<br><br>Ilia<br><br><br><br>

------=_Part_22929_4290039.1229274546824--


--===============0927799980==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0927799980==--
