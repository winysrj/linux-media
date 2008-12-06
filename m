Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L90wr-0006Ok-3k
	for linux-dvb@linuxtv.org; Sat, 06 Dec 2008 18:28:09 +0100
Received: by qw-out-2122.google.com with SMTP id 9so133336qwb.17
	for <linux-dvb@linuxtv.org>; Sat, 06 Dec 2008 09:28:04 -0800 (PST)
Message-ID: <c74595dc0812060928l467825fbq79a0a62d5882df8d@mail.gmail.com>
Date: Sat, 6 Dec 2008 19:28:04 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <20081206170753.69410@gmx.net>
MIME-Version: 1.0
References: <49346726.7010303@insite.cz> <4934D218.4090202@verbraak.org>
	<4935B72F.1000505@insite.cz>
	<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>
	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>
	<49371511.1060703@insite.cz> <4938C8BB.5040406@verbraak.org>
	<c74595dc0812050100q52ab86bewebe8dbf17bddbb51@mail.gmail.com>
	<20081206170753.69410@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technisat HD2 cannot szap/scan (possible diseqc
	problem)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0004146889=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0004146889==
Content-Type: multipart/alternative;
	boundary="----=_Part_42024_11559942.1228584484860"

------=_Part_42024_11559942.1228584484860
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, Dec 6, 2008 at 7:07 PM, Hans Werner <HWerner4@gmx.de> wrote:

>
> I have a Twinhan 1041 card and I have problems with the s2-liplianin driver
> which I have not fully understood yet.
>
> 1) Scan-s2 works for a while but in a long scan I eventually I start
> getting
> "Slave RACK Fail !" messages in dmesg and scan-s2 hangs. Perhaps increasing
> to
> msleep(15) in mantis_ack_wait helps (it hasn't eliminated the problem), but
> I am not sure.
> There are messages in /var/log/messages from
> stb6100_[set/get]_[frequency/bandwidth]
> which say "Invalid parameter". Only shutting down the computer and
> restarting seems to
> recover from this once it has happened.

I never had that "Slave RACK" problem, but I think I saw some messages that
says it was solved.
Do you use the latest drivers?

------=_Part_42024_11559942.1228584484860
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">On Sat, Dec 6, 2008 at 7:07 PM, Hans Werner <span dir="ltr">&lt;<a href="mailto:HWerner4@gmx.de">HWerner4@gmx.de</a>&gt;</span> wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d"><br>
</div>I have a Twinhan 1041 card and I have problems with the s2-liplianin driver<br>
which I have not fully understood yet.<br>
<br>
1) Scan-s2 works for a while but in a long scan I eventually I start getting<br>
&quot;Slave RACK Fail !&quot; messages in dmesg and scan-s2 hangs. Perhaps increasing to<br>
msleep(15) in mantis_ack_wait helps (it hasn&#39;t eliminated the problem), but I am not sure.<br>
There are messages in /var/log/messages from stb6100_[set/get]_[frequency/bandwidth]<br>
which say &quot;Invalid parameter&quot;. Only shutting down the computer and restarting seems to<br>
recover from this once it has happened.</blockquote><div>I never had that &quot;Slave RACK&quot; problem, but I think I saw some messages that says it was solved.<br>Do you use the latest drivers?<br>&nbsp;<br></div></div><br>
</div>

------=_Part_42024_11559942.1228584484860--


--===============0004146889==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0004146889==--
