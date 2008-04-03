Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JhMED-0000Xq-C8
	for linux-dvb@linuxtv.org; Thu, 03 Apr 2008 11:59:30 +0200
Received: by rv-out-0910.google.com with SMTP id b22so2028197rvf.41
	for <linux-dvb@linuxtv.org>; Thu, 03 Apr 2008 02:59:20 -0700 (PDT)
Message-ID: <617be8890804030259vd442e84qdb8a489ef22cd7a@mail.gmail.com>
Date: Thu, 3 Apr 2008 11:59:19 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] Nova-T 500 disconnects - solved? - YES!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1033682408=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1033682408==
Content-Type: multipart/alternative;
	boundary="----=_Part_1014_21955916.1207216760012"

------=_Part_1014_21955916.1207216760012
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>
> ---------- Missatge reenviat ----------
> From: Nicolas Will <nico@youplala.net>
> To: linux-dvb@linuxtv.org
> Date: Thu, 3 Apr 2008 10:47:25 +0200
> Subject: Re: [linux-dvb] Nova-T 500 disconnects - solved? - YES!
>
> Guys,
>
> I have tried the ehci patch manually on the Ubuntu 2.6.24-13 source, and
> indeed it fixed the disconnects.
>
> The fix is now in the 2.6.24-14 binaries, and works just as well.
>
> My Ubuntu Hardy has now resumed normal activities and Gutsy stability
> levels, so far.
>
> I can only recommend that users of other distros should check for kernel
> updates, bug their developers to include the fix, or do it themselves.
>
> Nico
>


Those are very good news! I had "frozen" my upgrade to 2.6.24 after I
started to see those messages indicating a "back to disconnect hell".

Now that the issue seems to be definitely isolated and solved I'll upgrade
the kernel as soon as Gentoo 2.6.24 kernel includes this fix.

Best regards,
  Eduard

------=_Part_1014_21955916.1207216760012
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">---------- Missatge reenviat ----------<br>From:&nbsp;Nicolas Will &lt;<a href="mailto:nico@youplala.net">nico@youplala.net</a>&gt;<br>
To:&nbsp;<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>Date:&nbsp;Thu, 3 Apr 2008 10:47:25 +0200<br>Subject:&nbsp;Re: [linux-dvb] Nova-T 500 disconnects - solved? - YES!<br><br>
Guys,<br>
<br>
I have tried the ehci patch manually on the Ubuntu 2.6.24-13 source, and<br>
indeed it fixed the disconnects.<br>
<br>
The fix is now in the 2.6.24-14 binaries, and works just as well.<br>
<br>
My Ubuntu Hardy has now resumed normal activities and Gutsy stability<br>
levels, so far.<br>
<br>
I can only recommend that users of other distros should check for kernel<br>
updates, bug their developers to include the fix, or do it themselves.<br>
<br>
Nico<br>
</blockquote></div><br><br>Those are very good news! I had &quot;frozen&quot; my upgrade to 2.6.24 after I started to see those messages indicating a &quot;back to disconnect hell&quot;.<br><br>Now that the issue seems to be definitely isolated and solved I&#39;ll upgrade the kernel as soon as Gentoo 2.6.24 kernel includes this fix.<br>
<br>Best regards,<br>&nbsp; Eduard<br><br><br><br><br><br>

------=_Part_1014_21955916.1207216760012--


--===============1033682408==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1033682408==--
