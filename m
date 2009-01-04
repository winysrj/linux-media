Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <picholicho@gmail.com>) id 1LJWPM-00072P-7I
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 18:05:00 +0100
Received: by fg-out-1718.google.com with SMTP id e21so2551767fga.25
	for <linux-dvb@linuxtv.org>; Sun, 04 Jan 2009 09:04:56 -0800 (PST)
Message-ID: <7b1b1f8d0901040904x413cda9cwaa344b0102e2ae4e@mail.gmail.com>
Date: Sun, 4 Jan 2009 19:04:56 +0200
From: "Ilia Penev" <picholicho@gmail.com>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>, linux-dvb@linuxtv.org
In-Reply-To: <412bdbff0812281319h73e7379et4a02332d6ca2ec43@mail.gmail.com>
MIME-Version: 1.0
References: <7b1b1f8d0812281220o3a8f1558ga330905c063ff069@mail.gmail.com>
	<412bdbff0812281319h73e7379et4a02332d6ca2ec43@mail.gmail.com>
Subject: Re: [linux-dvb] Gigabyte U8000 remote control how to use it?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0238041044=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0238041044==
Content-Type: multipart/alternative;
	boundary="----=_Part_99623_5763311.1231088696621"

------=_Part_99623_5763311.1231088696621
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

sorry for top posting, last time i forgot to include mail listing address.
and the subject was wrong.

happy new year to all of you.
i updated to the latest code. i had some problems compiling all the modules.
so i did make menuconfig and select some of them, especially those needed by
the usb dvb device.
and with 1.20 firmware after computer powered off - still the same - nothing
happens whem i press key on the remote. nothing visible. with 1.10 keys are
working


2008/12/28 Devin Heitmueller <devin.heitmueller@gmail.com>

> >> Hell Ilia,
> >>
> >> Given the way dib0700 does remote controls, the change you proposed is
> >> the correct way to add new remotes.  If you send a patch to the
> >> mailing list, Patrick Boettcher is the person likely to merge it since
> >> he is the dib0700 maintainer.
> >>
> >> I really should work on getting the dib0700 driver integrated with
> >> ir_keymaps.c so that the it is consistent with other drivers.
> >>
> >> Regarding the 1.20 firmware, are you running the latest v4l-dvb code
> >> from http://linuxtv.org/hg/v4l-dvb?  There were bugs in firmware
> >> version 1.20 IR support that have been fixed in the last couple of
> >> weeks.
> >>
> >> Devin
> >>
> >> --
> >> Devin J. Heitmueller
> >> http://www.devinheitmueller.com
> >> AIM: devinheitmueller
> >
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
>
> Please don't top post - it's a violation of list policy.
>
> Did you also update to the latest code in addition to installing the
> 1.20 firmware?  Also, after installing the 1.20 firmware, did you shut
> down the computer completely - some cards do not get powered down
> properly and thus do not reload the new firmware unless you physically
> power down the PC.
>
> If so, please provide your dmesg ouput.
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>

------=_Part_99623_5763311.1231088696621
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br>sorry for top posting, last time i forgot to include mail listing address. <br>and the subject was wrong. <br><br>happy new year to all of you. <br>i updated to the latest code. i had some problems compiling all the modules. so i did make menuconfig and select some of them, especially those needed by the usb dvb device. <br>
and with 1.20 firmware after computer powered off - still the same - nothing happens whem i press key on the remote. nothing visible. with 1.10 keys are working<br><br><br><div class="gmail_quote">2008/12/28 Devin Heitmueller <span dir="ltr">&lt;<a href="mailto:devin.heitmueller@gmail.com" target="_blank">devin.heitmueller@gmail.com</a>&gt;</span><br>

<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div><div>&gt;&gt; Hell Ilia,<br>
&gt;&gt;<br>
&gt;&gt; Given the way dib0700 does remote controls, the change you proposed is<br>
&gt;&gt; the correct way to add new remotes. &nbsp;If you send a patch to the<br>
&gt;&gt; mailing list, Patrick Boettcher is the person likely to merge it since<br>
&gt;&gt; he is the dib0700 maintainer.<br>
&gt;&gt;<br>
&gt;&gt; I really should work on getting the dib0700 driver integrated with<br>
&gt;&gt; ir_keymaps.c so that the it is consistent with other drivers.<br>
&gt;&gt;<br>
&gt;&gt; Regarding the 1.20 firmware, are you running the latest v4l-dvb code<br>
&gt;&gt; from <a href="http://linuxtv.org/hg/v4l-dvb" target="_blank">http://linuxtv.org/hg/v4l-dvb</a>? &nbsp;There were bugs in firmware<br>
&gt;&gt; version 1.20 IR support that have been fixed in the last couple of<br>
&gt;&gt; weeks.<br>
&gt;&gt;<br>
&gt;&gt; Devin<br>
&gt;&gt;<br>
&gt;&gt; --<br>
&gt;&gt; Devin J. Heitmueller<br>
&gt;&gt; <a href="http://www.devinheitmueller.com" target="_blank">http://www.devinheitmueller.com</a><br>
&gt;&gt; AIM: devinheitmueller<br>
&gt;<br>
&gt;<br>
</div></div>&gt; _______________________________________________<br>
&gt; linux-dvb mailing list<br>
&gt; <a href="mailto:linux-dvb@linuxtv.org" target="_blank">linux-dvb@linuxtv.org</a><br>
&gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
&gt;<br>
<br>
Please don&#39;t top post - it&#39;s a violation of list policy.<br>
<br>
Did you also update to the latest code in addition to installing the<br>
1.20 firmware? &nbsp;Also, after installing the 1.20 firmware, did you shut<br>
down the computer completely - some cards do not get powered down<br>
properly and thus do not reload the new firmware unless you physically<br>
power down the PC.<br>
<br>
If so, please provide your dmesg ouput.<br>
<div><div></div><div><br>
Devin<br>
<br>
--<br>
Devin J. Heitmueller<br>
<a href="http://www.devinheitmueller.com" target="_blank">http://www.devinheitmueller.com</a><br>
AIM: devinheitmueller<br>
</div></div></blockquote></div><br>

------=_Part_99623_5763311.1231088696621--


--===============0238041044==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0238041044==--
