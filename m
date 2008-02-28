Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JUlbx-0004BL-3U
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 17:27:57 +0100
Received: by rv-out-0910.google.com with SMTP id b22so2734577rvf.41
	for <linux-dvb@linuxtv.org>; Thu, 28 Feb 2008 08:27:43 -0800 (PST)
Message-ID: <617be8890802280827k57080ad4ic969bb2821398428@mail.gmail.com>
Date: Thu, 28 Feb 2008 17:27:42 +0100
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "Matthias Schwarzott" <zzam@gentoo.org>
In-Reply-To: <200802281706.08815.zzam@gentoo.org>
MIME-Version: 1.0
References: <617be8890802270124q55872b13n5819914996312c53@mail.gmail.com>
	<200802281706.08815.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Any improvements on the Avermedia DVB-S Pro (A700)?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1484131381=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1484131381==
Content-Type: multipart/alternative;
	boundary="----=_Part_18809_21652840.1204216062961"

------=_Part_18809_21652840.1204216062961
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

OK, thanks. The GPIO status values corresponded to DVB-S use, I haven't
tested the analog input nor in Windows nor Linux because I don't have
anything to connect to it...

I think there are couple of snapshots points on the report. IIRC the first
one correspond to the initial state (before ever starting the AverTV
program) and the second one is watching DVB-S TV with it.

Best regards,
  Eduard



2008/2/28, Matthias Schwarzott <zzam@gentoo.org>:
>
> On Mittwoch, 27. Februar 2008, Eduard Huguet wrote:
> > Hi, Matthias
> Hi Eduard!
>
>
> >     I've seen that you have new patches for the card on the folder
> > referenced in the wiki. Unfortunately none of them seems to work with my
> > card. I'm startint to think that I'm doing something fundamentally
> wrong...
> > But anyway, neither Kaffeine nor dvbscan seems to be able to lock to the
> > satellite signal coming from the antennae (Windows can, though...).
> >
>
> For now I also dont get a lock :(
> Even if I use the unchanged code that did work some time ago.
>
>
> > So far I've tried all the available patches, both using use_frontend=0
> and
> > use_frontend=1 options in saa7134-dvb module. In neither case the card
> > can't lock...
> >
>
> Same for me for now.
>
>
> > Did you received my message posting the GPIO status and data from
> Windows
> > driver? Apparently is different from what you entered in the wiki, I
> don't
> > know why. Anyway, I tried to use my values saa7134 initialisation with
> no
> > difference...
>
>
> Yeah I got your mail, but can't interprete it. You need to tell what
> setting
> was used while doing the register snapshots. Like selected input
> (svideo/composite/dvb-s).
>
> Matthias
>
>
> --
> Matthias Schwarzott (zzam)
>

------=_Part_18809_21652840.1204216062961
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

OK, thanks. The GPIO status values corresponded to DVB-S use, I haven&#39;t tested the analog input nor in Windows nor Linux because I don&#39;t have anything to connect to it...<br><br>I think there are couple of snapshots points on the report. IIRC the first one correspond to the initial state (before ever starting the AverTV program) and the second one is watching DVB-S TV with it. <br>
<br>Best regards, <br>&nbsp; Eduard<br><br><br><br><div><span class="gmail_quote">2008/2/28, Matthias Schwarzott &lt;<a href="mailto:zzam@gentoo.org">zzam@gentoo.org</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
On Mittwoch, 27. Februar 2008, Eduard Huguet wrote:<br> &gt; Hi, Matthias<br> Hi Eduard!<br> <br><br> &gt;&nbsp;&nbsp;&nbsp;&nbsp; I&#39;ve seen that you have new patches for the card on the folder<br> &gt; referenced in the wiki. Unfortunately none of them seems to work with my<br>
 &gt; card. I&#39;m startint to think that I&#39;m doing something fundamentally wrong...<br> &gt; But anyway, neither Kaffeine nor dvbscan seems to be able to lock to the<br> &gt; satellite signal coming from the antennae (Windows can, though...).<br>
 &gt;<br> <br>For now I also dont get a lock :(<br> Even if I use the unchanged code that did work some time ago.<br> <br><br> &gt; So far I&#39;ve tried all the available patches, both using use_frontend=0 and<br> &gt; use_frontend=1 options in saa7134-dvb module. In neither case the card<br>
 &gt; can&#39;t lock...<br> &gt;<br> <br>Same for me for now.<br> <br><br> &gt; Did you received my message posting the GPIO status and data from Windows<br> &gt; driver? Apparently is different from what you entered in the wiki, I don&#39;t<br>
 &gt; know why. Anyway, I tried to use my values saa7134 initialisation with no<br> &gt; difference...<br> <br> <br>Yeah I got your mail, but can&#39;t interprete it. You need to tell what setting<br> was used while doing the register snapshots. Like selected input<br>
 (svideo/composite/dvb-s).<br> <br> Matthias<br> <br><br> --<br> Matthias Schwarzott (zzam)<br> </blockquote></div><br>

------=_Part_18809_21652840.1204216062961--


--===============1484131381==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1484131381==--
