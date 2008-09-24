Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lucastim@gmail.com>) id 1KiLOE-0000rv-B0
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 05:50:10 +0200
Received: by wf-out-1314.google.com with SMTP id 27so2713274wfd.17
	for <linux-dvb@linuxtv.org>; Tue, 23 Sep 2008 20:50:06 -0700 (PDT)
Message-ID: <e32e0e5d0809232050s1d0257e3m30c9c055e9d32dd6@mail.gmail.com>
Date: Tue, 23 Sep 2008 20:50:06 -0700
From: "Tim Lucas" <lucastim@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>, "linux dvb" <linux-dvb@linuxtv.org>
In-Reply-To: <e32e0e5d0809232045j56bef9ah1ec3ac59401de0d5@mail.gmail.com>
MIME-Version: 1.0
References: <e32e0e5d0809171545r3c2e58beh62d58fa6d04dae71@mail.gmail.com>
	<48D34C69.6050700@linuxtv.org>
	<e32e0e5d0809232045j56bef9ah1ec3ac59401de0d5@mail.gmail.com>
Subject: Re: [linux-dvb] Porting analog support from HVR-1500 to the DViCO
	FusionHDTV7 Dual Express (Read this one)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1095521318=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1095521318==
Content-Type: multipart/alternative;
	boundary="----=_Part_35596_5761930.1222228206072"

------=_Part_35596_5761930.1222228206072
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I forgot to mention that I commented out the digital tuner at .portc first.
 Then I tried to tune channels, but could not.  Then I changed the tuner to
0xc8 >> 1, leaving .portc commented out.  I still could not tune channels.
     --Tim

------=_Part_35596_5761930.1222228206072
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">I forgot to mention that I commented out the digital tuner at .portc first. &nbsp;Then I tried to tune channels, but could not. &nbsp;Then I changed the tuner to 0xc8 &gt;&gt; 1, leaving .portc commented out. &nbsp;I still could not tune channels.<div>
<br></div><div>&nbsp;&nbsp; &nbsp; --Tim<br><br><div class="gmail_quote"><br></div>
</div></div>

------=_Part_35596_5761930.1222228206072--


--===============1095521318==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1095521318==--
