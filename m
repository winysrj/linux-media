Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.235])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michaelbeeson@gmail.com>) id 1K5nK1-0007L0-CX
	for linux-dvb@linuxtv.org; Mon, 09 Jun 2008 21:46:30 +0200
Received: by wr-out-0506.google.com with SMTP id c30so1260840wra.14
	for <linux-dvb@linuxtv.org>; Mon, 09 Jun 2008 12:46:25 -0700 (PDT)
Message-ID: <57eb3fe80806091246k6a144824j5050ebc1a25ebd78@mail.gmail.com>
Date: Mon, 9 Jun 2008 20:46:25 +0100
From: "Mike Beeson" <michaelbeeson@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <a413d4880806090722s7625d73bx79862246f93f694@mail.gmail.com>
MIME-Version: 1.0
References: <57eb3fe80806090530o7d1d5684r43047b33b182966a@mail.gmail.com>
	<34063.144.98.76.45.1213019670.squirrel@dragonfly.dnsalias.net>
	<57eb3fe80806090715g59a4908dn9ea63c683ed62c51@mail.gmail.com>
	<a413d4880806090722s7625d73bx79862246f93f694@mail.gmail.com>
Subject: Re: [linux-dvb] UK Freesat twin tuner USB/PCI/PCI-E
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1391220654=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1391220654==
Content-Type: multipart/alternative;
	boundary="----=_Part_15498_11754160.1213040785315"

------=_Part_15498_11754160.1213040785315
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thanks. I see what you mean about saturating the USB bus, but I would be
using USB2 devices on seperate busses (AMD 780G motherboard).

Assuming that this works okay, nobody has voiced that having two of the same
device under linux is going to be a problem?

Thanks,

Mike.


2008/6/9 Another Sillyname <anothersname@googlemail.com>:

