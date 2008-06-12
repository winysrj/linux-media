Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from s433.sureserver.com ([64.14.74.71])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dan.lita@sttcr.org>) id 1K6qzc-0007OM-OR
	for linux-dvb@linuxtv.org; Thu, 12 Jun 2008 19:53:50 +0200
Message-ID: <485162A2.6070409@sttcr.org>
Date: Thu, 12 Jun 2008 20:53:38 +0300
From: Dan Lita <dan.lita@sttcr.org>
MIME-Version: 1.0
To: Vladimir Prudnikov <vpr@krastelcom.ru>,
	"linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
References: <20B2C1F8-9DFE-43C1-BACD-22DC74AE9136@krastelcom.ru>	<485100C3.2090908@sttcr.org>	<B582543D-F8CE-48ED-81B9-18665F49EEB6@krastelcom.ru>	<48512411.6000900@anevia.com>
	<41475762-773E-425C-BADA-C9FC86BA749B@krastelcom.ru>
In-Reply-To: <41475762-773E-425C-BADA-C9FC86BA749B@krastelcom.ru>
Subject: Re: [linux-dvb] Smit CAM problems
Reply-To: dan.lita@sttcr.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1457941155=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1457941155==
Content-Type: multipart/alternative;
 boundary="------------090708060007010904010809"

This is a multi-part message in MIME format.
--------------090708060007010904010809
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Dear Vladimir,

I took a closer look on the CI-CAM adapter from Technotrend.
There is a 3.3V voltage regulator (LM1117 DT 3.3V)

Similar, on the AD-SP400 it seems to be also a 3.3V voltage regulator (marked 1084-33PE). 
4046 board from Twinhan/Azurewave.

According to SMIT operation voltage for their modules is 4.5 to 5.5V

If in both cards the CAM takes power after these rectifiers 
you cannot have a guaranteed operation.

Dan 

