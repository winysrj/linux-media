Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.249])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <brandon.rader@gmail.com>) id 1JZeHE-0003Ss-CN
	for linux-dvb@linuxtv.org; Thu, 13 Mar 2008 04:38:45 +0100
Received: by an-out-0708.google.com with SMTP id d18so1122854and.125
	for <linux-dvb@linuxtv.org>; Wed, 12 Mar 2008 20:38:39 -0700 (PDT)
Message-ID: <331d2cab0803122038y58871667r851c306bdeb721d5@mail.gmail.com>
Date: Wed, 12 Mar 2008 22:38:38 -0500
From: "Brandon Rader" <brandon.rader@gmail.com>
To: "Chaogui Zhang" <czhang1974@gmail.com>
In-Reply-To: <bd41c5f0803110611o6990350es494c152be56020f4@mail.gmail.com>
MIME-Version: 1.0
References: <331d2cab0803062218x663ad17ofb79928059a111b@mail.gmail.com>
	<bd41c5f0803081850o3b818d0ar633fbf0b50bc5535@mail.gmail.com>
	<!&!AAAAAAAAAAAYAAAAAAAAACQaAAE2cqNLuI5vSe3nryTCgAAAEAAAAHFaDeWDc9dOji7t+LhHe7YBAAAAAA==@sbg0.com>
	<bd41c5f0803091305n1332ea0ai1acf5ffc07d0bd8d@mail.gmail.com>
	<331d2cab0803102036i66455f79h1cf20ca7a0d5e22f@mail.gmail.com>
	<bd41c5f0803110611o6990350es494c152be56020f4@mail.gmail.com>
Cc: video4linux-list <video4linux-list@redhat.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Trying to setup PCTV HD Card 800i
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0466924274=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0466924274==
Content-Type: multipart/alternative;
	boundary="----=_Part_15925_27983215.1205379518829"

------=_Part_15925_27983215.1205379518829
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Alright, here is the new dmesg output http://pastebin.com/m35d1137d.

Brandon

On Tue, Mar 11, 2008 at 8:11 AM, Chaogui Zhang <czhang1974@gmail.com> wrote:

> On Tue, Mar 11, 2008 at 3:36 AM, Brandon Rader <brandon.rader@gmail.com>
> wrote:
> > I tried the different repo that you suggested, and get the same error.
>  Here
> > is my new dmesg output http://pastebin.com/m4d43d4ef
> >
> > Brandon
> >
> >
>
> Please do not drop the list from the cc. Use the "reply to all"
> function of your email client instead of just "reply".
>
> It seems the i2c bus is not working the way it should. Can you try the
> following? (With the current v4l-dvb tree)
>
> First, unload all the modules related to your card (cx88-*, s5h1409,
> xc5000).
> Then, load cx88xx with options i2c_debug=1 and i2c_scan=1
> Post the relevant dmesg output to the list.
>
> --
> Chaogui Zhang
>

------=_Part_15925_27983215.1205379518829
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Alright, here is the new dmesg output <a href="http://pastebin.com/m35d1137d">http://pastebin.com/m35d1137d</a>.&nbsp; <br><br>Brandon<br><br><div class="gmail_quote">On Tue, Mar 11, 2008 at 8:11 AM, Chaogui Zhang &lt;<a href="mailto:czhang1974@gmail.com">czhang1974@gmail.com</a>&gt; wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class="Ih2E3d">On Tue, Mar 11, 2008 at 3:36 AM, Brandon Rader &lt;<a href="mailto:brandon.rader@gmail.com">brandon.rader@gmail.com</a>&gt; wrote:<br>

&gt; I tried the different repo that you suggested, and get the same error. &nbsp;Here<br>
&gt; is my new dmesg output <a href="http://pastebin.com/m4d43d4ef" target="_blank">http://pastebin.com/m4d43d4ef</a><br>
&gt;<br>
&gt; Brandon<br>
&gt;<br>
&gt;<br>
<br>
</div>Please do not drop the list from the cc. Use the &quot;reply to all&quot;<br>
function of your email client instead of just &quot;reply&quot;.<br>
<br>
It seems the i2c bus is not working the way it should. Can you try the<br>
following? (With the current v4l-dvb tree)<br>
<br>
First, unload all the modules related to your card (cx88-*, s5h1409, xc5000).<br>
Then, load cx88xx with options i2c_debug=1 and i2c_scan=1<br>
Post the relevant dmesg output to the list.<br>
<br>
--<br>
<font color="#888888">Chaogui Zhang<br>
</font></blockquote></div><br>

------=_Part_15925_27983215.1205379518829--


--===============0466924274==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0466924274==--
