Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.239])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mattvermeulen@gmail.com>) id 1JRy3N-0006ZY-HM
	for linux-dvb@linuxtv.org; Thu, 21 Feb 2008 00:08:41 +0100
Received: by wx-out-0506.google.com with SMTP id s11so2318564wxc.17
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 15:08:35 -0800 (PST)
Message-ID: <950c7d180802201508l70bcdb19pb92e8a4846df96d@mail.gmail.com>
Date: Thu, 21 Feb 2008 08:08:34 +0900
From: "Matthew Vermeulen" <mattvermeulen@gmail.com>
To: "Filippo Argiolas" <filippo.argiolas@gmail.com>
In-Reply-To: <950c7d180802201457m34994e4bi621726a7697ab8a9@mail.gmail.com>
MIME-Version: 1.0
References: <1203434275.6870.25.camel@tux> <1203449457.28796.7.camel@youkaida>
	<950c7d180802191310x5882541h61bc60195a998da4@mail.gmail.com>
	<1203495773.7026.15.camel@tux> <1203496068.7026.19.camel@tux>
	<950c7d180802200436s68bab78ej3eb01a93090c313f@mail.gmail.com>
	<1203513814.6682.30.camel@acropora>
	<950c7d180802200543w31d157eag6e3d8277d60fa412@mail.gmail.com>
	<1203516921.6602.11.camel@tux>
	<950c7d180802201457m34994e4bi621726a7697ab8a9@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700 ir
	receiver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0084318908=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0084318908==
Content-Type: multipart/alternative;
	boundary="----=_Part_585_11636891.1203548914529"

------=_Part_585_11636891.1203548914529
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Feb 21, 2008 at 7:57 AM, Matthew Vermeulen <mattvermeulen@gmail.com>
wrote:

>
>
> On Wed, Feb 20, 2008 at 11:15 PM, Filippo Argiolas <
> filippo.argiolas@gmail.com> wrote:
>
> > Il giorno mer, 20/02/2008 alle 22.43 +0900, Matthew Vermeulen ha
> > scritto:
> > > Feb 20 22:39:53 matthew-desktop kernel: [39334.832815] dib0700:
> > > Unknown remote controller key: 13 7E  1  0
> > > Feb 20 22:39:53 matthew-desktop kernel: [39334.908277] dib0700:
> > > Unknown remote controller key: 13 7E  1  0
> > > Feb 20 22:39:53 matthew-desktop kernel: [39335.060139] dib0700:
> > > Unknown remote controller key: 13 7E  1  0
> > > Feb 20 22:39:53 matthew-desktop kernel: [39335.136473] dib0700:
> > > Unknown remote controller key: 13 7E  1  0
> > > Feb 20 22:39:53 matthew-desktop kernel: [39335.211810] dib0700:
> > > Unknown remote controller key: 13 7E  1  0
> > > Feb 20 22:39:54 matthew-desktop kernel: [39335.364108] dib0700:
> > > Unknown remote controller key: 13 7E  1  0
> > >
> > > Not sure if that's what we were hoping for...
> >
> > It seems that your remote does not use the toggle bit. I don't know why
> > since afaik it is a feature of the rc5 protocol.
> > By the way you can try to make some test writing the keymap on your own.
> > Just edit dib0700_devices.c about at line 400, look at the other keymaps
> > to have a model:
> > for example if the key you logged was the UP key you have to add a line
> > like:
> > { 0x13, 0x7E, KEY_UP },
> > and so on for the other keys, after that see if the keymap works with
> > evtest.
> >
> >
> >
> Ok thanks I'll give that a shot and see what happens :)
>
> Thanks a lot
>
> Cheers,
>
> Matt
>
>
> --
> Matthew Vermeulen
> http://www.matthewv.id.au/
> MatthewV @ irc.freenode.net
>

Ok I just tried this with a few keys - and I know have volume control
working on the remote... :D :D

Thanks so much... will let you know how the rest of it turns out!

Cheers,

Matt
-- 
Matthew Vermeulen
http://www.matthewv.id.au/
MatthewV @ irc.freenode.net

------=_Part_585_11636891.1203548914529
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Feb 21, 2008 at 7:57 AM, Matthew Vermeulen &lt;<a href="mailto:mattvermeulen@gmail.com">mattvermeulen@gmail.com</a>&gt; wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div><div></div><div class="Wj3C7c"><br><br><div class="gmail_quote">On Wed, Feb 20, 2008 at 11:15 PM, Filippo Argiolas &lt;<a href="mailto:filippo.argiolas@gmail.com" target="_blank">filippo.argiolas@gmail.com</a>&gt; wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Il giorno mer, 20/02/2008 alle 22.43 +0900, Matthew Vermeulen ha<br>
scritto:<br>
<div>&gt; Feb 20 22:39:53 matthew-desktop kernel: [39334.832815] dib0700:<br>
&gt; Unknown remote controller key: 13 7E &nbsp;1 &nbsp;0<br>
&gt; Feb 20 22:39:53 matthew-desktop kernel: [39334.908277] dib0700:<br>
&gt; Unknown remote controller key: 13 7E &nbsp;1 &nbsp;0<br>
&gt; Feb 20 22:39:53 matthew-desktop kernel: [39335.060139] dib0700:<br>
&gt; Unknown remote controller key: 13 7E &nbsp;1 &nbsp;0<br>
&gt; Feb 20 22:39:53 matthew-desktop kernel: [39335.136473] dib0700:<br>
&gt; Unknown remote controller key: 13 7E &nbsp;1 &nbsp;0<br>
&gt; Feb 20 22:39:53 matthew-desktop kernel: [39335.211810] dib0700:<br>
&gt; Unknown remote controller key: 13 7E &nbsp;1 &nbsp;0<br>
&gt; Feb 20 22:39:54 matthew-desktop kernel: [39335.364108] dib0700:<br>
&gt; Unknown remote controller key: 13 7E &nbsp;1 &nbsp;0<br>
&gt;<br>
&gt; Not sure if that&#39;s what we were hoping for...<br>
<br>
</div>It seems that your remote does not use the toggle bit. I don&#39;t know why<br>
since afaik it is a feature of the rc5 protocol.<br>
By the way you can try to make some test writing the keymap on your own.<br>
Just edit dib0700_devices.c about at line 400, look at the other keymaps<br>
to have a model:<br>
for example if the key you logged was the UP key you have to add a line<br>
like:<br>
{ 0x13, 0x7E, KEY_UP },<br>
and so on for the other keys, after that see if the keymap works with<br>
evtest.<br>
<br>
<br>
</blockquote></div><br></div></div>Ok thanks I&#39;ll give that a shot and see what happens :)<br><br>Thanks a lot<br><br>Cheers,<br><br>Matt<div><div></div><div class="Wj3C7c"><br clear="all"><br>-- <br>Matthew Vermeulen<br>
<a href="http://www.matthewv.id.au/" target="_blank">http://www.matthewv.id.au/</a><br>
MatthewV @ <a href="http://irc.freenode.net" target="_blank">irc.freenode.net</a>
</div></div></blockquote></div><br>Ok I just tried this with a few keys - and I know have volume control working on the remote... :D :D<br><br>Thanks so much... will let you know how the rest of it turns out!<br><br>Cheers,<br>
<br>Matt<br>-- <br>Matthew Vermeulen<br><a href="http://www.matthewv.id.au/">http://www.matthewv.id.au/</a><br>MatthewV @ <a href="http://irc.freenode.net">irc.freenode.net</a>

------=_Part_585_11636891.1203548914529--


--===============0084318908==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0084318908==--
