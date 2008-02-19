Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.224])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JRVPk-0001LS-CK
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 17:33:52 +0100
Received: by wx-out-0506.google.com with SMTP id s11so1772511wxc.17
	for <linux-dvb@linuxtv.org>; Tue, 19 Feb 2008 08:33:47 -0800 (PST)
Message-ID: <617be8890802190833h23efc669m458076b40efbac08@mail.gmail.com>
Date: Tue, 19 Feb 2008 17:33:46 +0100
From: "Eduard Huguet" <eduardhc@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700 ir
	receiver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1581132987=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1581132987==
Content-Type: multipart/alternative;
	boundary="----=_Part_8185_26342429.1203438826429"

------=_Part_8185_26342429.1203438826429
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

>
> ---------- Missatge reenviat ----------
> From: Filippo Argiolas <filippo.argiolas@gmail.com>
> To: linux-dvb@linuxtv.org
> Date: Tue, 19 Feb 2008 16:17:55 +0100
> Subject: [linux-dvb] [patch] support for key repeat with dib0700 ir
> receiver
> Hi, my last messages have been almost ignored.. so I'm opening a new
> thread. Please refer to the other thread [wintv nova-t stick, dib0700
> and remote controllers] for more info.
>
> Here is a brief summary of the problem as far as I can understand:
> - when a keypress event is received the device stores its data somewhere
> - every 150ms dib0700_rc_query reads this data
> - since there is nothing that resets device memory if no key is being
> pressed anymore device still stores the data from the last keypress
> event
> - to prevent having false keypresses the driver reads rc5 toggle bit
> that changes from 0 to 1 and viceversa when a new key is pressed or when
> the same key is released and pressed again. So it ignores everything
> until the toggle bit changes. The right behavior should be "repeat last
> key until toggle bit changes", but cannot be done since last data still
> stored would be considered as a repeat even if nothing is pressed.
> - this way it ignores even repeated key events (when a key is holded
> down)
> - this approach is wrong because it works just for rc5 (losing repeat
> feature..) but doesn't work for example with nec remotes that don't set
> the toggle bit and use a different system.
>
> The patch solves it calling dib0700_rc_setup after each poll resetting
> last key data from the device. I've also implemented repeated key
> feature (with repeat delay to avoid unwanted double hits) for rc-5 and
> nec protocols. It also contains some keymap for the remotes I've used
> for testing (a philipps compatible rc5 remote and a teac nec remote).
> They are far from being complete since I've used them just for testing.
>
> Thanks for reading this,
> Let me know what do you think about it,
> Greets,
>
> Filippo
>



Hi,
    Thanks for your efforts. =BFDo you think this patch will also be useful=
 to
the unknown keycodes problem of the Nova-T 500 remote?

If you don't know what I'm talking about here you have a brief description:
whenever the Nova-T 500 receiver detects "invalid" or "unknown" IR codes (
i.e. when you operate the TV remote, etc...) it keeps logging warning
messages to kernel ring buffer until a "valid" code is received.

There is a very simple patch in the wiki for this, but it doesn't cure the
problem, just the symptons. I was wondering if your patch is a better way t=
o
solve it...

Regards,
  Eduard

------=_Part_8185_26342429.1203438826429
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(=
204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">---------- M=
issatge reenviat ----------<br>From: Filippo Argiolas &lt;<a href=3D"mailto=
:filippo.argiolas@gmail.com">filippo.argiolas@gmail.com</a>&gt;<br>
To: <a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>D=
ate: Tue, 19 Feb 2008 16:17:55 +0100<br>Subject: [linux-dvb] [patch] suppor=
t for key repeat with dib0700 ir receiver<br>Hi, my last messages have been=
 almost ignored.. so I&#39;m opening a new<br>
thread. Please refer to the other thread [wintv nova-t stick, dib0700<br>an=
d remote controllers] for more info.<br><br>Here is a brief summary of the =
problem as far as I can understand:<br>- when a keypress event is received =
the device stores its data somewhere<br>
- every 150ms dib0700_rc_query reads this data<br>- since there is nothing =
that resets device memory if no key is being<br>pressed anymore device stil=
l stores the data from the last keypress<br>event<br>- to prevent having fa=
lse keypresses the driver reads rc5 toggle bit<br>
that changes from 0 to 1 and viceversa when a new key is pressed or when<br=
>the same key is released and pressed again. So it ignores everything<br>un=
til the toggle bit changes. The right behavior should be &quot;repeat last<=
br>
key until toggle bit changes&quot;, but cannot be done since last data stil=
l<br>stored would be considered as a repeat even if nothing is pressed.<br>=
- this way it ignores even repeated key events (when a key is holded<br>
down)<br>- this approach is wrong because it works just for rc5 (losing rep=
eat<br>feature..) but doesn&#39;t work for example with nec remotes that do=
n&#39;t set<br>the toggle bit and use a different system.<br><br>The patch =
solves it calling dib0700_rc_setup after each poll resetting<br>
last key data from the device. I&#39;ve also implemented repeated key<br>fe=
ature (with repeat delay to avoid unwanted double hits) for rc-5 and<br>nec=
 protocols. It also contains some keymap for the remotes I&#39;ve used<br>
for testing (a philipps compatible rc5 remote and a teac nec remote).<br>Th=
ey are far from being complete since I&#39;ve used them just for testing.<b=
r><br>Thanks for reading this,<br>Let me know what do you think about it,<b=
r>
Greets,<br><br>Filippo<br></blockquote></div><br><br><br>Hi, <br>&nbsp;&nbs=
p;&nbsp; Thanks for your efforts. =BFDo you think this patch will also be u=
seful to the unknown keycodes problem of the Nova-T 500 remote?<br><br>If y=
ou don&#39;t know what I&#39;m talking about here you have a brief descript=
ion: whenever the Nova-T 500 receiver detects &quot;invalid&quot; or &quot;=
unknown&quot; IR codes (i.e. when you operate the TV remote, etc...) it kee=
ps logging warning messages to kernel ring buffer until a &quot;valid&quot;=
 code is received.<br>
<br>There is a very simple patch in the wiki for this, but it doesn&#39;t c=
ure the problem, just the symptons. I was wondering if your patch is a bett=
er way to solve it...<br><br>Regards, <br>&nbsp; Eduard<br><br><br><br>

------=_Part_8185_26342429.1203438826429--


--===============1581132987==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1581132987==--
