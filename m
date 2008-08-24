Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <ke2705@gmx.de>) id 1KXAhi-0005Up-L2
	for linux-dvb@linuxtv.org; Sun, 24 Aug 2008 10:12:08 +0200
Message-ID: <48B117E3.4000805@gmx.de>
Date: Sun, 24 Aug 2008 10:12:19 +0200
From: Eberhard Kaltenhaeuser <ke2705@gmx.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48B00D6C.8080302@gmx.de> <48B01765.8020104@gmail.com>
	<200808231711.36277@orion.escape-edv.de>
In-Reply-To: <200808231711.36277@orion.escape-edv.de>
Cc: Patrick Boettcher <pb@linuxtv.org>
Subject: Re: [linux-dvb] Support of Nova S SE DVB card missing
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1562140334=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1562140334==
Content-Type: multipart/alternative;
 boundary="------------010301090707060501080903"

This is a multi-part message in MIME format.
--------------010301090707060501080903
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oliver,

the patch fixed the problem - here the relevant part of the log:

Aug 24 09:40:07 vdrdev user.info kernel: [   13.943338] DVB: registering new adapter (TT-Budget/WinTV-NOVA-S  PCI)
Aug 24 09:40:07 vdrdev user.warn kernel: [   13.966605] adapter has MAC addr = 00:d0:5c:23:72:54
Aug 24 09:40:07 vdrdev user.warn kernel: [   14.064407] DVB: registering frontend 1 (Samsung S5H1420/PnpNetwork PN1010 DVB-S)...

Thanx to all - also to Dr.Seltsam for compiling.
Eberhard

Oliver Endriss schrieb:
> e9hack wrote:
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
>
> I think you are right.
>
> Btw, I don't understand Patrick's workaround.
>
> As the tuner does not support repeated start conditions, the solution
> is to send two separate messages, as it was before.
>
> Does the attached patch fix the problem?
>
> CU
> Oliver
>
>   
> ------------------------------------------------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

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

--------------010301090707060501080903
Content-Type: text/html; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-15"
 http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
<font face="Times New Roman">Hi Oliver,<br>
<br>
the patch fixed the problem - here the relevant part of the log:<br>
</font><br>
<pre>Aug 24 09:40:07 vdrdev user.info kernel: [   13.943338] DVB: registering new adapter (TT-Budget/WinTV-NOVA-S  PCI)
Aug 24 09:40:07 vdrdev user.warn kernel: [   13.966605] adapter has MAC addr = 00:d0:5c:23:72:54
Aug 24 09:40:07 vdrdev user.warn kernel: [   14.064407] DVB: registering frontend 1 (Samsung S5H1420/PnpNetwork PN1010 DVB-S)...
</pre>
Thanx to all - also to Dr.Seltsam for compiling.<br>
Eberhard<br>
<br>
Oliver Endriss schrieb:
<blockquote cite="mid:200808231711.36277@orion.escape-edv.de"
 type="cite">
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
  <pre wrap=""><pre wrap="">
<hr size="4" width="90%">
_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></pre></pre>
</blockquote>
<br>
<div class="moz-signature">-- <br>
<meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">
<title>Signatur_2</title>
<font size="-1"><span
 style="font-family: Courier New,Courier,monospace;">        
___________________________________</span><br
 style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">       
|                                  
|</span><br style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">       
|      <span style="font-weight: bold;">Eberhard
Kaltenhaeuser</span>      
|</span><br style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">     
_ | (+49/0)9135 Tel:799955 Fax:725517 | _</span><br
 style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">    
/
)|                                  
|( \</span><br style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">   
/ / |       <a href="mailto:ke2705@gmx.de">mailto:ke2705@gmx.de</a>       
| \ \</span><br style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">  _( (_
| 
_                            
_  | _) )_</span><br style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;"> (((\
\&gt;|_/ )___________________________( \_|&lt;/ /)))</span><br
 style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;"> (\
\  \_/
/                            
\ \_/  / /)</span><br
 style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;"> 
\      
/                              
\       /</span><br style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">  
\   
_/                                
\_    /</span><br style="font-family: Courier New,Courier,monospace;">
<span style="font-family: Courier New,Courier,monospace;">  
/  
/                                    
\   \</span></font>
<br style="font-family: Courier New,Courier,monospace;">
</div>
</body>
</html>

--------------010301090707060501080903--


--===============1562140334==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1562140334==--
