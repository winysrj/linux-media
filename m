Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f11.google.com ([209.85.217.11])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1L4Zu0-00080M-Ri
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 12:46:53 +0100
Received: by gxk4 with SMTP id 4so1810218gxk.17
	for <linux-dvb@linuxtv.org>; Mon, 24 Nov 2008 03:46:16 -0800 (PST)
Message-ID: <617be8890811240346r3aae6f31rfab45804419bfade@mail.gmail.com>
Date: Mon, 24 Nov 2008 12:46:16 +0100
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "Darron Broad" <darron@kewl.org>
In-Reply-To: <29500.1227284783@kewl.org>
MIME-Version: 1.0
References: <617be8890811210115x46b99879l7b78fcf7a1d59357@mail.gmail.com>
	<29500.1227284783@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Distorted analog sound when using an HVR-3000
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1031515788=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1031515788==
Content-Type: multipart/alternative;
	boundary="----=_Part_118418_19726167.1227527176070"

------=_Part_118418_19726167.1227527176070
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Nothing :(. The results are exactly the same: when I use the analog TV
input, the sound is bad but understable, but somehow "high pitched" fro some
reason.

When using s-video or composite (this, capturing sound from LineIn input)
the sound is completely broken: I'm getting only crackling noise,
ocassionaly disrupted by some fragments of which it should be the original
input sound...

This happens both in MythTV and when using mplayer, like i.e. using the
following command line:

mplayer tv:// -tv driver=v4l2:device=/dev/video0:norm=PAL-BG:\
input=1:alsa:adevice=hw.1,0:amode=1:volume=50:immediatemode=0:buffersize=3

Any ideas? I'm using a fresh copy of http://hg.kewl.org/v4l-dvb/ repository.

Best regards,
  Eduard Huguet



2008/11/21 Darron Broad <darron@kewl.org>

> In message <617be8890811210115x46b99879l7b78fcf7a1d59357@mail.gmail.com>,
> "Eduard Huguet" wrote:
>
> LO
>
> >Hi,
> >    I'm testing a Hauppauge HVR-3000 for its use with MythTV, and I'm
> >observing that I have a completely distorted sound when using any of the
> >analog inputs (TV, S-Video or Composite). The sound is completely crackly,
> >not understanble at all, just noise. I've teste 2 different cards, so I'm
> >pretty sure it's not a "faulty card" issue.
> >
> >This happens both in MythTV or when using directly mplayer to capture
> video
> >& audio.
> >
> >I'm using an up-to-date HG DVB repository.
>
> There are some known problem with cards using the WM8775 codec.
>
> Use this repo here:
>        http://hg.kewl.org/v4l-dvb/
>
> It changes how the WM8775 operates and you will be able to
> control the input levels using v4l2-ctl.
>
> Please tell me if this solves your problems.
>
> Good luck
>
> --
>
>  // /
> {:)==={ Darron Broad <darron@kewl.org>
>  \\ \
>
>

------=_Part_118418_19726167.1227527176070
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Nothing :(. The results are exactly the same: when I use the analog TV input, the sound is bad but understable, but somehow &quot;high pitched&quot; fro some reason.<br><br>When using s-video or composite (this, capturing sound from LineIn input) the sound is completely broken: I&#39;m getting only crackling noise, ocassionaly disrupted by some fragments of which it should be the original input sound...<br>
<br>This happens both in MythTV and when using mplayer, like i.e. using the following command line:<br><br><div style="margin-left: 40px; font-family: courier new,monospace;">mplayer tv:// -tv driver=v4l2:device=/dev/video0:norm=PAL-BG:\<br>
input=1:alsa:adevice=hw.1,0:amode=1:volume=50:immediatemode=0:buffersize=3<br></div><br>Any ideas? I&#39;m using a fresh copy of <a href="http://hg.kewl.org/v4l-dvb/">http://hg.kewl.org/v4l-dvb/</a> repository.<br><br>Best regards, <br>
&nbsp; Eduard Huguet<br><br><br><br><div class="gmail_quote">2008/11/21 Darron Broad <span dir="ltr">&lt;<a href="mailto:darron@kewl.org">darron@kewl.org</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
In message &lt;<a href="mailto:617be8890811210115x46b99879l7b78fcf7a1d59357@mail.gmail.com">617be8890811210115x46b99879l7b78fcf7a1d59357@mail.gmail.com</a>&gt;, &quot;Eduard Huguet&quot; wrote:<br>
<br>
LO<br>
<div><div></div><div class="Wj3C7c"><br>
&gt;Hi,<br>
&gt; &nbsp; &nbsp;I&#39;m testing a Hauppauge HVR-3000 for its use with MythTV, and I&#39;m<br>
&gt;observing that I have a completely distorted sound when using any of the<br>
&gt;analog inputs (TV, S-Video or Composite). The sound is completely crackly,<br>
&gt;not understanble at all, just noise. I&#39;ve teste 2 different cards, so I&#39;m<br>
&gt;pretty sure it&#39;s not a &quot;faulty card&quot; issue.<br>
&gt;<br>
&gt;This happens both in MythTV or when using directly mplayer to capture video<br>
&gt;&amp; audio.<br>
&gt;<br>
&gt;I&#39;m using an up-to-date HG DVB repository.<br>
<br>
</div></div>There are some known problem with cards using the WM8775 codec.<br>
<br>
Use this repo here:<br>
 &nbsp; &nbsp; &nbsp; &nbsp;<a href="http://hg.kewl.org/v4l-dvb/" target="_blank">http://hg.kewl.org/v4l-dvb/</a><br>
<br>
It changes how the WM8775 operates and you will be able to<br>
control the input levels using v4l2-ctl.<br>
<br>
Please tell me if this solves your problems.<br>
<br>
Good luck<br>
<font color="#888888"><br>
--<br>
<br>
&nbsp;// /<br>
{:)==={ Darron Broad &lt;<a href="mailto:darron@kewl.org">darron@kewl.org</a>&gt;<br>
&nbsp;\\ \<br>
<br>
</font></blockquote></div><br>

------=_Part_118418_19726167.1227527176070--


--===============1031515788==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1031515788==--
