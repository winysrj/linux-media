Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael@stepanoff.org>) id 1K5Px9-0007jc-Da
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 20:49:20 +0200
Received: by wa-out-1112.google.com with SMTP id n7so1368361wag.13
	for <linux-dvb@linuxtv.org>; Sun, 08 Jun 2008 11:49:13 -0700 (PDT)
Message-ID: <65922d730806081149j2ba9085bm1984155ebf8eebd2@mail.gmail.com>
Date: Sun, 8 Jun 2008 21:49:13 +0300
From: "Michael Stepanov" <michael@stepanoff.org>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] TT-Budget/WinTV-NOVA-CI is recognized as sound card
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0864869148=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0864869148==
Content-Type: multipart/alternative;
	boundary="----=_Part_16217_30557572.1212950953503"

------=_Part_16217_30557572.1212950953503
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I have following problem with my TT-Budget/WinTV-NOVA-CI DVB card. It's
recognized as Audiowerk2 sound card instead of DVB:

linuxmce@dcerouter:~$ cat /proc/asound/cards
 0 [Audiowerk2     ]: aw2 - Audiowerk2
                      Audiowerk2 with SAA7146 irq 16
 1 [NVidia         ]: HDA-Intel - HDA NVidia
                      HDA NVidia at 0xfe020000 irq 20

This is what I can see in the dmesg output:
[   81.311527] saa7146: register extension 'budget_ci dvb'.

I use LinxuMCE which is built on the top of Kubuntu Gutsy, AMD64.

Linux dcerouter 2.6.22-14-generic #1 SMP Sun Oct 14 21:45:15 GMT 2007
x86_64 GNU/Linux

Any suggestion how to solve that will be very appreciated.

Thanks in advance.


-- 
Cheers,
Michael

------=_Part_16217_30557572.1212950953503
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,<br><br>I have following problem with my TT-Budget/WinTV-NOVA-CI DVB card. It&#39;s recognized as Audiowerk2 sound card instead of DVB:<br><pre style="margin-top: 0pt; display: inline;">linuxmce@dcerouter:~$ cat /proc/asound/cards<br>
&nbsp;0 [Audiowerk2&nbsp; &nbsp; &nbsp;]: aw2 - Audiowerk2<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Audiowerk2 with SAA7146 irq 16<br>&nbsp;1 [NVidia&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;]: HDA-Intel - HDA NVidia<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; HDA NVidia at 0xfe020000 irq 20<br><br>This is what I can see in the dmesg output:<br>
[&nbsp; &nbsp;81.311527] saa7146: register extension &#39;budget_ci dvb&#39;.<br><br>I use LinxuMCE which is built on the top of Kubuntu Gutsy, AMD64.<br><br>Linux dcerouter 2.6.22-14-generic #1 SMP Sun Oct 14 21:45:15 GMT 2007 x86_64 GNU/Linux<br>
<br>Any suggestion how to solve that will be very appreciated.<br><br>Thanks in advance.<br></pre><br>-- <br>Cheers,<br>Michael

------=_Part_16217_30557572.1212950953503--


--===============0864869148==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0864869148==--
