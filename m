Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f11.google.com ([209.85.217.11])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1L4eWC-0001Jh-4j
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 17:42:37 +0100
Received: by gxk4 with SMTP id 4so1937218gxk.17
	for <linux-dvb@linuxtv.org>; Mon, 24 Nov 2008 08:42:02 -0800 (PST)
Message-ID: <617be8890811240823x51995503jd1de6337e11bd90@mail.gmail.com>
Date: Mon, 24 Nov 2008 17:23:45 +0100
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "Darron Broad" <darron@kewl.org>
In-Reply-To: <20093.1227537387@kewl.org>
MIME-Version: 1.0
References: <617be8890811210115x46b99879l7b78fcf7a1d59357@mail.gmail.com>
	<29500.1227284783@kewl.org>
	<617be8890811240346r3aae6f31rfab45804419bfade@mail.gmail.com>
	<18885.1227529079@kewl.org>
	<617be8890811240423o6b8fc2e4jc94021cb14ec271a@mail.gmail.com>
	<617be8890811240626y6452709bk34b276c21a9ea5c6@mail.gmail.com>
	<20093.1227537387@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fwd: Distorted analog sound when using an HVR-3000
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0467346737=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0467346737==
Content-Type: multipart/alternative;
	boundary="----=_Part_121719_2975681.1227543825911"

------=_Part_121719_2975681.1227543825911
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
    I've tested you driver compared to the offcial LinuxTV HG tree, and I
**think** (can be wrong, though...) that I'm getting "correct" audio when
using a higher input volume. I mean, both drivers delivers crackly sound
when given a high volume input, but yours seems to hold up a higher volume
level before starting to fail.

I hope this means anything to you... :D

Regards,
  Eduard



2008/11/24 Darron Broad <darron@kewl.org>

> In message <617be8890811240626y6452709bk34b276c21a9ea5c6@mail.gmail.com>,
> "Eduard Huguet" wrote:
>
> hiya.
>
> >Ok, problem solved: I needed to define a V4L "recording profile" in
> MythTV,
> >so sound gets correctly sampled at 48000. Once done, the sound is perfect.
>
> okay good.
>
> >Thank you very much for your help. Kind regards,
>
> no problem.
>
> BTW, do I understand that you needed these changes
> for S-VIDEO/COMPOSITE LINE-IN or did you solve the problem by
> just lowering the input volume from your input device? I don't
> have that opportunity personally with one DVD player.
>
> >  Eduard Huguet
>
> bye
>
> --
>
>  // /
> {:)==={ Darron Broad <darron@kewl.org>
>  \\ \
>
>

------=_Part_121719_2975681.1227543825911
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi, <br>&nbsp;&nbsp;&nbsp; I&#39;ve tested you driver compared to the offcial LinuxTV HG tree, and I **think** (can be wrong, though...) that I&#39;m getting &quot;correct&quot; audio when using a higher input volume. I mean, both drivers delivers crackly sound when given a high volume input, but yours seems to hold up a higher volume level before starting to fail.<br>
<br>I hope this means anything to you... :D<br><br>Regards, <br>&nbsp; Eduard<br><br><br><br><div class="gmail_quote">2008/11/24 Darron Broad <span dir="ltr">&lt;<a href="mailto:darron@kewl.org">darron@kewl.org</a>&gt;</span><br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">In message &lt;<a href="mailto:617be8890811240626y6452709bk34b276c21a9ea5c6@mail.gmail.com">617be8890811240626y6452709bk34b276c21a9ea5c6@mail.gmail.com</a>&gt;, &quot;Eduard Huguet&quot; wrote:<br>

<br>
hiya.<br>
<div class="Ih2E3d"><br>
&gt;Ok, problem solved: I needed to define a V4L &quot;recording profile&quot; in MythTV,<br>
&gt;so sound gets correctly sampled at 48000. Once done, the sound is perfect.<br>
<br>
</div>okay good.<br>
<div class="Ih2E3d"><br>
&gt;Thank you very much for your help. Kind regards,<br>
<br>
</div>no problem.<br>
<br>
BTW, do I understand that you needed these changes<br>
for S-VIDEO/COMPOSITE LINE-IN or did you solve the problem by<br>
just lowering the input volume from your input device? I don&#39;t<br>
have that opportunity personally with one DVD player.<br>
<br>
&gt; &nbsp;Eduard Huguet<br>
<br>
bye<br>
<font color="#888888"><br>
--<br>
<br>
&nbsp;// /<br>
{:)==={ Darron Broad &lt;<a href="mailto:darron@kewl.org">darron@kewl.org</a>&gt;<br>
&nbsp;\\ \<br>
<br>
</font></blockquote></div><br>

------=_Part_121719_2975681.1227543825911--


--===============0467346737==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0467346737==--
