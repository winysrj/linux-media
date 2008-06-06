Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mredmon@gmail.com>) id 1K4Ttm-0002EK-Lr
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 06:50:02 +0200
Received: by ug-out-1314.google.com with SMTP id m3so673758uge.20
	for <linux-dvb@linuxtv.org>; Thu, 05 Jun 2008 21:49:54 -0700 (PDT)
Message-ID: <10c7f7790806052149v5c86e7a5h16e6a4b7683fcec0@mail.gmail.com>
Date: Thu, 5 Jun 2008 21:49:52 -0700
From: "Matthew Redmon" <mredmon@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] DViCO FusionHDTV 5 Lite, Latest Kernel Drivers,
	& Video Corruption
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0484887950=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0484887950==
Content-Type: multipart/alternative;
	boundary="----=_Part_3173_6304529.1212727794527"

------=_Part_3173_6304529.1212727794527
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi!  I've been trying to get my two DViCO FusionHDTV 5 Lite cards working
with a new install of FC9.  Everything seems to work just fine except that
the video I get from the cards is corrupt (see video at:
http://www.youtube.com/watch?v=rH1tsiPB8us).  I know the cards are fine, as
they worked on this machine previously using FC5 and they currently work if
I boot into Windows XP.

I am using the drivers included in the 2.6.25.3-18 kernel to record QAM-256
cable from Comcast in Seattle, WA.

The cards are correctly auto-detected as card 135 with tuners 0043 & 0061.
I scanned for channels using dvb-apps and used a script to cut down the ~250
channels found to just those that would tune (presumably, the unencrypted
channels).  Of those 56, they all have the corruption seen in the video.

Any ideas?

Thanks!

~Matt

------=_Part_3173_6304529.1212727794527
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi!&nbsp; I&#39;ve been trying to get my two DViCO FusionHDTV 5 Lite cards working with a new install of FC9.&nbsp; Everything seems to work just fine except that the video I get from the cards is corrupt (see video at: <a href="http://www.youtube.com/watch?v=rH1tsiPB8us">http://www.youtube.com/watch?v=rH1tsiPB8us</a>).&nbsp; I know the cards are fine, as they worked on this machine previously using FC5 and they currently work if I boot into Windows XP.<br>
<br>I am using the drivers included in the 2.6.25.3-18 kernel to record QAM-256 cable from Comcast in Seattle, WA.<br><br>The cards are correctly auto-detected as card 135 with tuners 0043 &amp; 0061.&nbsp; I scanned for channels using dvb-apps and used a script to cut down the ~250 channels found to just those that would tune (presumably, the unencrypted channels).&nbsp; Of those 56, they all have the corruption seen in the video.<br>
<br>Any ideas?<br><br>Thanks!<br><br>~Matt<br>

------=_Part_3173_6304529.1212727794527--


--===============0484887950==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0484887950==--
