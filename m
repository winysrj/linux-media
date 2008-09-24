Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f20.google.com ([209.85.217.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lucastim@gmail.com>) id 1KiamS-0002Xi-Hi
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 22:16:13 +0200
Received: by gxk13 with SMTP id 13so6153620gxk.17
	for <linux-dvb@linuxtv.org>; Wed, 24 Sep 2008 13:15:38 -0700 (PDT)
Message-ID: <e32e0e5d0809241315rd423c0dj553812167194d4a3@mail.gmail.com>
Date: Wed, 24 Sep 2008 13:15:37 -0700
From: "Tim Lucas" <lucastim@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>, "linux dvb" <linux-dvb@linuxtv.org>
In-Reply-To: <48DA9330.6070005@linuxtv.org>
MIME-Version: 1.0
References: <e32e0e5d0809171545r3c2e58beh62d58fa6d04dae71@mail.gmail.com>
	<48D34C69.6050700@linuxtv.org>
	<e32e0e5d0809232045j56bef9ah1ec3ac59401de0d5@mail.gmail.com>
	<e32e0e5d0809232050s1d0257e3m30c9c055e9d32dd6@mail.gmail.com>
	<48DA9330.6070005@linuxtv.org>
Subject: Re: [linux-dvb] Porting analog support from HVR-1500 to the DViCO
	FusionHDTV7 Dual Express (Read this one)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0790855395=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0790855395==
Content-Type: multipart/alternative;
	boundary="----=_Part_56712_17313917.1222287337562"

------=_Part_56712_17313917.1222287337562
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

OK, so I'm a little dumb.  How do you want me to test those.  Should I hook
up some device to the S-Video input like my DVD player?
     --Tim

On Wed, Sep 24, 2008 at 12:21 PM, Steven Toth <stoth@linuxtv.org> wrote:

> Tim Lucas wrote:
>
>> I forgot to mention that I commented out the digital tuner at .portc
>> first.  Then I tried to tune channels, but could not.  Then I changed the
>> tuner to 0xc8 >> 1, leaving .portc commented out.  I still could not tune
>> channels.
>>
>>     --Tim
>>
>>
>>
> I really need you to test composite or svideo, did you do this?
>
> - Steve
>



-- 
--Tim

------=_Part_56712_17313917.1222287337562
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">OK, so I&#39;m a little dumb. &nbsp;How do you want me to test those. &nbsp;Should I hook up some device to the S-Video input like my DVD player? &nbsp;<div><br></div><div>&nbsp;&nbsp; &nbsp; --Tim<br><br><div class="gmail_quote">On Wed, Sep 24, 2008 at 12:21 PM, Steven Toth <span dir="ltr">&lt;<a href="mailto:stoth@linuxtv.org">stoth@linuxtv.org</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;"><div class="Ih2E3d">Tim Lucas wrote:<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
I forgot to mention that I commented out the digital tuner at .portc first. &nbsp;Then I tried to tune channels, but could not. &nbsp;Then I changed the tuner to 0xc8 &gt;&gt; 1, leaving .portc commented out. &nbsp;I still could not tune channels.<br>

<br>
 &nbsp; &nbsp; --Tim<br>
<br>
<br>
</blockquote>
<br></div>
I really need you to test composite or svideo, did you do this?<br>
<br>
- Steve<br>
</blockquote></div><br><br clear="all"><br>-- <br> --Tim<br>
</div></div>

------=_Part_56712_17313917.1222287337562--


--===============0790855395==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0790855395==--
