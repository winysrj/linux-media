Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <henrik.list@gmail.com>) id 1JeaaM-0006cK-I5
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 19:42:58 +0100
Received: by gv-out-0910.google.com with SMTP id o2so856530gve.16
	for <linux-dvb@linuxtv.org>; Wed, 26 Mar 2008 11:42:50 -0700 (PDT)
Message-ID: <af2e95fa0803261142r33a0cdb1u31f9b8abc2193265@mail.gmail.com>
Date: Wed, 26 Mar 2008 19:42:49 +0100
From: "Henrik Beckman" <henrik.list@gmail.com>
To: "Nicolas Will" <nico@youplala.net>, linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1206546831.8967.13.camel@acropora>
MIME-Version: 1.0
References: <1206139910.12138.34.camel@youkaida> <1206185051.22131.5.camel@tux>
	<1206190455.6285.20.camel@youkaida> <1206270834.4521.11.camel@shuttle>
	<1206348478.6370.27.camel@youkaida>
	<1206546831.8967.13.camel@acropora>
Subject: Re: [linux-dvb] Now with debug info - Nova-T-500 disconnects - They
	are back!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1722680443=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1722680443==
Content-Type: multipart/alternative;
	boundary="----=_Part_1714_27141172.1206556969495"

------=_Part_1714_27141172.1206556969495
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I know how you feel.

I=B4ve been there but now my box is stable,
root@media:~# uname -a
Linux media 2.6.22-14-generic #1 SMP Tue Dec 18 08:02:57 UTC 2007 i686
GNU/Linux

My v4l-dvb is from 2008-01-28 and I have patched it with (or atleast the
patches in that dir are),
dib0700-start-streaming-fix.patch
dib300mc_tuning_fix.diff
MT1060_IF1_freq_set.diff
and a patch wich I think is for UHF.

Shall I gzip my source and give you a link?

/Henrik







On Wed, Mar 26, 2008 at 4:53 PM, Nicolas Will <nico@youplala.net> wrote:

> On Mon, 2008-03-24 at 08:47 +0000, Nicolas Will wrote:
> > Guys,
> >
> > I was running with the following debug options when I got a disconnect:
> >
> > options dvb-usb-dib0700 force_lna_activation=3D1
> > options dvb-usb-dib0700 debug=3D1
> > options mt2060 debug=3D1
> > options dibx000_common debug=3D1
> > options dvb_core debug=3D1
> > options dvb_core dvbdev_debug=3D1
> > options dvb_core frontend_debug=3D1
> > options dvb_usb debug=3D1
> > options dib3000mc debug=3D1
> > options usbcore autosuspend=3D-1
> >
> >
> > /var/log/messages is here:
> >
> > http://www.youplala.net/~will/htpc/disconnects/messages-with_debug<http=
://www.youplala.net/%7Ewill/htpc/disconnects/messages-with_debug>
> >
> > and slightly different data:
> >
> > http://www.youplala.net/~will/htpc/disconnects/syslog-with_debug<http:/=
/www.youplala.net/%7Ewill/htpc/disconnects/syslog-with_debug>
> >
> > Can that help, or would more be needed?
> >
> > There was zero remote usage at the time.
>
>
> This is really a cry for help.
>
> I am not a coder, I don't even know where my K&R C book that I bought 17
> years ago is anymore, so I cannot dive into the code and pretend to
> understand it.
>
> But I can push, pull, help coordinate, document, hg clone, compile,
> install, reboot, test, report, publish results on the wiki, and more if
> needed.
>
> That card was nearly working 100%, then something broke, and we are back
> to the status we had 1 year ago.
>
> Please, please, please...
>
> Nico
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_1714_27141172.1206556969495
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I know how you feel.<br><br>I=B4ve been there but now my box is stable, <br=
>root@media:~# uname -a<br>Linux media 2.6.22-14-generic #1 SMP Tue Dec 18 =
08:02:57 UTC 2007 i686 GNU/Linux<br><br>My v4l-dvb is from 2008-01-28 and I=
 have patched it with (or atleast the patches in that dir are),<br>
dib0700-start-streaming-fix.patch <br>dib300mc_tuning_fix.diff<br><font siz=
e=3D"2"></font>MT1060_IF1_freq_set.diff<br>and a patch wich I think is for =
UHF.<br><br>Shall I gzip my source and give you a link?<br><br>/Henrik<br>
<br><br><br><br><br><br><br><div class=3D"gmail_quote">On Wed, Mar 26, 2008=
 at 4:53 PM, Nicolas Will &lt;<a href=3D"mailto:nico@youplala.net">nico@you=
plala.net</a>&gt; wrote:<br><blockquote class=3D"gmail_quote" style=3D"bord=
er-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-l=
eft: 1ex;">
<div class=3D"Ih2E3d">On Mon, 2008-03-24 at 08:47 +0000, Nicolas Will wrote=
:<br>
&gt; Guys,<br>
&gt;<br>
&gt; I was running with the following debug options when I got a disconnect=
:<br>
&gt;<br>
&gt; options dvb-usb-dib0700 force_lna_activation=3D1<br>
&gt; options dvb-usb-dib0700 debug=3D1<br>
&gt; options mt2060 debug=3D1<br>
&gt; options dibx000_common debug=3D1<br>
&gt; options dvb_core debug=3D1<br>
&gt; options dvb_core dvbdev_debug=3D1<br>
&gt; options dvb_core frontend_debug=3D1<br>
&gt; options dvb_usb debug=3D1<br>
&gt; options dib3000mc debug=3D1<br>
&gt; options usbcore autosuspend=3D-1<br>
&gt;<br>
&gt;<br>
&gt; /var/log/messages is here:<br>
&gt;<br>
&gt; <a href=3D"http://www.youplala.net/%7Ewill/htpc/disconnects/messages-w=
ith_debug" target=3D"_blank">http://www.youplala.net/~will/htpc/disconnects=
/messages-with_debug</a><br>
&gt;<br>
&gt; and slightly different data:<br>
&gt;<br>
&gt; <a href=3D"http://www.youplala.net/%7Ewill/htpc/disconnects/syslog-wit=
h_debug" target=3D"_blank">http://www.youplala.net/~will/htpc/disconnects/s=
yslog-with_debug</a><br>
&gt;<br>
&gt; Can that help, or would more be needed?<br>
&gt;<br>
&gt; There was zero remote usage at the time.<br>
<br>
<br>
</div>This is really a cry for help.<br>
<br>
I am not a coder, I don&#39;t even know where my K&amp;R C book that I boug=
ht 17<br>
years ago is anymore, so I cannot dive into the code and pretend to<br>
understand it.<br>
<br>
But I can push, pull, help coordinate, document, hg clone, compile,<br>
install, reboot, test, report, publish results on the wiki, and more if<br>
needed.<br>
<br>
That card was nearly working 100%, then something broke, and we are back<br=
>
to the status we had 1 year ago.<br>
<br>
Please, please, please...<br>
<div><div></div><div class=3D"Wj3C7c"><br>
Nico<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br>
</div></div></blockquote></div><br>

------=_Part_1714_27141172.1206556969495--


--===============1722680443==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1722680443==--
