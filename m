Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alihmh@gmail.com>) id 1JbsVN-0002lt-Ft
	for linux-dvb@linuxtv.org; Wed, 19 Mar 2008 08:14:35 +0100
Received: by wf-out-1314.google.com with SMTP id 28so274429wfa.17
	for <linux-dvb@linuxtv.org>; Wed, 19 Mar 2008 00:14:28 -0700 (PDT)
Message-ID: <66caf1560803190014l30f87d33hbd34dc873707d3a0@mail.gmail.com>
Date: Wed, 19 Mar 2008 10:44:28 +0330
From: "Ali H.M. Hoseini" <alihmh@gmail.com>
To: "john bolan" <bolanster@gmail.com>, linux-dvb@linuxtv.org,
	"Patrick Boettcher" <patrick.boettcher@desy.de>
In-Reply-To: <acd5e46b0803181425x48e2f8a4raab5e11b4b1a9186@mail.gmail.com>
MIME-Version: 1.0
References: <acd5e46b0803181425x48e2f8a4raab5e11b4b1a9186@mail.gmail.com>
Subject: Re: [linux-dvb] skystar2 rev 2.8a - no drivers for frontend found
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1986918606=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1986918606==
Content-Type: multipart/alternative;
	boundary="----=_Part_26934_18750104.1205910868392"

------=_Part_26934_18750104.1205910868392
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 3/19/08, john bolan <bolanster@gmail.com> wrote:
>
> Can anyone tell me if there is any possibility for a driver for the
> skystar2 rev 2.8a in the near future - I bought one of these cards only to
> find out there are no drivers for it (the joke is I bought the skystar
> card specifically bcs I'd read it worked well under linux, ha ha). From what
> I understand the manufacturers have not been forthcoming with
> the information required to develop the drivers since rev 2.6. I've
> emailed Technisat with a request but have thus far not recieved a response,
> and I'm just deciding on whether I need to buy a new card ... any info would
> be greatly appreciated!
>
>
> John Bolan
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

Hi,
I've the same problem. I asked Technisat and they said that the problem is
from Conexant, who manufactures SkyStar 2.8A front end chipset (cx24113 /
cx24123) . The Conexant has NDA (Non Disclosure Agreement) which prohibits
developing of open source drivers.

I asked Patrick Boettcher who is maintaing SkyStar drivers for linuxtv, and
he said it may be solved. You could also ask him yourself, and I think we
could force Conexant to give away about linux driver, by mailing them.

J. Jikman

------=_Part_26934_18750104.1205910868392
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br>
<div><span class="gmail_quote">On 3/19/08, <b class="gmail_sendername">john bolan</b> &lt;<a href="mailto:bolanster@gmail.com">bolanster@gmail.com</a>&gt; wrote:</span>
<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div>Can anyone tell me if there is any possibility for a driver for the skystar2 rev 2.8a&nbsp;in the near future - I bought one of these cards only to find out there are no drivers for it (the joke is I bought the skystar card&nbsp;specifically bcs I&#39;d read it worked well under linux, ha ha). From what I understand the manufacturers have not been forthcoming with the&nbsp;information required to develop the drivers since rev 2.6. I&#39;ve emailed Technisat with a request but have&nbsp;thus far not recieved a response, and I&#39;m just deciding on whether I need to buy a new card ... any info would be greatly appreciated!&nbsp;&nbsp;</div>

<div>&nbsp;</div><span class="sg">
<div>&nbsp;</div>
<div>John Bolan&nbsp;</div></span><br>_______________________________________________<br>linux-dvb mailing list<br><a onclick="return top.js.OpenExtLink(window,event,this)" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a onclick="return top.js.OpenExtLink(window,event,this)" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></blockquote></div>

<div>&nbsp;</div>
<div>Hi,</div>
<div>I&#39;ve the same problem. I asked Technisat and they said that the problem is from Conexant, who manufactures SkyStar 2.8A front end chipset (cx24113 / cx24123) . The Conexant has NDA (Non Disclosure Agreement) which prohibits developing of open source drivers. </div>

<div>&nbsp;</div>
<div>I asked Patrick Boettcher who is maintaing SkyStar drivers for linuxtv, and he said it may be solved. You could also ask him yourself, and I think we could force Conexant to give away about linux driver, by mailing them.</div>

<div>&nbsp;</div>
<div>J. Jikman<br>&nbsp;</div>

------=_Part_26934_18750104.1205910868392--


--===============1986918606==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1986918606==--