> Mike
>
> Bandwidth is a problem for Freesat HD.....on DVB-T the BBC test in HD
> was using up to 24mbps as against a 'normal' channel using
> 4-6Mbps....I don't know the Sat numbers but would expect them to be in
> the same order.
>
> If you want to record more then 1 HD channel at a time you could well
> start to saturate the USB bus (Some PC's have different USB devices on
> different busses so it's worthy checking).....the other issue I've
> found is that USB devices can run a bit 'warm' and have no real
> cooling....this can cause cutouts in warm weather (never used to be a
> problem in the UK but has been the last few summers).
>
> J
>
> 2008/6/9 Mike Beeson <michaelbeeson@gmail.com>:
> > Thanks everyone. This is really helpful info.
> >
> > I'd like to go DVB-S2 for future compatibility as I don't want to junk
> the
> > tuners and get new ones if the BBC or ITV decide to go to DVB-S2. It
> looks
> > like the Technotrend S3600 is the best option at the moment.
> >
> > My main concern is having two of these USB and whether I will get any
> > trouble with this??
> >
> > Mike.
> >
> >
> > On 09/06/2008, Robert <RobertCL@iname.com> wrote:
> >>
> >> On Mon, June 9, 2008 1:30 pm, Mike Beeson wrote:
> >> > Hi all,
> >> >
> >> > I've searched high and low, but can't find a product (either USB, PCI
> or
> >> > PCI-E) that can allow me to have twin tuners and pick up the UK
> freesat
> >> > service (with BBC and ITV HD content). Does such a thing exist?
> >> >
> >> > I wouldn't mid going with 2 single tuner USB products, but even then
> I'm
> >> > not
> >> > sure what is required.
> >> >
> >> > The wiki pages don't seem to offer any light and neither does a large
> >> > amount
> >> > of googling.
> >> >
> >>
> >> I've been looking for the same thing for a while, and haven't found
> >> anything.  I was planning on buying the Technotrend S-1500 (PCI card)
> >> which appears to be fairly well supported.
> >>
> >> I think someone else has said it, but all freesat broadcasts are
> currently
> >> DVB-S only.  I can currently get BBCHD and ITVHD using the DVB-S part of
> >> my HVR-3000 (Analog + DVB-T + DVB-S hybrid card)
> >>
> >> I think that DVB-S2 support in Linux is still fairly new, and not
> >> officially supported by (m)any apps (VDR or MythTv)
> >>
> >> Robert.
> >>
> >>
> >> _______________________________________________
> >> linux-dvb mailing list
> >> linux-dvb@linuxtv.org
> >> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
>

------=_Part_15498_11754160.1213040785315
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thanks. I see what you mean about saturating the USB bus, but I would be using USB2 devices on seperate busses (AMD 780G motherboard).<br><br>Assuming that this works okay, nobody has voiced that having two of the same device under linux is going to be a problem?<br>
<br>Thanks,<br><br>Mike.<br><br><br><div class="gmail_quote">2008/6/9 Another Sillyname &lt;<a href="mailto:anothersname@googlemail.com">anothersname@googlemail.com</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Mike<br>
<br>
Bandwidth is a problem for Freesat HD.....on DVB-T the BBC test in HD<br>
was using up to 24mbps as against a &#39;normal&#39; channel using<br>
4-6Mbps....I don&#39;t know the Sat numbers but would expect them to be in<br>
the same order.<br>
<br>
If you want to record more then 1 HD channel at a time you could well<br>
start to saturate the USB bus (Some PC&#39;s have different USB devices on<br>
different busses so it&#39;s worthy checking).....the other issue I&#39;ve<br>
found is that USB devices can run a bit &#39;warm&#39; and have no real<br>
cooling....this can cause cutouts in warm weather (never used to be a<br>
problem in the UK but has been the last few summers).<br>
<br>
J<br>
<br>
2008/6/9 Mike Beeson &lt;<a href="mailto:michaelbeeson@gmail.com">michaelbeeson@gmail.com</a>&gt;:<br>
<div><div></div><div class="Wj3C7c">&gt; Thanks everyone. This is really helpful info.<br>
&gt;<br>
&gt; I&#39;d like to go DVB-S2 for future compatibility as I don&#39;t want to junk the<br>
&gt; tuners and get new ones if the BBC or ITV decide to go to DVB-S2. It looks<br>
&gt; like the Technotrend S3600 is the best option at the moment.<br>
&gt;<br>
&gt; My main concern is having two of these USB and whether I will get any<br>
&gt; trouble with this??<br>
&gt;<br>
&gt; Mike.<br>
&gt;<br>
&gt;<br>
&gt; On 09/06/2008, Robert &lt;<a href="mailto:RobertCL@iname.com">RobertCL@iname.com</a>&gt; wrote:<br>
&gt;&gt;<br>
&gt;&gt; On Mon, June 9, 2008 1:30 pm, Mike Beeson wrote:<br>
&gt;&gt; &gt; Hi all,<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; I&#39;ve searched high and low, but can&#39;t find a product (either USB, PCI or<br>
&gt;&gt; &gt; PCI-E) that can allow me to have twin tuners and pick up the UK freesat<br>
&gt;&gt; &gt; service (with BBC and ITV HD content). Does such a thing exist?<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; I wouldn&#39;t mid going with 2 single tuner USB products, but even then I&#39;m<br>
&gt;&gt; &gt; not<br>
&gt;&gt; &gt; sure what is required.<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; The wiki pages don&#39;t seem to offer any light and neither does a large<br>
&gt;&gt; &gt; amount<br>
&gt;&gt; &gt; of googling.<br>
&gt;&gt; &gt;<br>
&gt;&gt;<br>
&gt;&gt; I&#39;ve been looking for the same thing for a while, and haven&#39;t found<br>
&gt;&gt; anything. &nbsp;I was planning on buying the Technotrend S-1500 (PCI card)<br>
&gt;&gt; which appears to be fairly well supported.<br>
&gt;&gt;<br>
&gt;&gt; I think someone else has said it, but all freesat broadcasts are currently<br>
&gt;&gt; DVB-S only. &nbsp;I can currently get BBCHD and ITVHD using the DVB-S part of<br>
&gt;&gt; my HVR-3000 (Analog + DVB-T + DVB-S hybrid card)<br>
&gt;&gt;<br>
&gt;&gt; I think that DVB-S2 support in Linux is still fairly new, and not<br>
&gt;&gt; officially supported by (m)any apps (VDR or MythTv)<br>
&gt;&gt;<br>
&gt;&gt; Robert.<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; _______________________________________________<br>
&gt;&gt; linux-dvb mailing list<br>
&gt;&gt; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt;&gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
&gt;<br>
&gt;<br>
&gt; _______________________________________________<br>
&gt; linux-dvb mailing list<br>
&gt; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
&gt;<br>
</div></div></blockquote></div><br>

------=_Part_15498_11754160.1213040785315--


--===============1391220654==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1391220654==--
