Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.224])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <joshborke@gmail.com>) id 1L9ghq-0004Rc-G5
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 15:03:27 +0100
Received: by rv-out-0506.google.com with SMTP id b25so1147249rvf.41
	for <linux-dvb@linuxtv.org>; Mon, 08 Dec 2008 06:03:22 -0800 (PST)
Message-ID: <7d91b3760812080603ud42065dj5f298d45a1cb817a@mail.gmail.com>
Date: Mon, 8 Dec 2008 09:03:21 -0500
From: "Josh Borke" <joshborke@gmail.com>
To: linux-dvb@linuxtv.org, jeffd@i2k.com
In-Reply-To: <20081208040040.GA7855@blorp.plorb.com>
MIME-Version: 1.0
References: <7d91b3760812071828w57ba50d6h979d9d0f703d3080@mail.gmail.com>
	<20081208040040.GA7855@blorp.plorb.com>
Subject: Re: [linux-dvb] Hauppauge HVR-1800 Analog issues
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0706831660=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0706831660==
Content-Type: multipart/alternative;
	boundary="----=_Part_51448_5470432.1228745002024"

------=_Part_51448_5470432.1228745002024
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Dec 7, 2008 at 11:00 PM, Jeff DeFouw <jeffd@i2k.com> wrote:

> On Sun, Dec 07, 2008 at 09:28:17PM -0500, Josh Borke wrote:
> > I recently upgraded to Fedora 10 and decided to try to get my Hauppauge
> > HVR-1800 working. I thought everything was working fine and well because
> I
> > could run 'tvtime -d /dev/video0' and 'cat /dev/video1 > /tmp/test.mpg'
> and
> > things worked but then I rebooted and it all went to pot. Now when I run
> > 'cat /dev/video1 > /tmp/test.mpg' the output of tvtime becomes wavy and
> > distorted. I tried loading both cx25840 and cx23885 with debug=1 but that
> > didn't help.  I also tried with the latest v4l-dvb sources
> > (v4l-dvb-7100e78482d7) with the same result.
> >
> > I've attached the dmesg in hopes of being some help.
> >
> > To recap, I can 'tvtime -d /dev/video0' and I get a great picture. As
> soon
> > as I 'cat /dev/video1 > /tmp/test.mpg' the picture goes wavy.
>
> I found the same thing while testing the analog tuner support (which I
> don't normally use).  It only happened the first time after boot.
> Unloading all of the modules (run "make rmmod" in the v4l-dvb sources)
> and reloading them always fixed it for me.  Also, make sure the tuner
> module is loaded after that.  Mine doesn't auto-load for some reason.
>
> --
> Jeff DeFouw <jeffd@i2k.com>
>
Ok, so that does work as long as I 'cat /dev/video1' before I reload the
module. Is there any way I can automate this so I don't have to do it
manually every reboot? Or any other fix for it?

Thanks,

-josh

------=_Part_51448_5470432.1228745002024
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">On Sun, Dec 7, 2008 at 11:00 PM, Jeff DeFouw <span dir="ltr">&lt;<a href="mailto:jeffd@i2k.com">jeffd@i2k.com</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d">On Sun, Dec 07, 2008 at 09:28:17PM -0500, Josh Borke wrote:<br>
&gt; I recently upgraded to Fedora 10 and decided to try to get my Hauppauge<br>
&gt; HVR-1800 working. I thought everything was working fine and well because I<br>
&gt; could run &#39;tvtime -d /dev/video0&#39; and &#39;cat /dev/video1 &gt; /tmp/test.mpg&#39; and<br>
&gt; things worked but then I rebooted and it all went to pot. Now when I run<br>
&gt; &#39;cat /dev/video1 &gt; /tmp/test.mpg&#39; the output of tvtime becomes wavy and<br>
&gt; distorted. I tried loading both cx25840 and cx23885 with debug=1 but that<br>
&gt; didn&#39;t help. &nbsp;I also tried with the latest v4l-dvb sources<br>
&gt; (v4l-dvb-7100e78482d7) with the same result.<br>
&gt;<br>
&gt; I&#39;ve attached the dmesg in hopes of being some help.<br>
&gt;<br>
&gt; To recap, I can &#39;tvtime -d /dev/video0&#39; and I get a great picture. As soon<br>
&gt; as I &#39;cat /dev/video1 &gt; /tmp/test.mpg&#39; the picture goes wavy.<br>
<br>
</div>I found the same thing while testing the analog tuner support (which I<br>
don&#39;t normally use). &nbsp;It only happened the first time after boot.<br>
Unloading all of the modules (run &quot;make rmmod&quot; in the v4l-dvb sources)<br>
and reloading them always fixed it for me. &nbsp;Also, make sure the tuner<br>
module is loaded after that. &nbsp;Mine doesn&#39;t auto-load for some reason.<br>
<font color="#888888"><br>
--<br>
Jeff DeFouw &lt;<a href="mailto:jeffd@i2k.com">jeffd@i2k.com</a>&gt;<br>
</font></blockquote></div>Ok, so that does work as long as I &#39;cat /dev/video1&#39; before I reload the module. Is there any way I can automate this so I don&#39;t have to do it manually every reboot? Or any other fix for it?<br>
<br>Thanks,<br><br>-josh<br>

------=_Part_51448_5470432.1228745002024--


--===============0706831660==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0706831660==--
