Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mjenks1968@gmail.com>) id 1LH6Vs-0006Vq-9I
	for linux-dvb@linuxtv.org; Mon, 29 Dec 2008 02:01:44 +0100
Received: by wf-out-1314.google.com with SMTP id 27so5453303wfd.17
	for <linux-dvb@linuxtv.org>; Sun, 28 Dec 2008 17:01:39 -0800 (PST)
Message-ID: <e5df86c90812281701x561691ej219ee83604bbb083@mail.gmail.com>
Date: Sun, 28 Dec 2008 19:01:39 -0600
From: "Mark Jenks" <mjenks1968@gmail.com>
To: CityK <cityk@rogers.com>
In-Reply-To: <49580FAB.2000003@rogers.com>
MIME-Version: 1.0
References: <e5df86c90812270840w2fd6be64l40f9838aef23db4f@mail.gmail.com>
	<1230500176.3120.60.camel@palomino.walls.org>
	<e5df86c90812281451o111e3ebem77c7d9bb8469e149@mail.gmail.com>
	<49580FAB.2000003@rogers.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problems with kernel oops when installing HVR-1800.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1194404423=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1194404423==
Content-Type: multipart/alternative;
	boundary="----=_Part_127015_10099368.1230512499552"

------=_Part_127015_10099368.1230512499552
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Dec 28, 2008 at 5:45 PM, CityK <cityk@rogers.com> wrote:

> Mark Jenks wrote:
> >
> >
> > On Sun, Dec 28, 2008 at 3:36 PM, Andy Walls <awalls@radix.net
> > <mailto:awalls@radix.net>> wrote:
> >
> >     If one of these devices only has DVB support and no analog V4L
> >     support,
> >     then it would make sense why one of them would have "h->video_dev"
> set
> >     to NULL.  The device shouldn't have a V4L2 "video_dev" if it doesn't
> >     support analog (V4L2) devices.  I believe the 1800 supports analog
> >     video
> >     but the 1250 does not (someone correct me on this if I'm wrong -
> >     I'm no
> >     expert on these devices).
> >
> >
> > Andy,
> >
> > You are correct.  They are both are cx23885 cards, and only one of
> > them has an analog input to it. The 1250 is a DVB and the 1800 is DVB,
> > but is a MCE card with analog(svideo, etc), in.
> >
>
> The HVR-1250 device itself supports analogue, but such support is not
> yet realized within the cx23885 driver.
>

Wow, actually it has an svideo in that I never paid attention to.  Maybe
someday I'll be able to use both of the analog in for both the 1250 and the
1800 (not keeping my hopes up here).


-Mark

------=_Part_127015_10099368.1230512499552
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">On Sun, Dec 28, 2008 at 5:45 PM, CityK <span dir="ltr">&lt;<a href="mailto:cityk@rogers.com">cityk@rogers.com</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d">Mark Jenks wrote:<br>
&gt;<br>
&gt;<br>
&gt; On Sun, Dec 28, 2008 at 3:36 PM, Andy Walls &lt;<a href="mailto:awalls@radix.net">awalls@radix.net</a><br>
</div><div class="Ih2E3d">&gt; &lt;mailto:<a href="mailto:awalls@radix.net">awalls@radix.net</a>&gt;&gt; wrote:<br>
&gt;<br>
&gt; &nbsp; &nbsp; If one of these devices only has DVB support and no analog V4L<br>
&gt; &nbsp; &nbsp; support,<br>
&gt; &nbsp; &nbsp; then it would make sense why one of them would have &quot;h-&gt;video_dev&quot; set<br>
&gt; &nbsp; &nbsp; to NULL. &nbsp;The device shouldn&#39;t have a V4L2 &quot;video_dev&quot; if it doesn&#39;t<br>
&gt; &nbsp; &nbsp; support analog (V4L2) devices. &nbsp;I believe the 1800 supports analog<br>
&gt; &nbsp; &nbsp; video<br>
&gt; &nbsp; &nbsp; but the 1250 does not (someone correct me on this if I&#39;m wrong -<br>
&gt; &nbsp; &nbsp; I&#39;m no<br>
&gt; &nbsp; &nbsp; expert on these devices).<br>
&gt;<br>
&gt;<br>
</div><div class="Ih2E3d">&gt; Andy,<br>
&gt;<br>
&gt; You are correct. &nbsp;They are both are cx23885 cards, and only one of<br>
&gt; them has an analog input to it. The 1250 is a DVB and the 1800 is DVB,<br>
&gt; but is a MCE card with analog(svideo, etc), in.<br>
&gt;<br>
<br>
</div>The HVR-1250 device itself supports analogue, but such support is not<br>
yet realized within the cx23885 driver.<br>
</blockquote></div><br>Wow, actually it has an svideo in that I never paid attention to.&nbsp; Maybe someday I&#39;ll be able to use both of the analog in for both the 1250 and the 1800 (not keeping my hopes up here).<br><br>
<br>-Mark<br>

------=_Part_127015_10099368.1230512499552--


--===============1194404423==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1194404423==--
