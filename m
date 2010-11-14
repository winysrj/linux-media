Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <dnw3039@gmail.com>) id 1PHV0J-0005pG-22
	for linux-dvb@linuxtv.org; Sun, 14 Nov 2010 06:19:51 +0100
Received: from mail-pv0-f182.google.com ([74.125.83.182])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1PHV0I-0001qz-AW; Sun, 14 Nov 2010 06:19:50 +0100
Received: by pvc22 with SMTP id 22so1138776pvc.41
	for <linux-dvb@linuxtv.org>; Sat, 13 Nov 2010 21:19:48 -0800 (PST)
Message-ID: <4CDF716E.2090905@internode.on.net>
Date: Sun, 14 Nov 2010 16:19:42 +1100
From: David Wilson <dnw3039@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] DVB Driver for DiBcom's DiB7000M does not support the
 remote control for the kaiserbass TVStick
Reply-To: linux-media@vger.kernel.org, dnwilson@chenopod.net
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1710642620=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1710642620==
Content-Type: multipart/alternative;
 boundary="------------080707060909020108020500"

This is a multi-part message in MIME format.
--------------080707060909020108020500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


I have purchased the  kaiserbass TVStick product ID 'KBA01007-KB DVD-T 
USB TUNER WITH 2 GB MEMORY'. The Linux-DVB Driver for DiBcom's DiB7000M 
driver works very well for video, but the software driver does not 
support the slim 28 key remote control provided by  kaiserbass.

The evidence is the error codes in the system log. For example pressing 
any key causes a system log error, the volume up key results in the 
system error message:

2010-11-14 13:07:26    Capulet    kernel    [10464.828505] dib0700: 
Unknown remote controller key: 0000 2b d4


I tried adding a new set of key codes to the DiB7000M-devices.c file i.e.

{ 0x2bd4, KEY_VOLUMEUP },

but this did not work, perhaps I have used the wrong conversion or 
format for the key values.
Here are the key values from the system error messages

KEY_MUTE            0AF5
KEY_SOURCE          38C7
KEY_SCREEN          0FF0
KEY_POWER           0CF3
KEY_1               01FE
KEY_2               02FD
KEY_3               03FC
KEY_4               04FB
KEY_5               05FA
KEY_6               06F9
KEY_7               07F8
KEY_8               08F7
KEY_9               09F6
KEY_0               00FF
KEY_UP              20DF
KEY_ESC             29D6
KEY_FASTFORWARD     1EE1
KEY_LEFT            11EE
KEY_OK              0DF2
KEY_RIGHT           10EF
KEY_VOLUMEUP        2BD4
KEY_CHANNELUP       12ED
KEY_DOWN            21DE
KEY_STOP            0BF4
KEY_CHANNELDOWN     13EC
KEY_VOLUMEDOWN      2CD3
KEY_SCREEN_COPY     0EF1
KEY_RECORD          1FEO

regards

David Wilson

--------------080707060909020108020500
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
  </head>
  <body text="#000000" bgcolor="#ffffff">
    <br>
    I have purchased the&nbsp; kaiserbass TVStick product ID 'KBA01007-KB
    DVD-T USB TUNER WITH 2 GB MEMORY'. The Linux-DVB Driver for DiBcom's
    DiB7000M driver works very well for video, but the software driver
    does not support the slim 28 key remote control provided by&nbsp;
    kaiserbass.<br>
    <br>
    The evidence is the error codes in the system log. For example
    pressing any key causes a system log error, the volume up key
    results in the system error message:<br>
    <tt><br>
      2010-11-14 13:07:26&nbsp;&nbsp;&nbsp; Capulet&nbsp;&nbsp;&nbsp; kernel&nbsp;&nbsp;&nbsp; [10464.828505]
      dib0700: Unknown remote controller key: 0000 2b d4</tt><br>
    <br>
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <br>
    I tried adding a new set of key codes to the DiB7000M-devices.c file
    i.e.<br>
    <tt><br>
      { 0x2bd4, KEY_VOLUMEUP },</tt><br>
    <br>
    but this did not work, perhaps I have used the wrong conversion or
    format for the key values.<br>
    Here are the key values from the system error messages <br>
    <br>
    <style type="text/css">p { margin-bottom: 0.21cm; }</style><tt>KEY_MUTE&nbsp;&nbsp;&nbsp;
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0AF5&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <br>
      KEY_SOURCE&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; 38C7<br>
      KEY_SCREEN &nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; 0FF0<br>
      KEY_POWER&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp; 0CF3<br>
      KEY_1 &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp; 01FE<br>
      KEY_2&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 02FD<br>
      KEY_3&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 03FC<br>
      KEY_4&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 04FB<br>
      KEY_5 &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp; 05FA<br>
      KEY_6&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 06F9<br>
      KEY_7&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 07F8<br>
      KEY_8&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 08F7<br>
      KEY_9&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 09F6<br>
      KEY_0&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 00FF<br>
      KEY_UP&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20DF<br>
      KEY_ESC&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 29D6<br>
      KEY_FASTFORWARD&nbsp;&nbsp;&nbsp;&nbsp; 1EE1<br>
      KEY_LEFT&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 11EE<br>
      KEY_OK&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp; 0DF2<br>
      KEY_RIGHT&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp; 10EF<br>
      KEY_VOLUMEUP&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 2BD4<br>
      KEY_CHANNELUP &nbsp;&nbsp;&nbsp; &nbsp; 12ED<br>
      KEY_DOWN&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 21DE<br>
      KEY_STOP &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0BF4<br>
      KEY_CHANNELDOWN &nbsp;&nbsp;&nbsp; 13EC<br>
      KEY_VOLUMEDOWN &nbsp;&nbsp;&nbsp;&nbsp; 2CD3<br>
      KEY_SCREEN_COPY&nbsp;&nbsp;&nbsp;&nbsp; 0EF1<br>
      KEY_RECORD &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 1FEO<br>
    </tt><br>
    regards<br>
    <br>
    David Wilson<br>
  </body>
</html>

--------------080707060909020108020500--


--===============1710642620==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1710642620==--
