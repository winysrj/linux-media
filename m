Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.224])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JjscC-0000qe-3r
	for linux-dvb@linuxtv.org; Thu, 10 Apr 2008 10:58:41 +0200
Received: by wx-out-0506.google.com with SMTP id s11so3182486wxc.17
	for <linux-dvb@linuxtv.org>; Thu, 10 Apr 2008 01:58:32 -0700 (PDT)
Message-ID: <617be8890804100014r25eb459q75a09e66e1ddc3b@mail.gmail.com>
Date: Thu, 10 Apr 2008 09:14:18 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] [PATCH] Add driver specific module option to choose
	dvb adapter numbers, second
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1723142968=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1723142968==
Content-Type: multipart/alternative;
	boundary="----=_Part_25151_30190201.1207811658885"

------=_Part_25151_30190201.1207811658885
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>
> ---------- Missatge reenviat ----------
> From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
> To: Michael Krufky <mkrufky@linuxtv.org>
> Date: Wed, 9 Apr 2008 18:14:42 +0200 (CEST)
> Subject: Re: [linux-dvb] [PATCH] Add driver specific module option to
> choose dvb adapter numbers, second try
>
>
> On Wed, 9 Apr 2008, Michael Krufky wrote:
>
>  On Wed, Apr 9, 2008 at 11:07 AM, Manu Abraham <abraham.manu@gmail.com>
> > wrote:
> >
> > > Janne Grunau wrote:
> > > > Hi,
> > > >
> > > > I resubmit this patch since I still think it is a good idea to the
> > > this
> > > > driver option. There is still no udev recipe to guaranty stable dvb
> > > > adapter numbers. I've tried to come up with some rules but it's
> > > tricky
> > > > due to the multiple device nodes in a subdirectory. I won't claim
> > > that
> > > > it is impossible to get udev to assign driver or hardware specific
> > > > stable dvb adapter numbers but I think this patch is easier and more
> > > > clean than a udev based solution.
> > > >
> > > > I'll drop this patch if a simple udev solution is found in a
> > > reasonable
> > > > amount of time. But if there is no I would like to see the attached
> > > > patch merged.
> > >
> > >  As i wrote sometime back, adding adapter numbers to adapters is bad.
> > >
> > >  In fact, when the kernel advocates udev, working around it is no
> > >  solution, but finding the problem and fixing the basic problem is
> > > more
> > >  important, rather than workarounds.
> > >
> > >  http://www.gentoo.org/doc/en/udev-guide.xml
> > >  http://reactivated.net/writing_udev_rules.html
> > >
> > >  If there is a general udev issue, it should be taken up with udev and
> > >  not working around within adapter drivers.
> > >
> >
> > Regardless of how broken the issue is within udev, udev is not
> > user-friendly.
> >
> > Under the current situation, users that have media recording servers
> > that receive broadcasts from differing delivery systems have no way
> > ensure that they are using the correct device for their recordings.
> >
> > For instance:
> >
> > Users might have VSB devices and QAM devices in their system, both to
> > receive OTA broadcasts and digital cable.  Likewise, someone else
> > might have DVB-S devices and DVB-T devices in the same system.
> >
> > If said user has VSB devices as adapters 0 and 1, QAM-capable devices
> > as adapters 2 and 3, and DVB-S devices as adapters 5 and 6, they need
> > to be able to configure their software to know which device to use
> > when attempting to receive broadcasts from the respective media type.
> >
> > The argument that "udev should do this -- fix udev instead" is weak,
> > in my opinion.  Even if udev can be fixed, the understanding of how to
> > configure it is hopeless.
> >
> > When support for cx88-alsa and saa7134-alsa appeared, at first, I lost
> > functionality of my sound card.  I fixed the issue by setting my alsa
> > driver "index" module option for each respecting device in my build
> > scripts.  If I didn't have the ability to rectify that issue, I simply
> > would have yanked out the conflicting device (ie: use NO video card in
> > the system) or just reboot into Windows and ditch Linux, altogether.
> >
> > This is a simple patch that adds the same functionality that v4l and
> > alsa have -- the ability to declare the adapter number of the device
> > at attach-time, based on a module option.  The change has minimal
> > impact on the source code, and adds great benefits to the users, and
> > requires zero maintenance.
> >
> > The arguments against applying this change are "fix udev instead" and
> > "we'll have to remove this in kernel 2.7" ... Well, rather than to
> > have everybody wait around for a "fix" that requires programming
> > skills in order to use, I say we merge this now, so that people can
> > use their systems properly TODAY.  If we have to remove this in the
> > future as a result of some other kernel-wide requirements, then we
> > will cross that bridge when we come to it.
> >
> > I see absolutely no harm in implementing this feature now.
> >
> > -Mike
> >
> >
> +1
>
> For MythTv setups this is very much needed... for the reasons Mike very
> clearly stated.
>

Agreed. MythTV has the problem that it relies exclusively on adaptor numbers
for DVB configuration and it's unable to work with "named" symlinks, which
is what udev mainly gives us. So for people using more than one adaptor it
would be really useful to use this patch, as it would be the only way to
ensure MythTV finds the same numering schema everytime it boots.

I think that the patch would do no harm at all and would bring some benefits
at least. I agree that it would be better to fix "udev", by I also think
that this question is beyond the scope of LinuxTV and we can't wait for udev
developers to change its behaiviour to solve this.

Regards
  Eduard

