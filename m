Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <lists.pascal.juergens@googlemail.com>)
	id 1PxJe6-0001dE-QJ
	for linux-dvb@linuxtv.org; Wed, 09 Mar 2011 14:41:47 +0100
Received: from mail-ey0-f182.google.com ([209.85.215.182])
	by mail.tu-berlin.de (exim-4.74/mailfrontend-a) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1PxJe6-0003w2-AZ; Wed, 09 Mar 2011 14:41:46 +0100
Received: by eyg7 with SMTP id 7so163215eyg.41
	for <linux-dvb@linuxtv.org>; Wed, 09 Mar 2011 05:41:45 -0800 (PST)
From: =?iso-8859-1?Q?Pascal_J=FCrgens?= <lists.pascal.juergens@googlemail.com>
Date: Wed, 9 Mar 2011 14:41:42 +0100
Message-Id: <DB7182D0-F83D-459A-8706-40E67D0ABD06@googlemail.com>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v1082)
Subject: [linux-dvb] Simultaneous recordings from one frontend
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1386064050=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>


--===============1386064050==
Content-Type: multipart/alternative; boundary=Apple-Mail-1--751644235


--Apple-Mail-1--751644235
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi all,

SUMMARY: What's the best available tool for demultiplexing into multiple =
simultaneous recordings (files)?

I'm looking for a way to record a TS to overlapping files (ie, files2 =
should start 5 minutes before file1 ends). This means that two readers =
need to access the card at once. As far as I can tell from past =
discussions [1], this is not a feature that's currently present or =
planned in the kernel.

So while searching for a userspace app that is capable of this, I found =
two options[3]:

- Adam Charrett's dvbstreamer [2] seems to run a sort-of ringbuffer and =
can output to streams and files. However, it's not all too stable, =
especially when using the remote control protocol.

- the RTP streaming apps (dvblast, mumudvb, dvbyell etc.) are designed =
to allow multiple listeners. The ideal solution would be something like =
an interface-local ipv6 multicast (mumudvb recommends using a TTL of 0 =
to prevent packets from exiting the machine, but that seems like a =
cludge). Sadly, I haven't gotten that to work [4].

Hence my questions are:
- Am I doing something wrong and is there actually an easy way to stream =
to two files locally?
- Is there some other solution that I'm not aware of that fits my =
scenario perfectly?

Thanks in advance,
regards,
Pascal Juergens

[1] http://www.linuxtv.org/pipermail/linux-dvb/2008-February/024093.html
[2] http://sourceforge.net/projects/dvbstreamer/

[3] There's also the Linux::DVB::DVBT perl extension, but in my tests it =
wasn't happy about recording anything: "timed out waiting for data : =
Inappropriate ioctl for device at /usr/local/bin/dvbt-record line 53"

[4] dvblast, for example, gives "warning: getaddrinfo error: Name or =
service not known
error: Invalid target address for -d switch" when using [ff01::1%eth0] =
as the target address.
Additionally, I wasn't able to consume a regular ipv4 multicast with two =
instances of mplayer - the first one worked, the second one couldn't =
access the url.=

--Apple-Mail-1--751644235
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; ">Hi =
all,<div><br></div><div>SUMMARY: What's the best available tool for =
demultiplexing into multiple simultaneous recordings =
(files)?</div><div><br></div><div>I'm looking for a way to record a TS =
to overlapping files (ie, files2 should start 5 minutes before file1 =
ends). This means that two readers need to access the card at once. As =
far as I can tell from past discussions [1], this is not a feature =
that's currently present or planned in the =
kernel.</div><div><br></div><div>So while searching for a userspace app =
that is capable of this, I found two =
options[3]:</div><div><br></div><div>-&nbsp;Adam&nbsp;Charrett's&nbsp;dvbs=
treamer [2] seems to run a sort-of ringbuffer and can output to streams =
and files. However, it's not all too stable, especially when using the =
remote control protocol.</div><div><br></div><div>- the RTP streaming =
apps (dvblast, mumudvb, dvbyell etc.) are designed to allow multiple =
listeners. The ideal solution would be something like an interface-local =
ipv6 multicast (mumudvb recommends using a TTL of 0 to prevent packets =
from exiting the machine, but that seems like a cludge). Sadly, I =
haven't gotten that to work [4].</div><div><br></div><div>Hence my =
questions are:</div><div>- Am I doing something wrong and is there =
actually an easy way to stream to two files locally?</div><div>- Is =
there some other solution that I'm not aware of that fits my scenario =
perfectly?</div><div><br></div><div>Thanks in =
advance,</div><div>regards,</div><div>Pascal =
Juergens</div><div><br></div><div>[1]&nbsp;<a =
href=3D"http://www.linuxtv.org/pipermail/linux-dvb/2008-February/024093.ht=
ml">http://www.linuxtv.org/pipermail/linux-dvb/2008-February/024093.html</=
a></div><div>[2]&nbsp;<a =
href=3D"http://sourceforge.net/projects/dvbstreamer/">http://sourceforge.n=
et/projects/dvbstreamer/</a></div><div><br></div><div>[3] There's also =
the&nbsp;Linux::DVB::DVBT perl extension, but in my tests it wasn't =
happy about recording anything: "timed out waiting for data : =
Inappropriate ioctl for device at /usr/local/bin/dvbt-record line =
53"</div><div><br></div><div>[4] dvblast, for example, gives "warning: =
getaddrinfo error: Name or service not known</div><div>error: Invalid =
target address for -d switch" when using [ff01::1%eth0] as the target =
address.</div><div>Additionally, I wasn't able to consume a regular ipv4 =
multicast with two instances of mplayer - the first one worked, the =
second one couldn't access the url.</div></body></html>=

--Apple-Mail-1--751644235--


--===============1386064050==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1386064050==--
