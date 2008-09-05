Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.234])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rlskoeser@gmail.com>) id 1KbhSE-0007GX-4f
	for linux-dvb@linuxtv.org; Fri, 05 Sep 2008 21:58:50 +0200
Received: by rv-out-0506.google.com with SMTP id b25so566977rvf.41
	for <linux-dvb@linuxtv.org>; Fri, 05 Sep 2008 12:58:45 -0700 (PDT)
Message-ID: <4f5573e90809051258w2b7ba178w1c1ae6b93d26c569@mail.gmail.com>
Date: Fri, 5 Sep 2008 15:58:45 -0400
From: "Rebecca Sutton Koeser" <rlskoeser@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <mailman.596.1220644386.834.linux-dvb@linuxtv.org>
MIME-Version: 1.0
References: <mailman.596.1220644386.834.linux-dvb@linuxtv.org>
Subject: [linux-dvb] ATI HDTV Wonder - unknown device ac00
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2006547069=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2006547069==
Content-Type: multipart/alternative;
	boundary="----=_Part_38967_12040710.1220644725672"

------=_Part_38967_12040710.1220644725672
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I hope this the right place to ask this question.

I bought an ATI HDTV Wonder because I thought I read that it worked in
Linux.  But when I followed the instructions to load the firmware and get it
working, nothing happens.  I see the notes on the wiki page (
http://www.linuxtv.org/wiki/index.php/ATI/AMD_HDTV_Wonder ) about alternate
subsystem IDs that are not supported, but I'm not sure how to proceed from
there.

If someone can give me instructions on how to get more information about the
hardware I will be glad to investigate.

Here's the relevant output from lspci -v

04:02.0 Multimedia controller: ATI Technologies Inc Unknown device ac00
    Subsystem: ATI Technologies Inc Unknown device b359
    Flags: bus master, medium devsel, latency 32, IRQ 11
    Memory at fdb00000 (32-bit, non-prefetchable) [size=1M]
    Memory at fdae0000 (32-bit, prefetchable) [size=128K]
    Capabilities: [50] Power Management version 2


Can anyone tell me, is it likely / possible that this card will work in
linux any time soon, or should I be looking into returning it and finding
something more likely to work?

Thanks in advance for any help or advice.

Rebecca

------=_Part_38967_12040710.1220644725672
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><div class="gmail_quote"><div dir="ltr">I hope this the right place to ask this question.<br><br>I bought an ATI HDTV Wonder because I thought I read that it worked in Linux.&nbsp; But when I followed the instructions to load the firmware and get it working, nothing happens.&nbsp; I see the notes on the wiki page ( <a href="http://www.linuxtv.org/wiki/index.php/ATI/AMD_HDTV_Wonder" target="_blank">http://www.linuxtv.org/wiki/index.php/ATI/AMD_HDTV_Wonder</a> ) about alternate subsystem IDs that are not supported, but I&#39;m not sure how to proceed from there.<br clear="all">

<br>If someone can give me instructions on how to get more information about the hardware I will be glad to investigate.<br>
<br>Here&#39;s the relevant output from lspci -v<br><br>04:02.0 Multimedia controller: ATI Technologies Inc Unknown device ac00<br>&nbsp;&nbsp;&nbsp; Subsystem: ATI Technologies Inc Unknown device b359<br>
&nbsp;&nbsp;&nbsp; Flags: bus master, medium devsel, latency 32, IRQ 11<br>&nbsp;&nbsp;&nbsp; Memory at fdb00000 (32-bit, non-prefetchable) [size=1M]<br>&nbsp;&nbsp;&nbsp; Memory at fdae0000 (32-bit, prefetchable) [size=128K]<br>&nbsp;&nbsp;&nbsp; Capabilities: [50] Power Management version 2<br>

<br><br>Can anyone tell me, is it likely / possible that this card will work in linux any time soon, or should I be looking into returning it and finding something more likely to work?<br><br>Thanks in advance for any help or advice.<br>
<br></div></div>Rebecca<br>
</div>

------=_Part_38967_12040710.1220644725672--


--===============2006547069==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2006547069==--
