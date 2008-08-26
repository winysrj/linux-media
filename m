Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <daveb21@gmail.com>) id 1KXxlt-00012i-2y
	for linux-dvb@linuxtv.org; Tue, 26 Aug 2008 14:35:43 +0200
Received: by yx-out-2324.google.com with SMTP id 8so1026835yxg.41
	for <linux-dvb@linuxtv.org>; Tue, 26 Aug 2008 05:35:36 -0700 (PDT)
Message-ID: <8a1afe660808260535m2e5474earec97b9d76a556354@mail.gmail.com>
Date: Tue, 26 Aug 2008 22:05:35 +0930
From: "Dave Brown" <daveb21@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Avermedia A16D Remote
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0689868073=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0689868073==
Content-Type: multipart/alternative;
	boundary="----=_Part_4026_9681442.1219754135689"

------=_Part_4026_9681442.1219754135689
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hey All,

Just got hold of a Avermedia A16D Hybrid tuner to replace the Dvico I had
that never really worked the way I wanted it to. I've tried to configure the
remote using irrecord but unfortunately there's a couple of glitches in
terms of a couple buttons don't register (with accompanying kernel: saa7134
IR (AVerMedia Hybrid TV: unknown key: key=0x1a raw=0x1a down=1 message) and
a few buttons overlap (ie pressing the Info button actually registers as
pressing the 5 button while the 5 registers as a 5).

I don't reckon I have the skills / time to put a patch together to address
this but if someone points me in the direction of how to capture exactly the
data needed (ie button X = freq Y, button A = freq B) I'm happy to complete
this and forward to the list for potential inclusion into the source. I
think this is a win-win as I get a 100% working remote and I can help out
anyone else who happens to be using the device :)

If anyone is interested in what I'm proposing and can let me know how to
capture the raw data please let me know.

Cheers
Dave Brown

------=_Part_4026_9681442.1219754135689
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hey All,<br><br>Just got hold of a Avermedia A16D Hybrid tuner to replace the Dvico I had that never really worked the way I wanted it to. I&#39;ve tried to configure the remote using irrecord but unfortunately there&#39;s a couple of glitches in terms of a couple buttons don&#39;t register (with accompanying kernel: saa7134 IR (AVerMedia Hybrid TV: unknown key: key=0x1a raw=0x1a down=1 message) and a few buttons overlap (ie pressing the Info button actually registers as pressing the 5 button while the 5 registers as a 5).<br>
<br>I don&#39;t reckon I have the skills / time to put a patch together to address this but if someone points me in the direction of how to capture exactly the data needed (ie button X = freq Y, button A = freq B) I&#39;m happy to complete this and forward to the list for potential inclusion into the source. I think this is a win-win as I get a 100% working remote and I can help out anyone else who happens to be using the device :)<br>
<br>If anyone is interested in what I&#39;m proposing and can let me know how to capture the raw data please let me know.<br><br>Cheers<br>Dave Brown<br></div>

------=_Part_4026_9681442.1219754135689--


--===============0689868073==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0689868073==--
