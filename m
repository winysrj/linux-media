Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <ke2705@gmx.de>) id 1KYjZc-0003a9-5a
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 17:38:15 +0200
Message-ID: <48B6C8D7.8000904@gmx.de>
Date: Thu, 28 Aug 2008 17:48:39 +0200
From: Eberhard Kaltenhaeuser <ke2705@gmx.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48B00D6C.8080302@gmx.de> <48B01765.8020104@gmail.com>
	<200808231711.36277@orion.escape-edv.de>
In-Reply-To: <200808231711.36277@orion.escape-edv.de>
Content-Type: multipart/mixed; boundary="------------000104040803060304060202"
Cc: Patrick Boettcher <pb@linuxtv.org>
Subject: Re: [linux-dvb] Support of Nova S SE DVB card missing
Reply-To: ke2705@gmx.de
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

This is a multi-part message in MIME format.
--------------000104040803060304060202
Content-Type: multipart/alternative;
 boundary="------------000701050706010702000604"


--------------000701050706010702000604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

against my expectation, the Nova-S SE card does not work, although the 
card is recognized by the kernel. Frontend modul is loaded, but no 
signal can be received. So VDR exists (Emergency exit) when switching to 
this device (i.e. to record something)

Any suggestions?
Eberhard

Oliver Endriss wrote:

>e9hack wrote:
>  
>
>>Eberhard Kaltenhaeuser schrieb:
>>    
>>
>>>Actual kernel does not support the Hauppauge WinTV Nova S SE PCI card 
>>>anymore:
>>>
>>>      
>>>
>>I think it is a problem of this changeset http://linuxtv.org/hg/v4l-dvb/rev/358d281e6a3d 
>>from Patrick Boettcher. The S5H1420 isn't able to understand repeated start conditions. 
>>The i2c-read code was changed from:
>>
>>	if ((ret = i2c_transfer (state->i2c, &msg1, 1)) != 1)
>>		return ret;
>>
>>	if ((ret = i2c_transfer (state->i2c, &msg2, 1)) != 1)
>>		return ret;
>>
>>to:
>>	if (state->config->repeated_start_workaround) {
>>		ret = i2c_transfer(state->i2c, msg, 3);
>>		if (ret != 3)
>>			return ret;
>>	} else {
>>		ret = i2c_transfer(state->i2c, &msg[1], 2);
>>		if (ret != 2)
>>			return ret;
>>	}
>>    
>>
>
>I think you are right.
>
>Btw, I don't understand Patrick's workaround.
>
>As the tuner does not support repeated start conditions, the solution
>is to send two separate messages, as it was before.
>
>Does the attached patch fix the problem?
>
>CU
>Oliver
>
>  
>
>------------------------------------------------------------------------
>
>diff -r 1760a612cc98 linux/drivers/media/dvb/frontends/s5h1420.c
>--- a/linux/drivers/media/dvb/frontends/s5h1420.c	Sun Aug 03 05:02:35 2008 +0200
>+++ b/linux/drivers/media/dvb/frontends/s5h1420.c	Sat Aug 23 17:07:01 2008 +0200
>@@ -94,8 +94,11 @@ static u8 s5h1420_readreg(struct s5h1420
> 		if (ret != 3)
> 			return ret;
> 	} else {
>-		ret = i2c_transfer(state->i2c, &msg[1], 2);
>-		if (ret != 2)
>+		ret = i2c_transfer(state->i2c, &msg[1], 1);
>+		if (ret != 1)
>+			return ret;
>+		ret = i2c_transfer(state->i2c, &msg[2], 1);
>+		if (ret != 1)
> 			return ret;
> 	}
> 
>  
>
>------------------------------------------------------------------------
>
>_______________________________________________
>linux-dvb mailing list
>linux-dvb@linuxtv.org
>http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

--------------000701050706010702000604
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
Hello,<br>
<br>
against my expectation, the Nova-S SE card does not work, although the
card is recognized by the kernel. Frontend modul is loaded, but no
signal can be received. So VDR exists (Emergency exit) when switching
to this device (i.e. to record something)<br>
<br>
Any suggestions?<br>
Eberhard<br>
<br>
Oliver Endriss wrote:
<blockquote cite="mid200808231711.36277@orion.escape-edv.de" type="cite">
  <pre wrap="">e9hack wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">Eberhard Kaltenhaeuser schrieb:
    </pre>
    <blockquote type="cite">
      <pre wrap="">Actual kernel does not support the Hauppauge WinTV Nova S SE PCI card 
anymore:

      </pre>
    </blockquote>
    <pre wrap="">I think it is a problem of this changeset <a class="moz-txt-link-freetext" href="http://linuxtv.org/hg/v4l-dvb/rev/358d281e6a3d">http://linuxtv.org/hg/v4l-dvb/rev/358d281e6a3d</a> 
from Patrick Boettcher. The S5H1420 isn't able to understand repeated start conditions. 
The i2c-read code was changed from:

	if ((ret = i2c_transfer (state-&gt;i2c, &amp;msg1, 1)) != 1)
		return ret;

	if ((ret = i2c_transfer (state-&gt;i2c, &amp;msg2, 1)) != 1)
		return ret;

to:
	if (state-&gt;config-&gt;repeated_start_workaround) {
		ret = i2c_transfer(state-&gt;i2c, msg, 3);
		if (ret != 3)
			return ret;
	} else {
		ret = i2c_transfer(state-&gt;i2c, &amp;msg[1], 2);
		if (ret != 2)
			return ret;
	}
    </pre>
  </blockquote>
  <pre wrap=""><!---->
I think you are right.

Btw, I don't understand Patrick's workaround.

As the tuner does not support repeated start conditions, the solution
is to send two separate messages, as it was before.

Does the attached patch fix the problem?

CU
Oliver

  </pre>
  <pre wrap="">
<hr size="4" width="90%">
diff -r 1760a612cc98 linux/drivers/media/dvb/frontends/s5h1420.c
--- a/linux/drivers/media/dvb/frontends/s5h1420.c	Sun Aug 03 05:02:35 2008 +0200
+++ b/linux/drivers/media/dvb/frontends/s5h1420.c	Sat Aug 23 17:07:01 2008 +0200
@@ -94,8 +94,11 @@ static u8 s5h1420_readreg(struct s5h1420
 		if (ret != 3)
 			return ret;
 	} else {
-		ret = i2c_transfer(state-&gt;i2c, &amp;msg[1], 2);
-		if (ret != 2)
+		ret = i2c_transfer(state-&gt;i2c, &amp;msg[1], 1);
+		if (ret != 1)
+			return ret;
+		ret = i2c_transfer(state-&gt;i2c, &amp;msg[2], 1);
+		if (ret != 1)
 			return ret;
 	}
 
  </pre>
  <pre wrap="">
<hr size="4" width="90%">
_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></pre>
</blockquote>
</body>
</html>

--------------000701050706010702000604--

--------------000104040803060304060202
Content-Type: text/x-vcard; charset=utf-8;
 name="ke2705.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ke2705.vcf"

begin:vcard
fn:Eberhard Kaltenhaeuser
n:Kaltenhaeuser;Eberhard
adr;dom:;;Obermembach 6;Hessdorf;;91093
email;internet:ke2705@gmx.de
tel;fax:+49 9135 725517
tel;home:+49 9135 799955
tel;cell:+49 173 3760676
version:2.1
end:vcard


--------------000104040803060304060202
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------000104040803060304060202--
