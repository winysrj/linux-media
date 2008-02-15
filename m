Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from hs-out-0708.google.com ([64.233.178.242])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JQADT-0005iy-A0
	for linux-dvb@linuxtv.org; Sat, 16 Feb 2008 00:43:39 +0100
Received: by hs-out-0708.google.com with SMTP id 54so660791hsz.1
	for <linux-dvb@linuxtv.org>; Fri, 15 Feb 2008 15:43:35 -0800 (PST)
Message-ID: <ea4209750802151543y16c7eefawf634cf194d6e3aa1@mail.gmail.com>
Date: Sat, 16 Feb 2008 00:43:34 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <Pine.LNX.4.64.0802152241520.29944@pub5.ifh.de>
MIME-Version: 1.0
References: <200802112223.11129.hfvogt@gmx.net>
	<ea4209750802141220s2402e94bvbd1479037d48cfc8@mail.gmail.com>
	<20080215181815.2583a2e5@gaivota>
	<200802152233.25423.dehnhardt@ahdehnhardt.de>
	<Pine.LNX.4.64.0802152241520.29944@pub5.ifh.de>
Subject: Re: [linux-dvb] [PATCH] support Cinergy HT USB XE (0ccd:0058)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1373333075=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1373333075==
Content-Type: multipart/alternative;
	boundary="----=_Part_3_10515165.1203119014197"

------=_Part_3_10515165.1203119014197
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

So, If it's not a problem, any of you could send me the current xc3028
firmware you are using, because mine does not seem to work... Thanks.

Albert

2008/2/15, Patrick Boettcher <patrick.boettcher@desy.de>:
>
> Aah now I remember that issue, in fact it is no issue. I was seeing that
> problem when send the sleep command or any other firmware command without
> having a firmware running. In was, so far, no problem.
>
> Patrick.
>
>
>
> On Fri, 15 Feb 2008, Holger Dehnhardt wrote:
>
> > Hi Albert, Hi Mauro,
> >
> > I have successfulli patched and compiled the driver. Im using the
> terratec
> > cinergy device and it works fine.
> >
> >>> [ 2251.856000] xc2028 4-0061: Error on line 1063: -5
> >
> > This error message looked very familar to me, so i searched my log and
> guess
> > what I found:
> >
> > Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called
> > Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called
> > Feb 15 20:42:18 musik kernel: xc2028 3-0061: Error on line 1064: -5
> > Feb 15 20:42:18 musik kernel: DiB7000P: setting output mode for demod
> df75e800
> > to 0
> > Feb 15 20:42:18 musik kernel: DiB7000P: setting output mode for demod
> df75e800
> > to 0
> >
> > It identifies the marked line (just to be sure because of the differen
> line
> > numbers)
> >
> >       if (priv->firm_version < 0x0202)
> > ->            rc = send_seq(priv, {0x00, 0x08, 0x00, 0x00});
> >       else
> >               rc = send_seq(priv, {0x80, 0x08, 0x00, 0x00});
> >
> >> The above error is really weird. It seems to be related to something
> that
> >> happened before xc2028, since firmware load didn't start on that point
> of
> >> the code.
> >
> > The error really is weird, but it does not seem to cause the troubles -
> my
> > card works despite the error!
> >
> >>
> >>> [ 2289.284000] xc2028 4-0061: Device is Xceive 3028 version 1.0,
> firmware
> >>> version 2.7
> >>
> >> This message means that xc3028 firmware were successfully loaded and it
> is
> >> running ok.
> >
> > This and the following messages look similar...
> >
> > Holger
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_3_10515165.1203119014197
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

So, If it&#39;s not a problem, any of you could send me the current xc3028 firmware you are using, because mine does not seem to work... Thanks.<br><br>Albert<br><br><div><span class="gmail_quote">2008/2/15, Patrick Boettcher &lt;<a href="mailto:patrick.boettcher@desy.de">patrick.boettcher@desy.de</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Aah now I remember that issue, in fact it is no issue. I was seeing that<br>problem when send the sleep command or any other firmware command without<br>having a firmware running. In was, so far, no problem.<br><br>Patrick.<br>
<br><br><br>On Fri, 15 Feb 2008, Holger Dehnhardt wrote:<br><br>&gt; Hi Albert, Hi Mauro,<br>&gt;<br>&gt; I have successfulli patched and compiled the driver. Im using the terratec<br>&gt; cinergy device and it works fine.<br>
&gt;<br>&gt;&gt;&gt; [ 2251.856000] xc2028 4-0061: Error on line 1063: -5<br>&gt;<br>&gt; This error message looked very familar to me, so i searched my log and guess<br>&gt; what I found:<br>&gt;<br>&gt; Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called<br>
&gt; Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called<br>&gt; Feb 15 20:42:18 musik kernel: xc2028 3-0061: Error on line 1064: -5<br>&gt; Feb 15 20:42:18 musik kernel: DiB7000P: setting output mode for demod df75e800<br>
&gt; to 0<br>&gt; Feb 15 20:42:18 musik kernel: DiB7000P: setting output mode for demod df75e800<br>&gt; to 0<br>&gt;<br>&gt; It identifies the marked line (just to be sure because of the differen line<br>&gt; numbers)<br>
&gt;<br>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (priv-&gt;firm_version &lt; 0x0202)<br>&gt; -&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;rc = send_seq(priv, {0x00, 0x08, 0x00, 0x00});<br>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else<br>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rc = send_seq(priv, {0x80, 0x08, 0x00, 0x00});<br>
&gt;<br>&gt;&gt; The above error is really weird. It seems to be related to something that<br>&gt;&gt; happened before xc2028, since firmware load didn&#39;t start on that point of<br>&gt;&gt; the code.<br>&gt;<br>&gt; The error really is weird, but it does not seem to cause the troubles - my<br>
&gt; card works despite the error!<br>&gt;<br>&gt;&gt;<br>&gt;&gt;&gt; [ 2289.284000] xc2028 4-0061: Device is Xceive 3028 version 1.0, firmware<br>&gt;&gt;&gt; version 2.7<br>&gt;&gt;<br>&gt;&gt; This message means that xc3028 firmware were successfully loaded and it is<br>
&gt;&gt; running ok.<br>&gt;<br>&gt; This and the following messages look similar...<br>&gt;<br>&gt; Holger<br>&gt;<br>&gt; _______________________________________________<br>&gt; linux-dvb mailing list<br>&gt; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>&gt;<br><br>_______________________________________________<br>linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br><a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></blockquote></div><br>

------=_Part_3_10515165.1203119014197--


--===============1373333075==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1373333075==--
