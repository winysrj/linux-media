Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <henrik.list@gmail.com>) id 1JZWor-0005kG-AT
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 20:40:57 +0100
Received: by gv-out-0910.google.com with SMTP id o2so813400gve.16
	for <linux-dvb@linuxtv.org>; Wed, 12 Mar 2008 12:40:52 -0700 (PDT)
Message-ID: <af2e95fa0803121240u20e210a8p26c84a968cd2c9e7@mail.gmail.com>
Date: Wed, 12 Mar 2008 20:40:49 +0100
From: "Henrik Beckman" <henrik.list@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <20080311110707.GA15085@mythbackend.home.ivor.org>
MIME-Version: 1.0
References: <20080311110707.GA15085@mythbackend.home.ivor.org>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1572056420=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1572056420==
Content-Type: multipart/alternative;
	boundary="----=_Part_6518_27642915.1205350850230"

------=_Part_6518_27642915.1205350850230
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2.6.22-14 with patches,  stable for me.

/Henrik


On Tue, Mar 11, 2008 at 12:07 PM, <ivor@ivor.org> wrote:

> Not sure if this helps or adds that much to the discussion... (I think
> this was concluded before)
> But I finally switched back to kernel 2.6.22.19 on March 5th (with current
> v4l-dvb code) and haven't had any problems with the Nova-t 500 since.
> Running mythtv with EIT scanning enabled.
>
> Looking in the kernel log I see a single mt2060 read failed message on
> March 6th and 9th and a single mt2060 write failed on March 8th. These
> events didn't cause any problems or cause the tuner or mythtv to fail
> though.
>
> Ivor.
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_6518_27642915.1205350850230
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2.6.22-14 with patches,&nbsp; stable for me.<br><br>/Henrik<br><br><br><div class="gmail_quote">On Tue, Mar 11, 2008 at 12:07 PM,  &lt;<a href="mailto:ivor@ivor.org">ivor@ivor.org</a>&gt; wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Not sure if this helps or adds that much to the discussion... (I think this was concluded before)<br>
But I finally switched back to kernel <a href="http://2.6.22.19" target="_blank">2.6.22.19</a> on March 5th (with current v4l-dvb code) and haven&#39;t had any problems with the Nova-t 500 since. Running mythtv with EIT scanning enabled.<br>

<br>
Looking in the kernel log I see a single mt2060 read failed message on March 6th and 9th and a single mt2060 write failed on March 8th. These events didn&#39;t cause any problems or cause the tuner or mythtv to fail though.<br>

<br>
Ivor.<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br>

------=_Part_6518_27642915.1205350850230--


--===============1572056420==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1572056420==--
