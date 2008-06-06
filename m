Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <seb.linuxtv@googlemail.com>) id 1K4YOP-0000uh-QR
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 11:37:54 +0200
Received: by ug-out-1314.google.com with SMTP id m3so718285uge.20
	for <linux-dvb@linuxtv.org>; Fri, 06 Jun 2008 02:37:46 -0700 (PDT)
Message-ID: <7296686b0806060237s61c55d1cw8e47566e5a871648@mail.gmail.com>
Date: Fri, 6 Jun 2008 11:37:46 +0200
From: "Sebastian B" <seb.linuxtv@googlemail.com>
To: "Roland Scheidegger" <rscheidegger_lists@hispeed.ch>
In-Reply-To: <4847F39E.3030600@hispeed.ch>
MIME-Version: 1.0
References: <7296686b0806050634k515ee421n8f483b60aa8ce58f@mail.gmail.com>
	<4847F39E.3030600@hispeed.ch>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Mantis VP-2040 (Terratec Cinergy C PCI) Remote
	Control Support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0922212925=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0922212925==
Content-Type: multipart/alternative;
	boundary="----=_Part_2357_18848217.1212745066391"

------=_Part_2357_18848217.1212745066391
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

Guess, I didn't search hard enough for a solution ;-)

Regarding the memory corruption:

I don't know what's causing that problem.

If I check for the IR value only one time, I sometimes receive the value
0x00 and 0x80 which is obviously invalid.

So the only way I know of is to check for the IR value several times to get
the right one.

Does somebody know what's happening there?

Best Regards

Sebastian

On Thu, Jun 5, 2008 at 4:09 PM, Roland Scheidegger
<rscheidegger_lists@hispeed.ch> wrote:

> On 05.06.2008 15:34, Sebastian B wrote:
> >
> > Hello,
> >
> > I'm quite new to this mailing list. So maybe somebody posted something
> > similar but I haven't found it here.
> You are indeed late to the party :-)
> http://www.linuxtv.org/pipermail/linux-dvb/2008-May/026102.html
>
> >
> > It's not perfect yet, but it's working without any problems on my system.
> I wonder what's up with the memory corruption you mentioned, I didn't
> see anything like that.
>
>
> > Maybe Manu can add remote control support in future releases?
> I agree this would be really great so people don't come up with
> basically the same patches over and over again :-).
>
> Roland
>

------=_Part_2357_18848217.1212745066391
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,<br><br>Guess, I didn&#39;t search hard enough for a solution ;-)<br><br>Regarding the memory corruption:<br><br>I don&#39;t know what&#39;s causing that problem.<br><br>If I check for the IR value only one time, I sometimes receive the value 0x00 and 0x80 which is obviously invalid.<br>
<br>So the only way I know of is to check for the IR value several times to get the right one.<br><br>Does somebody know what&#39;s happening there?<br><br>Best Regards<br><br>Sebastian<br><br><div class="gmail_quote">On Thu, Jun 5, 2008 at 4:09 PM, Roland Scheidegger &lt;rscheidegger_lists@hispeed.ch&gt; wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class="Ih2E3d">On 05.06.2008 15:34, Sebastian B wrote:<br>
&gt;<br>
&gt; Hello,<br>
&gt;<br>
&gt; I&#39;m quite new to this mailing list. So maybe somebody posted something<br>
&gt; similar but I haven&#39;t found it here.<br>
</div>You are indeed late to the party :-)<br>
<a href="http://www.linuxtv.org/pipermail/linux-dvb/2008-May/026102.html" target="_blank">http://www.linuxtv.org/pipermail/linux-dvb/2008-May/026102.html</a><br>
<div class="Ih2E3d"><br>
&gt;<br>
&gt; It&#39;s not perfect yet, but it&#39;s working without any problems on my system.<br>
</div>I wonder what&#39;s up with the memory corruption you mentioned, I didn&#39;t<br>
see anything like that.<br>
<div class="Ih2E3d"><br>
<br>
&gt; Maybe Manu can add remote control support in future releases?<br>
</div>I agree this would be really great so people don&#39;t come up with<br>
basically the same patches over and over again :-).<br>
<font color="#888888"><br>
Roland<br>
</font></blockquote></div><br>

------=_Part_2357_18848217.1212745066391--


--===============0922212925==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0922212925==--