Vladimir Prudnikov wrote:
> Do you think SMiT will be interested in hunting for bugs in linux  
> drivers? These modules apparently work fine with any other hardware  
> (I'm sure professional ones do!)
>
> Regards,
> Vladimir
>
> On Jun 12, 2008, at 5:26 PM, Frederic CAND wrote:
>
>   
>> Did you try to contact SMIT support ?
>>
>> Vladimir Prudnikov a écrit :
>>     
>>> Didn't try Aston CAMs with mpeg4. But they do up to 12 channels of   
>>> mpeg2 perfectly well. With no problems at all. SMiTs that are for  
>>> 8  services can do only 3 to 4 for me.
>>> I think it's some kind of a driver bug because it begins working  
>>> after  reinitialisation. Doesn't get hot. I have tried to call  
>>> Aston as well  but with no success yet.
>>> Regards,
>>> Vladimir
>>> On Jun 12, 2008, at 2:56 PM, dan.lita@sttcr.org wrote:
>>>       
>>>> Dear Vladimir,
>>>>
>>>> I read your post on linux-dvb list. We have an Aston Viaccess   
>>>> Professional 2.15 CAM .
>>>> I read that you also use Aston CAMS.  My question is whether your   
>>>> Aston Viaccess cam can descramble H264  feeds or not?
>>>> We have tried on a PACE HDTV receiver and a Tandberg unit and it   
>>>> does not descramble the H264 video pid. (black screen)
>>>> This does not happen with Viaccess RED cam.
>>>>
>>>> On older Common interface adapters from Technotrend, the one for  
>>>> TT  Premium DVB-S card, there was a jumper for 3V or 5V cam  
>>>> operation.
>>>> I assume the new CI adapter does not have such jumper. If it  
>>>> still  exist maybe it will be a good idea to switch from one  
>>>> voltage to the  other.
>>>> Another solution is to test whether it works or not for Irdeto to   
>>>> use an Alphacrypt Classic CAM which, at least in theory,  
>>>> according  to MASCOM, supports Irdeto.
>>>> The third thing is to notice whether the SMIT cam gets hot in   
>>>> operation. If it gets too hot maybe a fan similar to the one for   
>>>> graphics card must be put near the Common interface adapter.
>>>>
>>>> BTW. Do you have any e-mail address from Aston? I have tried to   
>>>> contact  them but there is no e-mail address in their website.
>>>>
>>>> Best regards,
>>>> Dan Lita
>>>>
>>>>
>>>> Vladimir Prudnikov wrote:
>>>>         
>>>>> Hello!
>>>>>
>>>>> I'm using SMIT cams to descramble channels on TT S-1500 and TT-   
>>>>> S2-3200. After some time of normal operation SMIT cams drop out   
>>>>> and  stop decrypting the stream. It needs to be removed from the  
>>>>> CI  slot  and reinserted to resume normal operation. Aston CAMs  
>>>>> have no  such  problems, but they don't support 0x652 Irdeto.
>>>>> I'm streaming with vlc. Tried many SMITs (Viaccess and Irdeto).   
>>>>> Same  problem everywhere.
>>>>>
>>>>> Regards,
>>>>> Vladimir
>>>>>
>>>>> _______________________________________________
>>>>> linux-dvb mailing list
>>>>> linux-dvb@linuxtv.org
>>>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>>>
>>>>>
>>>>>
>>>>>           
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>       
>> -- 
>> CAND Frederic
>> Product Manager
>> ANEVIA
>>     
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>
>   


--------------090708060007010904010809
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
<pre wrap="">Dear Vladimir,

I took a closer look on the CI-CAM adapter from Technotrend.
There is a 3.3V voltage regulator (LM1117 DT 3.3V)

Similar, on the AD-SP400 it seems to be also a 3.3V voltage regulator (marked 1084-33PE). 
4046 board from Twinhan/Azurewave.

According to SMIT operation voltage for their modules is 4.5 to 5.5V

If in both cards the CAM takes power after these rectifiers 
you cannot have a guaranteed operation.

Dan 
</pre>
Vladimir Prudnikov wrote:
<blockquote
 cite="mid:41475762-773E-425C-BADA-C9FC86BA749B@krastelcom.ru"
 type="cite">
  <pre wrap="">Do you think SMiT will be interested in hunting for bugs in linux  
drivers? These modules apparently work fine with any other hardware  
(I'm sure professional ones do!)

Regards,
Vladimir

On Jun 12, 2008, at 5:26 PM, Frederic CAND wrote:

  </pre>
  <blockquote type="cite">
    <pre wrap="">Did you try to contact SMIT support ?

Vladimir Prudnikov a &eacute;crit :
    </pre>
    <blockquote type="cite">
      <pre wrap="">Didn't try Aston CAMs with mpeg4. But they do up to 12 channels of   
mpeg2 perfectly well. With no problems at all. SMiTs that are for  
8  services can do only 3 to 4 for me.
I think it's some kind of a driver bug because it begins working  
after  reinitialisation. Doesn't get hot. I have tried to call  
Aston as well  but with no success yet.
Regards,
Vladimir
On Jun 12, 2008, at 2:56 PM, <a class="moz-txt-link-abbreviated" href="mailto:dan.lita@sttcr.org">dan.lita@sttcr.org</a> wrote:
      </pre>
      <blockquote type="cite">
        <pre wrap="">Dear Vladimir,

I read your post on linux-dvb list. We have an Aston Viaccess   
Professional 2.15 CAM .
I read that you also use Aston CAMS.  My question is whether your   
Aston Viaccess cam can descramble H264  feeds or not?
We have tried on a PACE HDTV receiver and a Tandberg unit and it   
does not descramble the H264 video pid. (black screen)
This does not happen with Viaccess RED cam.

On older Common interface adapters from Technotrend, the one for  
TT  Premium DVB-S card, there was a jumper for 3V or 5V cam  
operation.
I assume the new CI adapter does not have such jumper. If it  
still  exist maybe it will be a good idea to switch from one  
voltage to the  other.
Another solution is to test whether it works or not for Irdeto to   
use an Alphacrypt Classic CAM which, at least in theory,  
according  to MASCOM, supports Irdeto.
The third thing is to notice whether the SMIT cam gets hot in   
operation. If it gets too hot maybe a fan similar to the one for   
graphics card must be put near the Common interface adapter.

BTW. Do you have any e-mail address from Aston? I have tried to   
contact  them but there is no e-mail address in their website.

Best regards,
Dan Lita


Vladimir Prudnikov wrote:
        </pre>
        <blockquote type="cite">
          <pre wrap="">Hello!

I'm using SMIT cams to descramble channels on TT S-1500 and TT-   
S2-3200. After some time of normal operation SMIT cams drop out   
and  stop decrypting the stream. It needs to be removed from the  
CI  slot  and reinserted to resume normal operation. Aston CAMs  
have no  such  problems, but they don't support 0x652 Irdeto.
I'm streaming with vlc. Tried many SMITs (Viaccess and Irdeto).   
Same  problem everywhere.

Regards,
Vladimir

_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>



          </pre>
        </blockquote>
      </blockquote>
      <pre wrap="">_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>
      </pre>
    </blockquote>
    <pre wrap="">
-- 
CAND Frederic
Product Manager
ANEVIA
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
</body>
</html>

--------------090708060007010904010809--


--===============1457941155==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1457941155==--
