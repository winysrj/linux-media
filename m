Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <websdaleandrew@googlemail.com>) id 1KD1QI-0007ow-Q0
	for linux-dvb@linuxtv.org; Sun, 29 Jun 2008 20:14:53 +0200
Received: by fk-out-0910.google.com with SMTP id f40so1340421fka.1
	for <linux-dvb@linuxtv.org>; Sun, 29 Jun 2008 11:14:47 -0700 (PDT)
Message-ID: <e37d7f810806291114p3cc3eef4rfaa69090d9e4ed25@mail.gmail.com>
Date: Sun, 29 Jun 2008 19:14:47 +0100
From: "Andrew Websdale" <websdaleandrew@googlemail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <e37d7f810806290918n4b6a95fdjc52dda2086a758de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_16401_12547644.1214763287065"
References: <e37d7f810806281609o527dfdb6w6d785560b20ee8fa@mail.gmail.com>
	<d9def9db0806290854k43fd66e6ua3eb5ca3730f3f0f@mail.gmail.com>
	<e37d7f810806290918n4b6a95fdjc52dda2086a758de@mail.gmail.com>
Subject: Re: [linux-dvb] Location of parser.pl
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_Part_16401_12547644.1214763287065
Content-Type: multipart/alternative;
	boundary="----=_Part_16402_23287549.1214763287065"

------=_Part_16402_23287549.1214763287065
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/6/29 Andrew Websdale <websdaleandrew@googlemail.com>:

>
>
> 2008/6/29 Markus Rechberger <mrechberger@gmail.com>:
>
>> 2008/6/29 Andrew Websdale <websdaleandrew@googlemail.com>:
>> > I'm looking for a copy of parser.pl - it seems to have disappeared from
>> the
>> > hg repos, or I might not have looked hard enough.
>>
>> I put the scripts and usbreplay together in one repository around 15
>> months ago.
>> http://mcentral.de/hg/~mrec/usbreplay<http://mcentral.de/hg/%7Emrec/usbreplay>
>>
>> -Markus
>>
>>   I'm  attempting to modify the M920x driver to work with my
>> > Dposh dvb-usb stick, which has a MT2060 tuner , unlike the existing
>> driver
>> > which works with the Q1010 instead & I wanted to generate some firmware
>> for
>> > it.(at the moment blue LED does not light & no result from scanning)
>>
>

I've parsed the UsbSnoop logs I got  - the new firmware file is loaded OK
although I've still to receive any TV or even light the LED.  The version
embedded in the fw file is "0.95 20051010" instead of "0.94 20050524" which
is in the existing dvb-usb-dposh-01.fw file.I've attached it, if anyone
wants to inspect it.

------=_Part_16402_23287549.1214763287065
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">2008/6/29 Andrew Websdale &lt;<a href="mailto:websdaleandrew@googlemail.com">websdaleandrew@googlemail.com</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br><br><div class="gmail_quote">2008/6/29 Markus Rechberger &lt;<a href="mailto:mrechberger@gmail.com" target="_blank">mrechberger@gmail.com</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d">
2008/6/29 Andrew Websdale &lt;<a href="mailto:websdaleandrew@googlemail.com" target="_blank">websdaleandrew@googlemail.com</a>&gt;:<br>
<div>&gt; I&#39;m looking for a copy of parser.pl - it seems to have disappeared from the<br>
&gt; hg repos, or I might not have looked hard enough.<br>
<br>
</div>I put the scripts and usbreplay together in one repository around 15 months ago.<br>
<a href="http://mcentral.de/hg/%7Emrec/usbreplay" target="_blank">http://mcentral.de/hg/~mrec/usbreplay</a><br>
<br>
-Markus<br>
</div><div><br><div class="Ih2E3d">&nbsp; I&#39;m &nbsp;attempting to modify the M920x driver to work with my<br></div>
&gt; Dposh dvb-usb stick, which has a MT2060 tuner , unlike the existing driver<div class="Ih2E3d"><br>
&gt; which works with the Q1010 instead &amp; I wanted to generate some firmware for<br></div>
&gt; it.(at the moment blue LED does not light &amp; no result from scanning)</div></blockquote></div></blockquote><div><br><br>I&#39;ve parsed the UsbSnoop logs I got&nbsp; - the new firmware file is loaded OK although I&#39;ve still to receive any TV or even light the LED.&nbsp; The version embedded in the fw file is &quot;0.95 20051010&quot; instead of &quot;0.94 20050524&quot; which is in the existing dvb-usb-dposh-01.fw file.I&#39;ve attached it, if anyone wants to inspect it.<br>
<br></div></div><br>

------=_Part_16402_23287549.1214763287065--

------=_Part_16401_12547644.1214763287065
Content-Type: application/octet-stream; name=dvb-usb-dposh-01.fw.new
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fi1ynwxc0
Content-Disposition: attachment; filename=dvb-usb-dposh-01.fw.new

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
------=_Part_16401_12547644.1214763287065
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_16401_12547644.1214763287065--
