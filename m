Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <websdaleandrew@googlemail.com>) id 1K938x-00078U-0K
	for linux-dvb@linuxtv.org; Wed, 18 Jun 2008 21:16:31 +0200
Received: by fk-out-0910.google.com with SMTP id f40so454906fka.1
	for <linux-dvb@linuxtv.org>; Wed, 18 Jun 2008 12:16:27 -0700 (PDT)
Message-ID: <e37d7f810806181216v490362afiace17205e362b227@mail.gmail.com>
Date: Wed, 18 Jun 2008 20:16:27 +0100
From: "Andrew Websdale" <websdaleandrew@googlemail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <e37d7f810806171229j72aa07cco5f82e4021317ef8f@mail.gmail.com>
MIME-Version: 1.0
References: <e37d7f810806111512w46a508b0h92047728ba38cac8@mail.gmail.com>
	<4850566E.8030001@iki.fi>
	<e37d7f810806120158g6257b7a9h429dd8b8f885321e@mail.gmail.com>
	<4850F597.9030603@iki.fi>
	<e37d7f810806120619q28bff0d8y8f2d5319187ab6b0@mail.gmail.com>
	<e37d7f810806171229j72aa07cco5f82e4021317ef8f@mail.gmail.com>
Subject: Re: [linux-dvb] Dposh DVB-T USB2.0 seems to not work properly
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1552189770=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1552189770==
Content-Type: multipart/alternative;
	boundary="----=_Part_1445_3334227.1213816587274"

------=_Part_1445_3334227.1213816587274
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/6/12 Andrew Websdale

>
>>
>> 2008/6/12 Antti Palosaari <crope@iki.fi>:
>> wrote:
>>
>>> OK, then the reason might by tuner. Tuner may be changed to other one or
>>> tuner i2c-address is changed. I doubt whole tuner is changed. Now we should
>>> identify which tuner is used. There is some ways how to do that.
>>>
>>> 1) Look from Windows driver files
>>> 2) Open stick and look chips
>>> 3) Take USB-sniffs and try to identify tuner from there
>>
>>
> I've opened the stick & there's an MT352 (as expected) but the other chip
> is an MT2060 which is the tuner, I think, as I see that there's an 'mt2060'
> module in the tuner module directory. Is there some modification I can do to
> the code so that it gets picked up by the driver? - I know a bit of C++ app
> programming but I'm very new to C driver code, but would like to learn more.
> Hopefully I can help some others who have this chipset as well.....
>
------x--------

I've had a look at the code & have been attempting to add new code to the
M920x driver to cope with the mt2060 tuner module, although all I've got to
go on is the existing code for the qt1010 tuner. I'm not sure of 1 or 2
magic numbers like the i2c address & so on, and my C abilities are fairly
limited, so I haven't managed to compile my new code without errors yet. I
could do with some help ( or even a patch) to be honest
regards andrew

------=_Part_1445_3334227.1213816587274
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/6/12 Andrew Websdale <br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br><br><div class="gmail_quote"><div class="Ih2E3d">
2008/6/12 Antti Palosaari &lt;<a href="mailto:crope@iki.fi" target="_blank">crope@iki.fi</a>&gt;:</div><div class="Ih2E3d"><div><div></div><div>
wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
OK, then the reason might by tuner. Tuner may be changed to other one or tuner i2c-address is changed. I doubt whole tuner is changed. Now we should identify which tuner is used. There is some ways how to do that.<br>
<br>
1) Look from Windows driver files<br>
2) Open stick and look chips<br>
3) Take USB-sniffs and try to identify tuner from there</blockquote></div></div></div></div></blockquote><div><br>I&#39;ve opened the stick &amp; there&#39;s an MT352 (as expected) but the other chip is an MT2060 which is the tuner, I think, as I see that there&#39;s an &#39;mt2060&#39; module in the tuner module directory. Is there some modification I can do to the code so that it gets picked up by the driver? - I know a bit of C++ app programming but I&#39;m very new to C driver code, but would like to learn more. Hopefully I can help some others who have this chipset as well.....<br>

</div></div></blockquote><div>------x--------<br><br>I&#39;ve had a look at the code &amp; have been attempting to add new code to the M920x driver to cope with the mt2060 tuner module, although all I&#39;ve got to go on is the existing code for the qt1010 tuner. I&#39;m not sure of 1 or 2 magic numbers like the i2c address &amp; so on, and my C abilities are fairly limited, so I haven&#39;t managed to compile my new code without errors yet. I could do with some help ( or even a patch) to be honest<br>
regards andrew<br><br>&nbsp;</div></div><br>

------=_Part_1445_3334227.1213816587274--


--===============1552189770==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1552189770==--
