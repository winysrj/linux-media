Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1L4aTu-0002Oh-8p
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 13:23:58 +0100
Received: by yx-out-2324.google.com with SMTP id 8so895066yxg.41
	for <linux-dvb@linuxtv.org>; Mon, 24 Nov 2008 04:23:53 -0800 (PST)
Message-ID: <617be8890811240423o6b8fc2e4jc94021cb14ec271a@mail.gmail.com>
Date: Mon, 24 Nov 2008 13:23:52 +0100
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "Darron Broad" <darron@kewl.org>
In-Reply-To: <18885.1227529079@kewl.org>
MIME-Version: 1.0
References: <617be8890811210115x46b99879l7b78fcf7a1d59357@mail.gmail.com>
	<29500.1227284783@kewl.org>
	<617be8890811240346r3aae6f31rfab45804419bfade@mail.gmail.com>
	<18885.1227529079@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Distorted analog sound when using an HVR-3000
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0106537089=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0106537089==
Content-Type: multipart/alternative;
	boundary="----=_Part_118823_15856484.1227529432549"

------=_Part_118823_15856484.1227529432549
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Ok, I need to rectify, at least partially, my last message: as you have
suggested now, the problem with s-video and composite audio capturing was
that the external device volume was set too high, which was apparently
saturating the audio input of the card. Lowering it was enough to capture
crystal clear sound... in mplayer.

In MythTV, now I have the problem that sound is playing strangelly
high-pitched. I really don't know how to explain it... I'm going to perform
some research to see if I can determine why sound is clear on mplayer and
not under MythTV.

Thanks for your help,
  Eduard




2008/11/24 Darron Broad <darron@kewl.org>

> In message <617be8890811240346r3aae6f31rfab45804419bfade@mail.gmail.com>,
> "Eduard Huguet" wrote:
>
> hi
>
> >Nothing :(. The results are exactly the same: when I use the analog TV
> >input, the sound is bad but understable, but somehow "high pitched" fro
> some
> >reason.
>
> okay. as it stands, analogue TV audio isn't affected by these changes
> so no change here is expected. i could see about changing this if you
> could live with mono only. however, this really would depend on whether
> any of this works for you at all...
>
> >When using s-video or composite (this, capturing sound from LineIn input)
> >the sound is completely broken: I'm getting only crackling noise,
> >ocassionaly disrupted by some fragments of which it should be the original
> >input sound...
>
> if this is the same problem as which has been addressed for analogue
> input (LINE-IN) for me on both an hvr-1300 and hvr-4000 then you can try to
> attenuate the input level even more to see if it improves things.
>
> >This happens both in MythTV and when using mplayer, like i.e. using the
> >following command line:
> >
> >mplayer tv:// -tv driver=v4l2:device=/dev/video0:norm=PAL-BG:\
> >input=1:alsa:adevice=hw.1,0:amode=1:volume=50:immediatemode=0:buffersize=3
> >
> >Any ideas? I'm using a fresh copy of http://hg.kewl.org/v4l-dvb/repository.
>
> The volume level can be from 0 to 63 try something even lower (10).
> If the volume= option doesn't work as anticipated then
> try v4l2-ctl -d /dev/video --set-ctrl=volume=XX as well.
>
> We can look at other things if you have the time for it, e-mail me off-list
> and we can look work something out.
>
> cya
>
> --
>
>  // /
> {:)==={ Darron Broad <darron@kewl.org>
>  \\ \
>
>

------=_Part_118823_15856484.1227529432549
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Ok, I need to rectify, at least partially, my last message: as you have suggested now, the problem with s-video and composite audio capturing was that the external device volume was set too high, which was apparently saturating the audio input of the card. Lowering it was enough to capture crystal clear sound... in mplayer.<br>
<br>In MythTV, now I have the problem that sound is playing strangelly high-pitched. I really don&#39;t know how to explain it... I&#39;m going to perform some research to see if I can determine why sound is clear on mplayer and not under MythTV.<br>
<br>Thanks for your help, <br>&nbsp; Eduard<br><br><br><br><br><div class="gmail_quote">2008/11/24 Darron Broad <span dir="ltr">&lt;<a href="mailto:darron@kewl.org">darron@kewl.org</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
In message &lt;<a href="mailto:617be8890811240346r3aae6f31rfab45804419bfade@mail.gmail.com">617be8890811240346r3aae6f31rfab45804419bfade@mail.gmail.com</a>&gt;, &quot;Eduard Huguet&quot; wrote:<br>
<br>
hi<br>
<div class="Ih2E3d"><br>
&gt;Nothing :(. The results are exactly the same: when I use the analog TV<br>
&gt;input, the sound is bad but understable, but somehow &quot;high pitched&quot; fro some<br>
&gt;reason.<br>
<br>
</div>okay. as it stands, analogue TV audio isn&#39;t affected by these changes<br>
so no change here is expected. i could see about changing this if you<br>
could live with mono only. however, this really would depend on whether<br>
any of this works for you at all...<br>
<div class="Ih2E3d"><br>
&gt;When using s-video or composite (this, capturing sound from LineIn input)<br>
&gt;the sound is completely broken: I&#39;m getting only crackling noise,<br>
&gt;ocassionaly disrupted by some fragments of which it should be the original<br>
&gt;input sound...<br>
<br>
</div>if this is the same problem as which has been addressed for analogue<br>
input (LINE-IN) for me on both an hvr-1300 and hvr-4000 then you can try to<br>
attenuate the input level even more to see if it improves things.<br>
<div class="Ih2E3d"><br>
&gt;This happens both in MythTV and when using mplayer, like i.e. using the<br>
&gt;following command line:<br>
&gt;<br>
&gt;mplayer tv:// -tv driver=v4l2:device=/dev/video0:norm=PAL-BG:\<br>
&gt;input=1:alsa:adevice=hw.1,0:amode=1:volume=50:immediatemode=0:buffersize=3<br>
&gt;<br>
&gt;Any ideas? I&#39;m using a fresh copy of <a href="http://hg.kewl.org/v4l-dvb/" target="_blank">http://hg.kewl.org/v4l-dvb/</a> repository.<br>
<br>
</div>The volume level can be from 0 to 63 try something even lower (10).<br>
If the volume= option doesn&#39;t work as anticipated then<br>
try v4l2-ctl -d /dev/video --set-ctrl=volume=XX as well.<br>
<br>
We can look at other things if you have the time for it, e-mail me off-list<br>
and we can look work something out.<br>
<br>
cya<br>
<font color="#888888"><br>
--<br>
<br>
&nbsp;// /<br>
{:)==={ Darron Broad &lt;<a href="mailto:darron@kewl.org">darron@kewl.org</a>&gt;<br>
&nbsp;\\ \<br>
<br>
</font></blockquote></div><br>

------=_Part_118823_15856484.1227529432549--


--===============0106537089==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0106537089==--
