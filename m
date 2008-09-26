Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lucastim@gmail.com>) id 1Kj1nc-00035I-TA
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 03:07:13 +0200
Received: by wf-out-1314.google.com with SMTP id 27so828658wfd.17
	for <linux-dvb@linuxtv.org>; Thu, 25 Sep 2008 18:07:07 -0700 (PDT)
Message-ID: <e32e0e5d0809251807l6f0080c3j673af97821454581@mail.gmail.com>
Date: Thu, 25 Sep 2008 18:07:07 -0700
From: "Tim Lucas" <lucastim@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>, "linux dvb" <linux-dvb@linuxtv.org>
In-Reply-To: <48DADA06.9000105@linuxtv.org>
MIME-Version: 1.0
References: <e32e0e5d0809171545r3c2e58beh62d58fa6d04dae71@mail.gmail.com>
	<48D34C69.6050700@linuxtv.org>
	<e32e0e5d0809232045j56bef9ah1ec3ac59401de0d5@mail.gmail.com>
	<e32e0e5d0809232050s1d0257e3m30c9c055e9d32dd6@mail.gmail.com>
	<48DA9330.6070005@linuxtv.org>
	<e32e0e5d0809241315rd423c0dj553812167194d4a3@mail.gmail.com>
	<48DADA06.9000105@linuxtv.org>
Subject: Re: [linux-dvb] Porting analog support from HVR-1500 to the DViCO
	FusionHDTV7 Dual Express (Read this one)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1776700965=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1776700965==
Content-Type: multipart/alternative;
	boundary="----=_Part_2765_2646430.1222391227378"

------=_Part_2765_2646430.1222391227378
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

OK, so I tested both s-video and composite inputs.  I get video for s-video,
but not composite.  The video seems to flicker a little bit in tv time.  I
just have standard rca cables plugged in for audio, but I can;t get any
sound.I tried changing the "tuner-type" to 0xc2, 0xc4, and 0x61.  All three
gave the same results.

     --Tim


On Wed, Sep 24, 2008 at 5:23 PM, Steven Toth <stoth@linuxtv.org> wrote:

> Tim Lucas wrote:
>
>> OK, so I'm a little dumb.  How do you want me to test those.  Should I
>> hook up some device to the S-Video input like my DVD player?
>>     --Tim
>>
>> On Wed, Sep 24, 2008 at 12:21 PM, Steven Toth <stoth@linuxtv.org <mailto:
>> stoth@linuxtv.org>> wrote:
>>
>>    Tim Lucas wrote:
>>
>>        I forgot to mention that I commented out the digital tuner at
>>        .portc first.  Then I tried to tune channels, but could not.
>>         Then I changed the tuner to 0xc8 >> 1, leaving .portc commented
>>        out.  I still could not tune channels.
>>
>>            --Tim
>>
>>
>>
>>    I really need you to test composite or svideo, did you do this?
>>
>>    - Steve
>>
>>
>>
>>
>> --
>> --Tim
>>
>
> Yes, hook up a dvd player to the svideo adapter cable, then use tvtime to
> switch the inputs to svideo.
>
> I suspect (hope?) this should instantly work for you. If not, something is
> really wrong inside the cx25840 driver.
>
> Let me know.... also, be sure to try the composite input also.
>
> Regards,
>
> Steve
>



-- 
    --Tim

------=_Part_2765_2646430.1222391227378
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">OK, so I tested both s-video and composite inputs. &nbsp;I get video for s-video, but not composite. &nbsp;The video seems to flicker a little bit in tv time. &nbsp;I just have standard rca cables plugged in for audio, but I can;t get any sound.<div>
I tried changing the &quot;tuner-type&quot; to 0xc2, 0xc4, and 0x61. &nbsp;All three gave the same results.</div><div><br></div><div>&nbsp;&nbsp; &nbsp; --Tim</div><div><br></div><div><br><div class="gmail_quote">On Wed, Sep 24, 2008 at 5:23 PM, Steven Toth <span dir="ltr">&lt;<a href="mailto:stoth@linuxtv.org">stoth@linuxtv.org</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">Tim Lucas wrote:<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div class="Ih2E3d">
OK, so I&#39;m a little dumb. &nbsp;How do you want me to test those. &nbsp;Should I hook up some device to the S-Video input like my DVD player? &nbsp;<br>
 &nbsp; &nbsp; --Tim<br>
<br></div><div class="Ih2E3d">
On Wed, Sep 24, 2008 at 12:21 PM, Steven Toth &lt;<a href="mailto:stoth@linuxtv.org" target="_blank">stoth@linuxtv.org</a> &lt;mailto:<a href="mailto:stoth@linuxtv.org" target="_blank">stoth@linuxtv.org</a>&gt;&gt; wrote:<br>

<br>
 &nbsp; &nbsp;Tim Lucas wrote:<br>
<br>
 &nbsp; &nbsp; &nbsp; &nbsp;I forgot to mention that I commented out the digital tuner at<br>
 &nbsp; &nbsp; &nbsp; &nbsp;.portc first. &nbsp;Then I tried to tune channels, but could not.<br>
 &nbsp; &nbsp; &nbsp; &nbsp; Then I changed the tuner to 0xc8 &gt;&gt; 1, leaving .portc commented<br>
 &nbsp; &nbsp; &nbsp; &nbsp;out. &nbsp;I still could not tune channels.<br>
<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;--Tim<br>
<br>
<br>
<br>
 &nbsp; &nbsp;I really need you to test composite or svideo, did you do this?<br>
<br>
 &nbsp; &nbsp;- Steve<br>
<br>
<br>
<br>
<br>
-- <br>
--Tim<br>
</div></blockquote>
<br>
Yes, hook up a dvd player to the svideo adapter cable, then use tvtime to switch the inputs to svideo.<br>
<br>
I suspect (hope?) this should instantly work for you. If not, something is really wrong inside the cx25840 driver.<br>
<br>
Let me know.... also, be sure to try the composite input also.<br>
<br>
Regards,<br>
<br>
Steve<br>
</blockquote></div><br><br clear="all"><br>-- <br> &nbsp; &nbsp; --Tim<br>
</div></div>

------=_Part_2765_2646430.1222391227378--


--===============1776700965==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1776700965==--
