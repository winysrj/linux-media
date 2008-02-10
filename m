Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.239])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darkdrgn2k@gmail.com>) id 1JOEAE-0007E1-GK
	for linux-dvb@linuxtv.org; Sun, 10 Feb 2008 16:32:18 +0100
Received: by wr-out-0506.google.com with SMTP id 68so3680263wra.13
	for <linux-dvb@linuxtv.org>; Sun, 10 Feb 2008 07:32:17 -0800 (PST)
Message-ID: <9b75db150802100732h2a855cc0s6cc7dff36206a207@mail.gmail.com>
Date: Sun, 10 Feb 2008 10:32:16 -0500
From: "Dark Dragon" <darkdrgn2k@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Subject: [linux-dvb] CX88 Nova-S Not locking
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0801680103=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0801680103==
Content-Type: multipart/alternative;
	boundary="----=_Part_15401_3347038.1202657536913"

------=_Part_15401_3347038.1202657536913
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Ok, so i been doing tones of test on my Nova-S

i have taking a direct cable from the LNB and fed it into my Nova-S plus,
removing any multiswitches and such
I have alos swapped cards with a freind with the same card.

Here are the results.

Both cards lock on HIS computer with kernel 22
My cards will ONLY lock on my computer with kernel 18
Any kernel 22 or above gives me a Signal  of 5100 to 5A00 only.


My SZAP with His Card:

[root@MYTH szap]# ./szap -a1 -lDBS ABCD



reading channels from file '/root/.szap/channels.conf'



zapping to 1244 'ABCD':



sat 0, frequency = 12443 MHz V, symbolrate 20000000, vpid = 0x0000, apid =
0x0000



using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'



status 01 | signal 6500 | snr 9a4c | ber 00000000 | unc fffffffe |



status 01 | signal 5f00 | snr 9be5 | ber 00000000 | unc fffffffe |



status 01 | signal 5f00 | snr 9f21 | ber 00000000 | unc fffffffe |



 \



---- His lock with My Card ---



[root@xandir szap]# ./szap -a0 -lDBS ABC

reading channels from file '/root/.szap/channels.conf'

zapping to 8 'ABC:

sat 0, frequency = 12238 MHz H, symbolrate 20000000, vpid = 0x1522, apid =
0x1523

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'

status 01 | signal ea00 | snr 0549 | ber 00000000 | unc fffffffe |

status 01 | signal f900 | snr ab34 | ber 00000000 | unc fffffffe |

status 1f | signal f900 | snr d986 | ber 00000000 | unc fffffffe |
FE_HAS_LOCK

status 1f | signal f900 | snr daeb | ber 00000000 | unc fffffffe |
FE_HAS_LOCK

status 1f | signal f900 | snr d90a | ber 00000000 | unc fffffffe |
FE_HAS_LOCK

status 1f | signal f900 | snr d9df | ber 00047f61 | unc fffffffe |
FE_HAS_LOCK





What does this indicate?!?! any ideas at all???

------=_Part_15401_3347038.1202657536913
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div>Ok, so i been doing tones of test on my Nova-S</div>
<div>&nbsp;</div>
<div>i have taking a direct cable from the LNB and fed it into my Nova-S plus, removing any multiswitches and such</div>
<div>I have alos swapped cards with a freind with the same card. </div>
<div>&nbsp;</div>
<div>Here are the results.</div>
<div>&nbsp;</div>
<div>Both cards lock on HIS computer with kernel 22</div>
<div>My cards will ONLY lock on my computer with kernel 18</div>
<div>Any kernel 22 or above gives me a Signal&nbsp; of 5100 to 5A00 only.</div>
<div>&nbsp;</div>
<div>&nbsp;</div>
<div>My SZAP with His Card:</div>
<div>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Times New Roman">[root@MYTH szap]# ./szap -a1 -lDBS ABCD</font></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Times New Roman">&nbsp;</font></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Times New Roman">reading channels from file &#39;/root/.szap/channels.conf&#39;</font></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Times New Roman">&nbsp;</font></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Times New Roman">zapping to 1244 &#39;ABCD&#39;:</font></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Times New Roman">&nbsp;</font></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Times New Roman">sat 0, frequency = 12443 MHz V, symbolrate 20000000, vpid = 0x0000, apid = 0x0000</font></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Times New Roman">&nbsp;</font></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Times New Roman">using &#39;/dev/dvb/adapter1/frontend0&#39; and &#39;/dev/dvb/adapter1/demux0&#39;</font></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Times New Roman">&nbsp;</font></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Times New Roman">status 01 | signal 6500 | snr 9a4c | ber 00000000 | unc fffffffe |</font></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Times New Roman">&nbsp;</font></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Times New Roman">status 01 | signal 5f00 | snr 9be5 | ber 00000000 | unc fffffffe |</font></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Times New Roman">&nbsp;</font></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Times New Roman">status 01 | signal 5f00 | snr 9f21 | ber 00000000 | unc fffffffe |</font></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Times New Roman">&nbsp;</font></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="mso-spacerun: yes"><font face="Times New Roman">&nbsp;\</font></span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="mso-spacerun: yes"><font face="Times New Roman"></font></span>&nbsp;</p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="mso-spacerun: yes"><font face="Times New Roman">---- His lock with My Card ---</font></span></p><span style="mso-spacerun: yes">
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt">&nbsp;</p>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt">[root@xandir szap]# ./szap -a0 -lDBS ABC</p>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt">reading channels from file &#39;/root/.szap/channels.conf&#39;</p>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt">zapping to 8 &#39;ABC:</p>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt">sat 0, frequency = 12238 MHz H, symbolrate 20000000, vpid = 0x1522, apid = 0x1523</p>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt">using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#39;</p>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt">status 01 | signal ea00 | snr 0549 | ber 00000000 | unc fffffffe |</p>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt">status 01 | signal f900 | snr ab34 | ber 00000000 | unc fffffffe |</p>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt">status 1f | signal f900 | snr d986 | ber 00000000 | unc fffffffe | FE_HAS_LOCK</p>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt">status 1f | signal f900 | snr daeb | ber 00000000 | unc fffffffe | FE_HAS_LOCK</p>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt">status 1f | signal f900 | snr d90a | ber 00000000 | unc fffffffe | FE_HAS_LOCK</p>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt">status 1f | signal f900 | snr d9df | ber 00047f61 | unc fffffffe | FE_HAS_LOCK</p>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt">&nbsp;</p>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt">&nbsp;</p>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt">What does this indicate?!?! any ideas at all???</p></span></div>

------=_Part_15401_3347038.1202657536913--


--===============0801680103==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0801680103==--