------=_Part_25151_30190201.1207811658885
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">---------- Missatge reenviat ----------<br>From:&nbsp;Rudy Zijlstra &lt;<a href="mailto:rudy@grumpydevil.homelinux.org">rudy@grumpydevil.homelinux.org</a>&gt;<br>
To:&nbsp;Michael Krufky &lt;<a href="mailto:mkrufky@linuxtv.org">mkrufky@linuxtv.org</a>&gt;<br>Date:&nbsp;Wed, 9 Apr 2008 18:14:42 +0200 (CEST)<br>Subject:&nbsp;Re: [linux-dvb] [PATCH] Add driver specific module option to choose dvb adapter numbers, second try<br>
<br>
<br>
On Wed, 9 Apr 2008, Michael Krufky wrote:<br>
<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">
On Wed, Apr 9, 2008 at 11:07 AM, Manu Abraham &lt;<a href="mailto:abraham.manu@gmail.com" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">abraham.manu@gmail.com</a>&gt; wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">
Janne Grunau wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; I resubmit this patch since I still think it is a good idea to the this<br>
&gt; driver option. There is still no udev recipe to guaranty stable dvb<br>
&gt; adapter numbers. I&#39;ve tried to come up with some rules but it&#39;s tricky<br>
&gt; due to the multiple device nodes in a subdirectory. I won&#39;t claim that<br>
&gt; it is impossible to get udev to assign driver or hardware specific<br>
&gt; stable dvb adapter numbers but I think this patch is easier and more<br>
&gt; clean than a udev based solution.<br>
&gt;<br>
&gt; I&#39;ll drop this patch if a simple udev solution is found in a reasonable<br>
&gt; amount of time. But if there is no I would like to see the attached<br>
&gt; patch merged.<br>
<br>
&nbsp;As i wrote sometime back, adding adapter numbers to adapters is bad.<br>
<br>
&nbsp;In fact, when the kernel advocates udev, working around it is no<br>
&nbsp;solution, but finding the problem and fixing the basic problem is more<br>
&nbsp;important, rather than workarounds.<br>
<br>
&nbsp;<a href="http://www.gentoo.org/doc/en/udev-guide.xml" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">http://www.gentoo.org/doc/en/udev-guide.xml</a><br>
&nbsp;<a href="http://reactivated.net/writing_udev_rules.html" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">http://reactivated.net/writing_udev_rules.html</a><br>
<br>
&nbsp;If there is a general udev issue, it should be taken up with udev and<br>
&nbsp;not working around within adapter drivers.<br>
</blockquote>
<br>
Regardless of how broken the issue is within udev, udev is not user-friendly.<br>
<br>
Under the current situation, users that have media recording servers<br>
that receive broadcasts from differing delivery systems have no way<br>
ensure that they are using the correct device for their recordings.<br>
<br>
For instance:<br>
<br>
Users might have VSB devices and QAM devices in their system, both to<br>
receive OTA broadcasts and digital cable. &nbsp;Likewise, someone else<br>
might have DVB-S devices and DVB-T devices in the same system.<br>
<br>
If said user has VSB devices as adapters 0 and 1, QAM-capable devices<br>
as adapters 2 and 3, and DVB-S devices as adapters 5 and 6, they need<br>
to be able to configure their software to know which device to use<br>
when attempting to receive broadcasts from the respective media type.<br>
<br>
The argument that &quot;udev should do this -- fix udev instead&quot; is weak,<br>
in my opinion. &nbsp;Even if udev can be fixed, the understanding of how to<br>
configure it is hopeless.<br>
<br>
When support for cx88-alsa and saa7134-alsa appeared, at first, I lost<br>
functionality of my sound card. &nbsp;I fixed the issue by setting my alsa<br>
driver &quot;index&quot; module option for each respecting device in my build<br>
scripts. &nbsp;If I didn&#39;t have the ability to rectify that issue, I simply<br>
would have yanked out the conflicting device (ie: use NO video card in<br>
the system) or just reboot into Windows and ditch Linux, altogether.<br>
<br>
This is a simple patch that adds the same functionality that v4l and<br>
alsa have -- the ability to declare the adapter number of the device<br>
at attach-time, based on a module option. &nbsp;The change has minimal<br>
impact on the source code, and adds great benefits to the users, and<br>
requires zero maintenance.<br>
<br>
The arguments against applying this change are &quot;fix udev instead&quot; and<br>
&quot;we&#39;ll have to remove this in kernel 2.7&quot; ... Well, rather than to<br>
have everybody wait around for a &quot;fix&quot; that requires programming<br>
skills in order to use, I say we merge this now, so that people can<br>
use their systems properly TODAY. &nbsp;If we have to remove this in the<br>
future as a result of some other kernel-wide requirements, then we<br>
will cross that bridge when we come to it.<br>
<br>
I see absolutely no harm in implementing this feature now.<br>
<br>
-Mike<br>
<br>
</blockquote>
<br>
+1<br>
<br>
For MythTv setups this is very much needed... for the reasons Mike very clearly stated.<br>
</blockquote></div><br>Agreed. MythTV has the problem that it relies exclusively on adaptor numbers for DVB configuration and it&#39;s unable to work with &quot;named&quot; symlinks, which is what udev mainly gives us. So for people using more than one adaptor it would be really useful to use this patch, as it would be the only way to ensure MythTV finds the same numering schema everytime it boots.<br>
<br>I think that the patch would do no harm at all and would bring some benefits at least. I agree that it would be better to fix &quot;udev&quot;, by I also think that this question is beyond the scope of LinuxTV and we can&#39;t wait for udev developers to change its behaiviour to solve this.<br>
<br>Regards<br>&nbsp; Eduard<br><br><br><br><br><br><br><br>

------=_Part_25151_30190201.1207811658885--


--===============1723142968==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1723142968==--
