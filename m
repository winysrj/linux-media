Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <bdc091@gmail.com>) id 1MnD3U-00026C-Oh
	for linux-dvb@linuxtv.org; Mon, 14 Sep 2009 17:01:25 +0200
Received: by bwz9 with SMTP id 9so2106557bwz.17
	for <linux-dvb@linuxtv.org>; Mon, 14 Sep 2009 08:00:51 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 14 Sep 2009 17:00:50 +0200
Message-ID: <746d58780909140800jb43ed63y8b70dc35b090c3a@mail.gmail.com>
From: Benedict bdc091 <bdc091@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] how to get a registered adapter name
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1113012303=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1113012303==
Content-Type: multipart/alternative; boundary=001485f7728c806df704738aee37

--001485f7728c806df704738aee37
Content-Type: text/plain; charset=ISO-8859-1

Hi list,

I'd like to enumerate connected DVB devices from my softawre, based on DVB
API V3.
Thank to ioctl FE_GET_INFO, I'm able to get frontends name, but they are not
"clear" enough for users.

After a "quick look" in /var/log/messages I discovered that adapters name
are much expressives:

> ...
> DVB: registering new adapter (ASUS My Cinema U3000 Mini DVBT Tuner)
> DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
> ...

So, I tried to figure out a way to get "ASUS My Cinema U3000 Mini DVBT
Tuner" string from adapter, instead of "DiBcom 7000PC" from adapter's
frontend...
Unsuccefully so far.

Any suggestions?


Regards
--
Benedict

--001485f7728c806df704738aee37
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi list, <br><br>I&#39;d like to enumerate connected DVB devices from my so=
ftawre, based on DVB API V3.<br>Thank to ioctl FE_GET_INFO, I&#39;m able to=
 get frontends name, but they are not &quot;clear&quot; enough for users.<b=
r>
<br>After a &quot;quick look&quot; in /var/log/messages I discovered that a=
dapters name are much expressives:<br><br>&gt; ...<br>&gt; DVB: registering=
 new adapter (ASUS My Cinema U3000 Mini DVBT Tuner)<br>&gt; DVB: registerin=
g adapter 0 frontend 0 (DiBcom 7000PC)...<br>
&gt; ...<br><br>So, I tried to figure out a way to get &quot;ASUS My Cinema=
 U3000 Mini DVBT Tuner&quot; string from adapter, instead of &quot;DiBcom 7=
000PC&quot; from adapter&#39;s frontend...<br>Unsuccefully so far.<br><br>
Any suggestions?<br><br><br>Regards<br>--<br>Benedict<br><br>

--001485f7728c806df704738aee37--


--===============1113012303==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1113012303==--
