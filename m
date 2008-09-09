Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lucastim@gmail.com>) id 1KdALJ-0002ZM-RB
	for linux-dvb@linuxtv.org; Tue, 09 Sep 2008 23:01:46 +0200
Received: by yx-out-2324.google.com with SMTP id 8so1239278yxg.41
	for <linux-dvb@linuxtv.org>; Tue, 09 Sep 2008 14:01:41 -0700 (PDT)
Message-ID: <e32e0e5d0809091401w75909006uccd7a776d4d5bd35@mail.gmail.com>
Date: Tue, 9 Sep 2008 14:01:40 -0700
From: "Tim Lucas" <lucastim@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>, "linux dvb" <linux-dvb@linuxtv.org>,
	patrbois@magma.ca
MIME-Version: 1.0
Subject: Re: [linux-dvb] HVR-1500Q eeprom not being parsed correctly
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0058880389=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0058880389==
Content-Type: multipart/alternative;
	boundary="----=_Part_37497_24337222.1220994101019"

------=_Part_37497_24337222.1220994101019
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> Message: 5
> Date: Tue, 09 Sep 2008 10:52:53 -0400
> From: Steven Toth <stoth@linuxtv.org>
> Subject: Re: [linux-dvb] HVR-1500Q eeprom not being parsed correctly
> To: Patrick Boisvenue <patrbois@magma.ca>
> Cc: linux-dvb@linuxtv.org
> Message-ID: <48C68DC5.1050400@linuxtv.org>
> Content-Type: text/plain; charset=ISO-8859-1; format=flowed

> Patrick Boisvenue wrote:
>> I cannot get my new HVR-1500Q to work at all even though it's recognized
>> as such.  The best I was able to figure out was it does not like the
>> eeprom.  After enabling the debug mode on tveeprom, I got the following
>> when loading cx23885:

...

>> cx23885[0]: warning: unknown hauppauge model #0
>> cx23885[0]: hauppauge eeprom: model=0
>> cx23885[0]: cx23885 based dvb card

...

>> Did a hg pull -u http://linuxtv.org/hg/v4l-dvb earlier today so running
>> off recent codebase.

>Fixed it, see linuxtv.org/hg/~stoth/v4l-dvb<http://linuxtv.org/hg/%7Estoth/v4l-dvb>
.

>Pull the topmost patch and try again, please post your results back here.

>Thanks,

>Steve

This is the same problem that I was having

[  589.382427] tveeprom 5-0050: Encountered bad packet header [ff]. Corrupt
or not a Hauppauge eeprom.
[  589.382431] cx23885[0]: warning: unknown hauppauge model #0
[  589.382432] cx23885[0]: hauppauge eeprom: model=0

I was working with the cx23885-audio branch for the analog support.  Could
these changes be added to that branch as well?  Or could I get things
working by simply merging with the ~stoth/v4l-dvd branch?

-- 
--Tim

------=_Part_37497_24337222.1220994101019
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">&gt; Message: 5<br>
&gt; Date: Tue, 09 Sep 2008 10:52:53 -0400<br>
&gt; From: Steven Toth &lt;<a href="mailto:stoth@linuxtv.org" target="_blank">stoth@linuxtv.org</a>&gt;<br>
&gt; Subject: Re: [linux-dvb] HVR-1500Q eeprom not being parsed correctly<br>
&gt; To: Patrick Boisvenue &lt;<a href="mailto:patrbois@magma.ca" target="_blank">patrbois@magma.ca</a>&gt;<br>
&gt; Cc: <a href="mailto:linux-dvb@linuxtv.org" target="_blank">linux-dvb@linuxtv.org</a><br>&gt; Message-ID: &lt;<a href="mailto:48C68DC5.1050400@linuxtv.org" target="_blank">48C68DC5.1050400@linuxtv.org</a>&gt;<br>
&gt; Content-Type: text/plain; charset=ISO-8859-1; format=flowed<br>
<br>
&gt; Patrick Boisvenue wrote:<br>
&gt;&gt; I cannot get my new HVR-1500Q to work at all even though it&#39;s recognized<br>
&gt;&gt; as such. &nbsp;The best I was able to figure out was it does not like the<br>
&gt;&gt; eeprom. &nbsp;After enabling the debug mode on tveeprom, I got the following<br>
&gt;&gt; when loading cx23885:<br>
<br>
...<br>
<br>
&gt;&gt; cx23885[0]: warning: unknown hauppauge model #0<br>
&gt;&gt; cx23885[0]: hauppauge eeprom: model=0<br>
&gt;&gt; cx23885[0]: cx23885 based dvb card<br>
<br>
...<br>
<br>
&gt;&gt; Did a hg pull -u <a href="http://linuxtv.org/hg/v4l-dvb" target="_blank">http://linuxtv.org/hg/v4l-dvb</a> earlier today so running<br>
&gt;&gt; off recent codebase.<br>
<br>
&gt;Fixed it, see <a href="http://linuxtv.org/hg/%7Estoth/v4l-dvb" target="_blank">linuxtv.org/hg/~stoth/v4l-dvb</a>.<br>
<br>
&gt;Pull the topmost patch and try again, please post your results back here.<br>
<br>
&gt;Thanks,<br>
<br>
&gt;Steve<br clear="all"><br>This is the same problem that I was having<br><br><span style="border-collapse: collapse; font-family: Times; font-size: 16px;">[&nbsp; 589.382427] tveeprom 5-0050: Encountered bad packet header [ff]. Corrupt or not a Hauppauge eeprom.<br>
[&nbsp; 589.382431] cx23885[0]: warning: unknown hauppauge model #0<br>


[&nbsp; 589.382432] cx23885[0]: hauppauge eeprom: model=0</span><br><br>I was working with the cx23885-audio branch for the analog support.&nbsp; Could these changes be added to that branch as well?&nbsp; Or could I get things working by simply merging with the ~stoth/v4l-dvd branch?<br>

<br>-- <br> --Tim<br>
</div>

------=_Part_37497_24337222.1220994101019--


--===============0058880389==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0058880389==--
