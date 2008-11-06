Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oobe.trouble@gmail.com>) id 1Kxy79-00073r-3P
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 07:13:08 +0100
Received: by fk-out-0910.google.com with SMTP id f40so517551fka.1
	for <linux-dvb@linuxtv.org>; Wed, 05 Nov 2008 22:13:03 -0800 (PST)
Message-ID: <21aab41d0811052213h9b51f51g3ad8cfc766423ffe@mail.gmail.com>
Date: Thu, 6 Nov 2008 17:13:03 +1100
From: "Kemble Wagner" <oobe.trouble@gmail.com>
To: "Alex Ferrara" <alex@receptiveit.com.au>
In-Reply-To: <8A7DC3C9-BE07-4E5D-9069-C409F990853A@receptiveit.com.au>
MIME-Version: 1.0
References: <00023E2CD2444D05AFE501BA0439DCCF@marklaptop>
	<12A846AD-5D7A-4021-BE5B-063A7AEB70E9@receptiveit.com.au>
	<452AD5616A1D4A2EB6BB6329DEF41E58@marklaptop>
	<8A7DC3C9-BE07-4E5D-9069-C409F990853A@receptiveit.com.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dvico Dual Digital 4 rev 2 broken in October?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1563029028=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1563029028==
Content-Type: multipart/alternative;
	boundary="----=_Part_16774_33293610.1225951983550"

------=_Part_16774_33293610.1225951983550
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

rev 2 should not need firmware at all

2008/10/22 Alex Ferrara <alex@receptiveit.com.au>

> On 22/10/2008, at 9:43 PM, Mark Callaghan wrote:
>
> Thanks Alex. I deleted one of the firmware files (Chris's) and my rev2 is
> good now. (I had a few fw files in place.)
>
> But I have been having other problems - only one of the two tuners would
> work, the other reporting "partial lock". Various searches and much digging
> turned up a suggestion to disable EIT scanning. I disabled the EIT scan in
> the backend setup (video sources, I think?). But this had no effect. I then
> went into the database with phpmyadmin, and disabled dvb_eitscan in the
> capturecard table. And now I get both tuners.
>
> So there is something strange happening, but I'm happy.
>
> Cheers,
> Mark
>
>
>
> I'm not sure if I mentioned it, but I am running kernel 2.6.27 from Ubuntu
> Intrepid
> Good to see that you are having some joy.
>
> Regards
> Alex Ferrara
>
> Director
> Receptive IT Solutions
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_16774_33293610.1225951983550
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

rev 2 should not need firmware at all <br><br><div class="gmail_quote">2008/10/22 Alex Ferrara <span dir="ltr">&lt;<a href="mailto:alex@receptiveit.com.au">alex@receptiveit.com.au</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div style=""><div><div><div></div><div class="Wj3C7c"><div><div>On 22/10/2008, at 9:43 PM, Mark Callaghan wrote:</div><br><blockquote type="cite"><span style="border-collapse: separate; color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px;"><div bgcolor="#ffffff" style="">
<div><font face="Arial" size="2">Thanks Alex. I deleted one of the firmware files (Chris&#39;s) and my rev2 is good now. (I had a few fw files in place.)</font></div><div><font face="Arial" size="2"></font>&nbsp;</div><div><font face="Arial" size="2">But I have been having other problems - only one of the two tuners would work, the other reporting &quot;partial lock&quot;. Various searches and much digging turned up a suggestion to disable EIT scanning. I disabled the EIT scan in the backend setup (video sources, I think?). But this had no effect. I then went into the database with phpmyadmin, and disabled dvb_eitscan in the capturecard table. And now I get both tuners.</font></div>
<div><font face="Arial" size="2"></font>&nbsp;</div><div><font face="Arial" size="2">So there is something strange happening, but I&#39;m happy.</font></div><div><font face="Arial" size="2"></font>&nbsp;</div><div><font face="Arial" size="2">Cheers,</font></div>
<div><font face="Arial" size="2">Mark</font></div><div><font face="Arial" size="2"></font>&nbsp;</div></div></span></blockquote></div><div><br></div></div></div>I&#39;m not sure if I mentioned it, but I am running kernel 2.6.27 from Ubuntu Intrepid<div>
<br></div><div>Good to see that you are having some joy.</div><div class="Ih2E3d"><div><br></div><div>Regards</div><div><span style="border-collapse: separate; color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px;"><div style="">
<div>Alex Ferrara</div><div><br></div><div>Director</div><div>Receptive IT Solutions</div></div></span> </div><br></div></div></div><br>_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></blockquote></div><br>

------=_Part_16774_33293610.1225951983550--


--===============1563029028==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1563029028==--
