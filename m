Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zeno.zoli@gmail.com>) id 1K8iv8-0001PY-LM
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 23:41:10 +0200
Received: by mu-out-0910.google.com with SMTP id w8so3521291mue.1
	for <linux-dvb@linuxtv.org>; Tue, 17 Jun 2008 14:39:54 -0700 (PDT)
Message-ID: <45e226e50806171439k56fcb996r7a1cf659412bb0e2@mail.gmail.com>
Date: Tue, 17 Jun 2008 23:39:54 +0200
From: "Zeno Zoli" <zeno.zoli@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] TerraTec_Cinergy_S2_PCI_HD_CI Playback flicker or
	stream issue.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0171202524=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0171202524==
Content-Type: multipart/alternative;
	boundary="----=_Part_15688_16089853.1213738794428"

------=_Part_15688_16089853.1213738794428
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

So I got my card working, partly.
Followed this guide, and got some help from here.
http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI

My next challenge is to get playback working correctly. This might be caused
by poor ATI driver support. I've got 8.5 Catalyst installed. Read that 8.3
had some flicker issue in playback. Anyway I just wanted to sort out if my
problems might be caused by the dvb-s2 mantis drivers or my ATI drivers. Got
Radeon 2400 HD. Excuse me if this is a bit off-topic

Tried mplayer (also gmplayer and xine) xine dont work.

mplayer -vo xv /dev/dvb/adapter0/dvr0

Stream flicker, seems like it drops a lot of frames. 2 out of 3, or there is
problems with the stream from the dvb-s2 card (How could I debug that)
Testing on "The Poker Channel" mpeg2 SD channel.

AMD 64 3500+ 1GB RAM. (would think that would cover most streams)

Googled around, but haven't found anyone with a similar problem.
Anyone got a clue, before I head over to a linux video playback forum?

------=_Part_15688_16089853.1213738794428
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

So I got my card working, partly. <br>Followed this guide, and got some help from here.<br><a href="http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI" target="_blank">http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI</a><br>
<br>My next challenge is to get playback working correctly. This might be caused by poor ATI driver support. I&#39;ve got 8.5 Catalyst installed. Read that 8.3 had some flicker issue in playback. Anyway I just wanted to sort out if my problems might be caused by the dvb-s2 mantis drivers or my ATI drivers. Got Radeon 2400 HD. Excuse me if this is a bit off-topic<br>
<br>Tried mplayer (also gmplayer and xine) xine dont work. <br><br>mplayer -vo xv /dev/dvb/adapter0/dvr0<br><br>Stream flicker, seems like it drops a lot of frames. 2 out of 3, or there is problems with the stream from the dvb-s2 card (How could I debug that) Testing on &quot;The Poker Channel&quot; mpeg2 SD channel.<br>
<br>AMD 64 3500+ 1GB RAM. (would think that would cover most streams)<br><br>Googled around, but haven&#39;t found anyone with a similar problem.<br>Anyone got a clue, before I head over to a linux video playback forum? <br>
<br>

------=_Part_15688_16089853.1213738794428--


--===============0171202524==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0171202524==--
