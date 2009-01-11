Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f16.google.com ([209.85.219.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nando4eva@gmail.com>) id 1LM1KP-0003Lo-3L
	for linux-dvb@linuxtv.org; Sun, 11 Jan 2009 15:30:14 +0100
Received: by ewy9 with SMTP id 9so10318483ewy.17
	for <linux-dvb@linuxtv.org>; Sun, 11 Jan 2009 06:29:39 -0800 (PST)
Message-ID: <4116f8730901110629s6d21b5b0td4dfd89044c977cd@mail.gmail.com>
Date: Mon, 12 Jan 2009 01:29:39 +1100
From: "Evan Nando" <nando4eva@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <4116f8730901110619v5108d14en7f59044091a7e99@mail.gmail.com>
MIME-Version: 1.0
References: <4116f8730901110619v5108d14en7f59044091a7e99@mail.gmail.com>
Subject: [linux-dvb] Tuning probs qt1010/AF9005/Linux + XP driver for AF9005
	qt1010
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0176513618=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0176513618==
Content-Type: multipart/alternative;
	boundary="----=_Part_58666_23317636.1231684179289"

------=_Part_58666_23317636.1231684179289
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi everyone,

I have the qt1010 based AF9005 and find it has VERY unreliable tuning in
Linux. It just fails to lock onto channels, even after it has successfully
scanned them The problem does not exist at all in WindowsXP using BlazeDVT.
What I've discovered is the *XP driver* supplied on CD with the AF9005 usb
stick works very well with it, whereas other drivers I've downloaded from
the afatech website give poor tuning (giving less bars in Signal Strength).

I did note on the LinuxTV/dvb-tv forums that others were having the same
problem, probably because of the qt1010 tuning (very choppy in Linux, fine
in Windows). There are no tweaks available as per the mt2060.

The driver that works very well with XP has been uploaded to
http://www.megaupload.com/?d=LU1E55EN (716kb)

Would anyone be willing to extract the firmware from it for use in Linux?
This would be specific qt1010 firmware. I've tried using usbsnoop and
various filters to try to replay the USB sequence and have not gotten
anywhere.

Any other tips on Linux qt1010/AF9005 tuning would be much appreciated. I am
hopeful the qt1010 specific firmware will give better results with Linux.
Would not need to boot into XP anymore to watch TV:)

Setup is: 2.6.27 kernel at the moment and tried both af9005.fw files
available from http://ventoso.org/luca/af9005/.. if that helps.

Best regards,
Nando

------=_Part_58666_23317636.1231684179289
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi everyone,<br><div class="gmail_quote"><div class="gmail_quote"><br>I have the qt1010 based AF9005 and find it has VERY unreliable tuning in Linux. It just fails to lock onto channels, even after it has successfully scanned them The problem does not exist at all in WindowsXP using BlazeDVT. What I&#39;ve discovered is the *XP driver* supplied on CD with the AF9005 usb stick works very well with it, whereas other drivers I&#39;ve downloaded from the afatech website give poor tuning (giving less bars in Signal Strength).<br>

<br>I did note on the LinuxTV/dvb-tv forums
that others were having the same problem, probably because of the
qt1010 tuning (very choppy in Linux, fine in Windows). There are no
tweaks available as per the mt2060. <br>
<br>The driver that works very well with XP has been uploaded to <a href="http://www.megaupload.com/?d=LU1E55EN">http://www.megaupload.com/?d=LU1E55EN</a> (716kb)<br><br>Would anyone be willing to extract the firmware from it for use in Linux? This would be specific qt1010 firmware. I&#39;ve tried using usbsnoop and various filters to try to replay the USB sequence and have not gotten anywhere. <br>



<br>Any other tips on Linux qt1010/AF9005 tuning would be much appreciated. I am hopeful the qt1010 specific firmware will give better results with Linux. Would not need to boot into XP anymore to watch TV:)<br><br>Setup is: 2.6.27 kernel at the moment and tried both af9005.fw files available from <a href="http://ventoso.org/luca/af9005/" target="_blank">http://ventoso.org/luca/af9005/</a>.. if that helps.<br>


<br>Best regards,<br>Nando<br>
</div>
</div>

------=_Part_58666_23317636.1231684179289--


--===============0176513618==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0176513618==--
