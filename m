Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.235])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JjB2h-0003rW-TV
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 12:27:08 +0200
Received: by wx-out-0506.google.com with SMTP id s11so2025383wxc.17
	for <linux-dvb@linuxtv.org>; Tue, 08 Apr 2008 03:27:02 -0700 (PDT)
Message-ID: <617be8890804080327x1600de52xfc2549c98a35c4aa@mail.gmail.com>
Date: Tue, 8 Apr 2008 12:27:02 +0200
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
Content-Type: multipart/mixed; boundary="===============0515539626=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0515539626==
Content-Type: multipart/alternative;
	boundary="----=_Part_16233_15509704.1207650422213"

------=_Part_16233_15509704.1207650422213
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>
> ---------- Missatge reenviat ----------
> From: Janne Grunau <janne-dvb@grunau.be>
> To: linux-dvb@linuxtv.org
> Date: Tue, 8 Apr 2008 10:30:04 +0200
> Subject: Re: [linux-dvb] [PATCH] Add driver specific module option to
> choose dvb adapter numbers, second try
> On Sunday 30 March 2008 20:17:49 Janne Grunau wrote:
> > On Sunday 30 March 2008 13:53:33 Janne Grunau wrote:
> > > I agree. Fixed, updated patch attached.
> >
> > Next try:
> >
> > replaced module option definition in each driver by a macro,
> > fixed all checkpatch.pl error and warning
> > added Signed-off-by line and patch description
>
> ping.
>
> Any interest in this change? Anything speaking against merging this
> except the potential duplication of udev functinality?
>
> Janne
>

I think it's a good idea.  I don't think there's an easy way to create a
fixed numbering schema for DVB adaptors by just using udev rules. Udev
allows you to easily create named symlinks pointing to the devices, but this
is just not useful for MythTV, as this only uses a number to identify the
DVB adaptors to use.

(Well, there's probably a way: tell udev to create fixed  numerical type
symlinks like 'dvb10', etc... pointing to the right devices, and use for
those a numbering schema higher than your adaptor count. Probably MythTV
will allow you to use these, but I think this hack is just ugly).

Currently I just disabled udev for my adaptors by blacklisting the modules,
and manually loading them after udev in the appropiate order. This is the
only way I've found to get a consistent numberging schema.

So, in a nutshell: yes, I think your patch would be really useful for people
having more than one adaptor.

Regards,
  Eduard Huguet

------=_Part_16233_15509704.1207650422213
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">---------- Missatge reenviat ----------<br>From:&nbsp;Janne Grunau &lt;<a href="mailto:janne-dvb@grunau.be">janne-dvb@grunau.be</a>&gt;<br>
To:&nbsp;<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>Date:&nbsp;Tue, 8 Apr 2008 10:30:04 +0200<br>Subject:&nbsp;Re: [linux-dvb] [PATCH] Add driver specific module option to choose dvb adapter numbers, second try<br>
On Sunday 30 March 2008 20:17:49 Janne Grunau wrote:<br>
&gt; On Sunday 30 March 2008 13:53:33 Janne Grunau wrote:<br>
&gt; &gt; I agree. Fixed, updated patch attached.<br>
&gt;<br>
&gt; Next try:<br>
&gt;<br>
&gt; replaced module option definition in each driver by a macro,<br>
&gt; fixed all checkpatch.pl error and warning<br>
&gt; added Signed-off-by line and patch description<br>
<br>
ping.<br>
<br>
Any interest in this change? Anything speaking against merging this<br>
except the potential duplication of udev functinality?<br>
<br>
Janne<br>
</blockquote></div><br>I think it&#39;s a good idea.&nbsp; I don&#39;t think there&#39;s an easy way to create a fixed numbering schema for DVB adaptors by just using udev rules. Udev allows you to easily create named symlinks pointing to the devices, but this is just not useful for MythTV, as this only uses a number to identify the DVB adaptors to use.<br>
<br>(Well, there&#39;s probably a way: tell udev to create fixed&nbsp; numerical type symlinks like &#39;dvb10&#39;, etc... pointing to the right devices, and use for those a numbering schema higher than your adaptor count. Probably MythTV will allow you to use these, but I think this hack is just ugly).<br>
<br>Currently I just disabled udev for my adaptors by blacklisting the modules, and manually loading them after udev in the appropiate order. This is the only way I&#39;ve found to get a consistent numberging schema.<br><br>
So, in a nutshell: yes, I think your patch would be really useful for people having more than one adaptor.<br><br>Regards, <br>&nbsp; Eduard Huguet<br><br><br><br>

------=_Part_16233_15509704.1207650422213--


--===============0515539626==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0515539626==--
