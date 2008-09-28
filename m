Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.229])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lucastim@gmail.com>) id 1KjyDF-0006bm-S4
	for linux-dvb@linuxtv.org; Sun, 28 Sep 2008 17:29:34 +0200
Received: by rv-out-0506.google.com with SMTP id b25so1508168rvf.41
	for <linux-dvb@linuxtv.org>; Sun, 28 Sep 2008 08:29:28 -0700 (PDT)
Message-ID: <e32e0e5d0809280829l690d076epe62f4d131806a65a@mail.gmail.com>
Date: Sun, 28 Sep 2008 08:29:28 -0700
From: "Tim Lucas" <lucastim@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>, "linux dvb" <linux-dvb@linuxtv.org>
In-Reply-To: <e32e0e5d0809251807l6f0080c3j673af97821454581@mail.gmail.com>
MIME-Version: 1.0
References: <e32e0e5d0809171545r3c2e58beh62d58fa6d04dae71@mail.gmail.com>
	<48D34C69.6050700@linuxtv.org>
	<e32e0e5d0809232045j56bef9ah1ec3ac59401de0d5@mail.gmail.com>
	<e32e0e5d0809232050s1d0257e3m30c9c055e9d32dd6@mail.gmail.com>
	<48DA9330.6070005@linuxtv.org>
	<e32e0e5d0809241315rd423c0dj553812167194d4a3@mail.gmail.com>
	<48DADA06.9000105@linuxtv.org>
	<e32e0e5d0809251807l6f0080c3j673af97821454581@mail.gmail.com>
Subject: Re: [linux-dvb] Porting analog support from HVR-1500 to the DViCO
	FusionHDTV7 Dual Express (Read this one)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0880467956=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0880467956==
Content-Type: multipart/alternative;
	boundary="----=_Part_45364_15385893.1222615768626"

------=_Part_45364_15385893.1222615768626
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Sep 25, 2008 at 6:07 PM, Tim Lucas <lucastim@gmail.com> wrote:

> OK, so I tested both s-video and composite inputs.  I get video for
> s-video, but not composite.  The video seems to flicker a little bit in tv
> time.  I just have standard rca cables plugged in for audio, but I can;t get
> any sound. I tried changing the "tuner-type" to 0xc2, 0xc4, and 0x61.  All
> three gave the same results.
>
>      --Tim
>

So the good news was that the s-video was working.  I want to make sure that
I hooked up the sound correctly.  I can't imagine that there is any other
way than the rca cables.  So what is next?

The only things that I can adjust in cx23885-cards.c is the "tuner-type"
 I've tried various suggestions, but had no luck.  Are there other
parameters that can be changed?

     --Tim

------=_Part_45364_15385893.1222615768626
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><div class="gmail_quote">On Thu, Sep 25, 2008 at 6:07 PM, Tim Lucas <span dir="ltr">&lt;<a href="mailto:lucastim@gmail.com">lucastim@gmail.com</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
<div dir="ltr">OK, so I tested both s-video and composite inputs. &nbsp;I get video for s-video, but not composite. &nbsp;The video seems to flicker a little bit in tv time. &nbsp;I just have standard rca cables plugged in for audio, but I can;t get any sound.<div>

I tried changing the &quot;tuner-type&quot; to 0xc2, 0xc4, and 0x61. &nbsp;All three gave the same results.</div><div><br></div><div>&nbsp;&nbsp; &nbsp; --Tim</div></div></blockquote><div><br></div><div>So the good news was that the s-video was working. &nbsp;I want to make sure that I hooked up the sound correctly. &nbsp;I can&#39;t imagine that there is any other way than the rca cables. &nbsp;So what is next?</div>
<div><br></div><div>The only things that I can adjust in cx23885-cards.c is the &quot;tuner-type&quot; &nbsp;I&#39;ve tried various suggestions, but had no luck. &nbsp;Are there other parameters that can be changed? &nbsp;</div><div><br>
</div><div>&nbsp;&nbsp; &nbsp; --Tim</div></div>
</div>

------=_Part_45364_15385893.1222615768626--


--===============0880467956==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0880467956==--
