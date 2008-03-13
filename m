Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <henrik.list@gmail.com>) id 1JZnsP-0004zm-Dt
	for linux-dvb@linuxtv.org; Thu, 13 Mar 2008 14:53:48 +0100
Received: by ug-out-1314.google.com with SMTP id o29so467557ugd.20
	for <linux-dvb@linuxtv.org>; Thu, 13 Mar 2008 06:53:39 -0700 (PDT)
Message-ID: <af2e95fa0803130653i41cc79b2sa452e13f74939366@mail.gmail.com>
Date: Thu, 13 Mar 2008 14:53:38 +0100
From: "Henrik Beckman" <henrik.list@gmail.com>
To: "Patrik Hansson" <patrik@wintergatan.com>,
	linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <8ad9209c0803121248u24f0621es9877b3c827c4e932@mail.gmail.com>
MIME-Version: 1.0
References: <20080311110707.GA15085@mythbackend.home.ivor.org>
	<af2e95fa0803121240u20e210a8p26c84a968cd2c9e7@mail.gmail.com>
	<8ad9209c0803121248u24f0621es9877b3c827c4e932@mail.gmail.com>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0600953885=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0600953885==
Content-Type: multipart/alternative;
	boundary="----=_Part_9089_229483.1205416418173"

------=_Part_9089_229483.1205416418173
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Patched v4l-dvb to include the streaming and reception patches that was
included a while back. (I=B4ll check the date of my v4l-dvb tree).
I think I have LNA and maybe I disable the remote to, but i need to check
and get back about the modprob-d options.

/Henrik


On Wed, Mar 12, 2008 at 8:48 PM, Patrik Hansson <patrik@wintergatan.com>
wrote:

> 2008/3/12 Henrik Beckman <henrik.list@gmail.com>:
> > 2.6.22-14 with patches,  stable for me.
> >
> > /Henrik
> >
> >
> >
> >
> > On Tue, Mar 11, 2008 at 12:07 PM, <ivor@ivor.org> wrote:
> > > Not sure if this helps or adds that much to the discussion... (I thin=
k
> > this was concluded before)
> > > But I finally switched back to kernel 2.6.22.19 on March 5th (with
> current
> > v4l-dvb code) and haven't had any problems with the Nova-t 500 since.
> > Running mythtv with EIT scanning enabled.
> > >
> > > Looking in the kernel log I see a single mt2060 read failed message o=
n
> > March 6th and 9th and a single mt2060 write failed on March 8th. These
> > events didn't cause any problems or cause the tuner or mythtv to fail
> > though.
> > >
> > > Ivor.
> > >
> > >
> > > _______________________________________________
> > > linux-dvb mailing list
> > > linux-dvb@linuxtv.org
> > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > >
> >
> >
> > _______________________________________________
> >  linux-dvb mailing list
> >  linux-dvb@linuxtv.org
> >  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
>
> Henrik:
> What options (if any) are you using in modprobe.d ?
> Do you mean that you have patched the kernel or the v4l-dvb tree ?
>

------=_Part_9089_229483.1205416418173
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Patched v4l-dvb to include the streaming and reception patches that was inc=
luded a while back. (I=B4ll check the date of my v4l-dvb tree).<br>I think =
I have LNA and maybe I disable the remote to, but i need to check and get b=
ack about the modprob-d options.<br>
<br>/Henrik<br><br><br><div class=3D"gmail_quote">On Wed, Mar 12, 2008 at 8=
:48 PM, Patrik Hansson &lt;<a href=3D"mailto:patrik@wintergatan.com">patrik=
@wintergatan.com</a>&gt; wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; p=
adding-left: 1ex;">
2008/3/12 Henrik Beckman &lt;<a href=3D"mailto:henrik.list@gmail.com">henri=
k.list@gmail.com</a>&gt;:<br>
<div><div></div><div class=3D"Wj3C7c">&gt; 2.6.22-14 with patches, &nbsp;st=
able for me.<br>
&gt;<br>
&gt; /Henrik<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; On Tue, Mar 11, 2008 at 12:07 PM, &lt;<a href=3D"mailto:ivor@ivor.org"=
>ivor@ivor.org</a>&gt; wrote:<br>
&gt; &gt; Not sure if this helps or adds that much to the discussion... (I =
think<br>
&gt; this was concluded before)<br>
&gt; &gt; But I finally switched back to kernel <a href=3D"http://2.6.22.19=
" target=3D"_blank">2.6.22.19</a> on March 5th (with current<br>
&gt; v4l-dvb code) and haven&#39;t had any problems with the Nova-t 500 sin=
ce.<br>
&gt; Running mythtv with EIT scanning enabled.<br>
&gt; &gt;<br>
&gt; &gt; Looking in the kernel log I see a single mt2060 read failed messa=
ge on<br>
&gt; March 6th and 9th and a single mt2060 write failed on March 8th. These=
<br>
&gt; events didn&#39;t cause any problems or cause the tuner or mythtv to f=
ail<br>
&gt; though.<br>
&gt; &gt;<br>
&gt; &gt; Ivor.<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; _______________________________________________<br>
&gt; &gt; linux-dvb mailing list<br>
&gt; &gt; <a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a=
><br>
&gt; &gt; <a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-=
dvb" target=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linu=
x-dvb</a><br>
&gt; &gt;<br>
&gt;<br>
&gt;<br>
&gt; _______________________________________________<br>
&gt; &nbsp;linux-dvb mailing list<br>
&gt; &nbsp;<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</=
a><br>
&gt; &nbsp;<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux=
-dvb" target=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/lin=
ux-dvb</a><br>
&gt;<br>
<br>
</div></div>Henrik:<br>
What options (if any) are you using in modprobe.d ?<br>
Do you mean that you have patched the kernel or the v4l-dvb tree ?<br>
</blockquote></div><br>

------=_Part_9089_229483.1205416418173--


--===============0600953885==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0600953885==--
