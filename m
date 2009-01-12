Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1LMUa4-0000To-D2
	for linux-dvb@linuxtv.org; Mon, 12 Jan 2009 22:44:20 +0100
Received: by bwz11 with SMTP id 11so3805196bwz.17
	for <linux-dvb@linuxtv.org>; Mon, 12 Jan 2009 13:43:46 -0800 (PST)
Message-ID: <9ac6f40e0901121341h4e447bbxbf26c7ff7153dcc0@mail.gmail.com>
Date: Mon, 12 Jan 2009 22:41:24 +0100
From: e9hack@googlemail.com
To: linux-dvb@linuxtv.org
In-Reply-To: <496BA8BE.4080309@googlemail.com>
MIME-Version: 1.0
References: <496BA8BE.4080309@googlemail.com>
Subject: Re: [linux-dvb] compile problems on 2.6.29-rc1
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0979506724=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0979506724==
Content-Type: multipart/alternative;
	boundary="----=_Part_172065_28756838.1231796484460"

------=_Part_172065_28756838.1231796484460
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2009/1/12 e9hack <e9hack@googlemail.com>

> Hi,
>
> I've problems to compile the current hg tree with some modifications on
> linux 2.6.29-rc1.


It seems, any included file like #include <media/....> uses the file from
kernel source tree instead of the v4l-dvb tree.

Regards,
Hartmut

------=_Part_172065_28756838.1231796484460
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">2009/1/12 e9hack <span dir="ltr">&lt;<a href="mailto:e9hack@googlemail.com">e9hack@googlemail.com</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi,<br>
<br>
I&#39;ve problems to compile the current hg tree with some modifications on linux 2.6.29-rc1.</blockquote><div>&nbsp;&nbsp;
<br></div></div>It seems, any included file like #include &lt;media/....&gt; uses the file from kernel source tree instead of the v4l-dvb tree.<br><br>Regards,<br>Hartmut<br><br>

------=_Part_172065_28756838.1231796484460--


--===============0979506724==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0979506724==--
