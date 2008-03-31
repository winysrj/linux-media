Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.178])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anluoma@gmail.com>) id 1JgPpw-0002nd-LL
	for linux-dvb@linuxtv.org; Mon, 31 Mar 2008 21:38:36 +0200
Received: by el-out-1112.google.com with SMTP id o28so534806ele.2
	for <linux-dvb@linuxtv.org>; Mon, 31 Mar 2008 12:38:25 -0700 (PDT)
Message-ID: <754a11be0803311238p3fbd4a01p2b336609476261e6@mail.gmail.com>
Date: Mon, 31 Mar 2008 22:38:25 +0300
From: "Antti Luoma" <anluoma@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <e40e29dd0803310336k5de72824l6dd20ba5420531f@mail.gmail.com>
MIME-Version: 1.0
References: <47F0B629.3030903@fastmail.co.uk>
	<e40e29dd0803310336k5de72824l6dd20ba5420531f@mail.gmail.com>
Subject: Re: [linux-dvb] Nova-T 500 disconnects - solved?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1870725007=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1870725007==
Content-Type: multipart/alternative;
	boundary="----=_Part_26207_32217716.1206992305034"

------=_Part_26207_32217716.1206992305034
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

This patch has been probably also added to kernel  2.6.25-rc7 #1 SMP Sat Mar
29 01:19:10 EET 2008 x86_64 GNU/Linux because I compiled that and get
working USB DVB-T after trying so hard 2.6.24 that came with hardy...

But I can also confirm that this disconnect issue comes from kernel 2.6.24..

-antti


2008/3/31, Eamonn Sullivan <eamonn.sullivan@gmail.com>:
>
> 2008/3/31 timufea <timufea@fastmail.co.uk>:
>
> >
> >  It's probably unwise to celebrate just yet, but...
> >
> >  I was running a vanilla 2.6.24.2 kernel, and was getting 2 or 3 USB
> > disconnects each day. 5 days ago I upgraded to 2.6.24.4, and haven't had
> a
> > USB disconnect since!
> >
> >  There is a fix in 2.6.24.4 for a USB bug that was introduced in Oct
> 2007 -
> > see:
> >
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=commit;h=5475187c2752adcc6d789592b5f68c81c39e5a81
> >
> >  Hopefully this was the cause of the USB disconnects.
> >
> >  Some details of my setup, in case it's relevant:
> >    Nova-T 500
> >    v4l-dvb rev 127f67dea087 (Feb 26)
> >    Vanilla 2.6.24.4 kernel
> >    Slackware 11
> >    IR remote control in use
> >    Continual EIT scanning
> >    Poor reception (MythTV reports 51-53%)
> >
> >  Frank
>
>
> If true, this is excellent news (I have almost the exact same set up,
> except that I've given up on the remote and the active EIT scanning to
> reduce the disconnects). I've entered a bug report for this on
> mythbuntu/ubuntu because the latest version (8.04, in beta) doesn't
> seem to have this patch. The latest Ubuntu also uses the 2.6.24
> kernel.
>
> https://bugs.launchpad.net/ubuntu/+bug/209603
>
> Can other Mythbuntu/Ubuntu users of the Nova-T 500 please comment on
> that bug to help raise its visibility and/or add information?
>
> -Eamonn
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>



-- 
-Antti-

------=_Part_26207_32217716.1206992305034
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,<br><br>This patch has been probably also added to kernel&nbsp; 2.6.25-rc7 #1 SMP Sat Mar 29 01:19:10 EET 2008 x86_64 GNU/Linux because I compiled that and get working USB DVB-T after trying so hard 2.6.24 that came with hardy...<br>
<br>But I can also confirm that this disconnect issue comes from kernel 2.6.24..<br><br>-antti<br><br><br><div><span class="gmail_quote">2008/3/31, Eamonn Sullivan &lt;<a href="mailto:eamonn.sullivan@gmail.com">eamonn.sullivan@gmail.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
2008/3/31 timufea &lt;<a href="mailto:timufea@fastmail.co.uk">timufea@fastmail.co.uk</a>&gt;:<br> <br>&gt;<br> &gt;&nbsp;&nbsp;It&#39;s probably unwise to celebrate just yet, but...<br> &gt;<br> &gt;&nbsp;&nbsp;I was running a vanilla <a href="http://2.6.24.2">2.6.24.2</a> kernel, and was getting 2 or 3 USB<br>
 &gt; disconnects each day. 5 days ago I upgraded to <a href="http://2.6.24.4">2.6.24.4</a>, and haven&#39;t had a<br> &gt; USB disconnect since!<br> &gt;<br> &gt;&nbsp;&nbsp;There is a fix in <a href="http://2.6.24.4">2.6.24.4</a> for a USB bug that was introduced in Oct 2007 -<br>
 &gt; see:<br> &gt; <a href="http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=commit;h=5475187c2752adcc6d789592b5f68c81c39e5a81">http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=commit;h=5475187c2752adcc6d789592b5f68c81c39e5a81</a><br>
 &gt;<br> &gt;&nbsp;&nbsp;Hopefully this was the cause of the USB disconnects.<br> &gt;<br> &gt;&nbsp;&nbsp;Some details of my setup, in case it&#39;s relevant:<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;Nova-T 500<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;v4l-dvb rev 127f67dea087 (Feb 26)<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;Vanilla <a href="http://2.6.24.4">2.6.24.4</a> kernel<br>
 &gt;&nbsp;&nbsp;&nbsp;&nbsp;Slackware 11<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;IR remote control in use<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;Continual EIT scanning<br> &gt;&nbsp;&nbsp;&nbsp;&nbsp;Poor reception (MythTV reports 51-53%)<br> &gt;<br> &gt;&nbsp;&nbsp;Frank<br> <br> <br>If true, this is excellent news (I have almost the exact same set up,<br>
 except that I&#39;ve given up on the remote and the active EIT scanning to<br> reduce the disconnects). I&#39;ve entered a bug report for this on<br> mythbuntu/ubuntu because the latest version (8.04, in beta) doesn&#39;t<br>
 seem to have this patch. The latest Ubuntu also uses the 2.6.24<br> kernel.<br> <br> <a href="https://bugs.launchpad.net/ubuntu/+bug/209603">https://bugs.launchpad.net/ubuntu/+bug/209603</a><br> <br> Can other Mythbuntu/Ubuntu users of the Nova-T 500 please comment on<br>
 that bug to help raise its visibility and/or add information?<br> <br> -Eamonn<br> <br> _______________________________________________<br> linux-dvb mailing list<br> <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
 <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br> </blockquote></div><br><br clear="all"><br>-- <br>-Antti-

------=_Part_26207_32217716.1206992305034--


--===============1870725007==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1870725007==--
