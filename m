Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f20.google.com ([209.85.217.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <orbus42@gmail.com>) id 1KTTh1-0003yx-7N
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 05:40:08 +0200
Received: by gxk13 with SMTP id 13so2694945gxk.17
	for <linux-dvb@linuxtv.org>; Wed, 13 Aug 2008 20:39:33 -0700 (PDT)
Message-ID: <8fcafd2c0808132039h4d0ada9xef21a8502e495b9d@mail.gmail.com>
Date: Wed, 13 Aug 2008 22:39:32 -0500
From: "James Lucas" <orbus42@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <8fcafd2c0808131840u4fe27c7dq84953bd34d24e0b1@mail.gmail.com>
MIME-Version: 1.0
References: <8fcafd2c0808131723l21031daej9e9ae3eeabfa57f7@mail.gmail.com>
	<48A37D44.7090808@linuxtv.org>
	<8fcafd2c0808131806l1fcc7563v121715d937d39a5d@mail.gmail.com>
	<8fcafd2c0808131840u4fe27c7dq84953bd34d24e0b1@mail.gmail.com>
Subject: Re: [linux-dvb] Digital tuning failing on Pinnacle 800i with dmesg
	output
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0720286332=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0720286332==
Content-Type: multipart/alternative;
	boundary="----=_Part_97075_16874850.1218685172999"

------=_Part_97075_16874850.1218685172999
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Aug 13, 2008 at 8:40 PM, James Lucas <orbus42@gmail.com> wrote:

> Anyway, update.  Installed in the windows machine, and got the drivers
> installed successfully, but the player software that comes with the card
> requires windows xp, and the newest version of windows I have is 2000.  I
> know analog capture is pretty well supported in windows by things like
> virtualdub and media player classic, but do you know of any apps I can use
> to test the HD functionality?
>
> While I had the card out, got the following from visual inspection:
>
> Printed on the PCB:
> pctv 800i rev 1.1
>
> There were two large visible chips on the card:
> Samsung C649 S5H1409X01-T0  N079X
>
> Conexant Broadcast Decoder  CX23883-39  72013496  0729 Korea
>
> I imagine the tuner chip is hidden under the metal box (shielding?).
>
> James
>


Another update - I spoke too soon.  One of the windows drivers is refusing
to load properly.  I don't know if the signifies a bad card or just that the
driver doesn't work on anything less than xp.  I don't have any way to test
at the moment.  I'm happy to try anything you want in the way of diagnosis
under linux though.

James

------=_Part_97075_16874850.1218685172999
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">On Wed, Aug 13, 2008 at 8:40 PM, James Lucas <span dir="ltr">&lt;<a href="mailto:orbus42@gmail.com">orbus42@gmail.com</a>&gt;</span> wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div dir="ltr">Anyway, update.&nbsp; Installed in the windows machine, and got the drivers installed successfully, but the player software that comes with the card requires windows xp, and the newest version of windows I have is 2000.&nbsp; I know analog capture is pretty well supported in windows by things like virtualdub and media player classic, but do you know of any apps I can use to test the HD functionality?<br>

<br>While I had the card out, got the following from visual inspection:<br><br>Printed on the PCB:<br>pctv 800i rev 1.1<br><br>There were two large visible chips on the card:<br>Samsung C649 S5H1409X01-T0&nbsp; N079X<br><br>Conexant Broadcast Decoder&nbsp; CX23883-39&nbsp; 72013496&nbsp; 0729 Korea<br>

<br>I imagine the tuner chip is hidden under the metal box (shielding?).<br><br>James<br></div>
</blockquote></div><br><br>Another update - I spoke too soon.&nbsp; One of the windows drivers is refusing to load properly.&nbsp; I don&#39;t know if the signifies a bad card or just that the driver doesn&#39;t work on anything less than xp.&nbsp; I don&#39;t have any way to test at the moment.&nbsp; I&#39;m happy to try anything you want in the way of diagnosis under linux though.<br>
<br>James<br></div>

------=_Part_97075_16874850.1218685172999--


--===============0720286332==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0720286332==--
