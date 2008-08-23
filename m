Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <ke2705@gmx.de>) id 1KWxfQ-0001hj-Ik
	for linux-dvb@linuxtv.org; Sat, 23 Aug 2008 20:16:53 +0200
Message-ID: <48B05420.5010807@gmx.de>
Date: Sat, 23 Aug 2008 20:17:04 +0200
From: Eberhard Kaltenhaeuser <ke2705@gmx.de>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>
References: <48B00D6C.8080302@gmx.de> <48B01765.8020104@gmail.com>
	<alpine.LRH.1.10.0808231704500.26788@pub5.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0808231704500.26788@pub5.ifh.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Support of Nova S SE DVB card missing
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0727566892=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0727566892==
Content-Type: multipart/alternative;
 boundary="------------010301010207010902070201"

This is a multi-part message in MIME format.
--------------010301010207010902070201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Patrick,

sorry, actually, i have no environment to compile drivers or kernels.

Eberhard


Patrick Boettcher schrieb:
> Hi Hartmut and Eberhard,
>
> thanks for pointing that out, I almost overlooked the previous mail from 
> Eberhard.
>
> Eberhard, are you able to try patches and to compile your own drivers in 
> order to help finding the best solution.
>
> One option is to put back the original code in case the 
> repeated-start-workaround is not set. But this one looks not very 
> protected. I mean between the two i2c_transfer-calls something else could 
> happen.
>
> Is there no other mean to tell to the i2c-adapter to do a repeated start 
> within one i2c_transfer-call?
>
> Another option would be to try to set the "repeated_start_workaround" 
> option also for the Nova SE card.
>
> What do you think?
>
> Patrick.
>
> --
>    Mail: patrick.boettcher@desy.de
>    WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
>
>
> On Sat, 23 Aug 2008, e9hack wrote:
>
>   
>> Eberhard Kaltenhaeuser schrieb:
>>     
>>> Actual kernel does not support the Hauppauge WinTV Nova S SE PCI card
>>> anymore:
>>>
>>>       
>> I think it is a problem of this changeset http://linuxtv.org/hg/v4l-dvb/rev/358d281e6a3d
>> from Patrick Boettcher. The S5H1420 isn't able to understand repeated start conditions.
>> The i2c-read code was changed from:
>>
>> 	if ((ret = i2c_transfer (state->i2c, &msg1, 1)) != 1)
>> 		return ret;
>>
>> 	if ((ret = i2c_transfer (state->i2c, &msg2, 1)) != 1)
>> 		return ret;
>>
>> to:
>> 	if (state->config->repeated_start_workaround) {
>> 		ret = i2c_transfer(state->i2c, msg, 3);
>> 		if (ret != 3)
>> 			return ret;
>> 	} else {
>> 		ret = i2c_transfer(state->i2c, &msg[1], 2);
>> 		if (ret != 2)
>> 			return ret;
>> 	}
>>
>> -Hartmut
>>
>>     
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   

-- 
         ___________________________________
        |                                   |
        |      Eberhard Kaltenhaeuser       |
      _ | (+49/0)9135 Tel:799955 Fax:725517 | _
     / )|                                   |( \
    / / |       mailto:ke2705@gmx.de        | \ \
  _( (_ |  _                             _  | _) )_
 (((\ \>|_/ )___________________________( \_|</ /)))
 (\ \  \_/ /                             \ \_/  / /)
  \       /                               \       /
   \    _/                                 \_    /
   /   /                                     \   \

--------------010301010207010902070201
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
<font face="Times New Roman">Hi Patrick,<br>
<br>
sorry, actually, i have no environment to compile drivers or kernels. <br>
<br>
Eberhard<br>
<br>
</font><br>
Patrick Boettcher schrieb:
<blockquote cite="mid:alpine.LRH.1.10.0808231704500.26788@pub5.ifh.de"
 type="cite">
  <pre wrap="">Hi Hartmut and Eberhard,

thanks for pointing that out, I almost overlooked the previous mail from 
Eberhard.

Eberhard, are you able to try patches and to compile your own drivers in 
order to help finding the best solution.

One option is to put back the original code in case the 
repeated-start-workaround is not set. But this one looks not very 
protected. I mean between the two i2c_transfer-calls something else could 
happen.

Is there no other mean to tell to the i2c-adapter to do a repeated start 
within one i2c_transfer-call?

Another option would be to try to set the "repeated_start_workaround" 
option also for the Nova SE card.

What do you think?

Patrick.

--
   Mail: <a class="moz-txt-link-abbreviated" href="mailto:patrick.boettcher@desy.de">patrick.boettcher@desy.de</a>
   WWW:  <a class="moz-txt-link-freetext" href="http://www.wi-bw.tfh-wildau.de/~pboettch/">http://www.wi-bw.tfh-wildau.de/~pboettch/</a>


On Sat, 23 Aug 2008, e9hack wrote:

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

-Hartmut

    </pre>
  </blockquote>
  <pre wrap=""><!---->
_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>

  </pre>
</blockquote>
<br>
<div class="moz-signature">-- <br>
<meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">
<title>Signatur_2</title>
<font size="-1"><span
 style="font-family: Courier New,Courier,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
___________________________________</span><br
 style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
|</span><br style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="font-weight: bold;">Eberhard
Kaltenhaeuser</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
|</span><br style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
_ | (+49/0)9135 Tel:799955 Fax:725517 | _</span><br
 style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;
/
)|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
|( \</span><br style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">&nbsp;&nbsp;&nbsp;
/ / | &nbsp; &nbsp; &nbsp; <a href="mailto:ke2705@gmx.de">mailto:ke2705@gmx.de</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
| \ \</span><br style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">&nbsp; _( (_
|&nbsp;
_&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
_&nbsp; | _) )_</span><br style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">&nbsp;(((\
\&gt;|_/ )___________________________( \_|&lt;/ /)))</span><br
 style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">&nbsp;(\
\&nbsp; \_/
/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
\ \_/&nbsp; / /)</span><br
 style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">&nbsp;
\&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
\&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /</span><br style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">&nbsp;&nbsp;
\&nbsp;&nbsp;&nbsp;
_/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
\_&nbsp;&nbsp;&nbsp; /</span><br style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">&nbsp;&nbsp;
/&nbsp;&nbsp;
/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
\&nbsp;&nbsp; \</span></font>
<br style="font-family: Courier New,Courier,monospace;">
</div>
</body>
</html>

--------------010301010207010902070201--


--===============0727566892==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0727566892==--
