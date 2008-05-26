Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.224])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <totallymaxed@gmail.com>) id 1K0ZNf-0003zr-0k
	for linux-dvb@linuxtv.org; Mon, 26 May 2008 11:52:42 +0200
Received: by wr-out-0506.google.com with SMTP id c30so856256wra.14
	for <linux-dvb@linuxtv.org>; Mon, 26 May 2008 02:52:31 -0700 (PDT)
Message-ID: <71798b430805260252h2730a3f1p34b90bb2c39a1025@mail.gmail.com>
Date: Mon, 26 May 2008 10:52:29 +0100
From: "Andrew Herron" <totallymaxed@gmail.com>
To: "Zac Spitzer" <zac.spitzer@gmail.com>
In-Reply-To: <7a85053e0805260229v151b2bc2q1f34d2143aa5539e@mail.gmail.com>
MIME-Version: 1.0
References: <20080525112820.374AC104F0@ws1-3.us4.outblaze.com>
	<200805260420.59067.bumkunjo@gmx.de>
	<7a85053e0805260229v151b2bc2q1f34d2143aa5539e@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0349991118=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0349991118==
Content-Type: multipart/alternative;
	boundary="----=_Part_11094_32997565.1211795549825"

------=_Part_11094_32997565.1211795549825
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I have a dual digitial 4 (rev 2 ) as well... so i hope this patch works this
card too ;-)

On Mon, May 26, 2008 at 10:29 AM, Zac Spitzer <zac.spitzer@gmail.com> wrote:

> which pci id is this for? I have a dual digitial 4 (rev 2 ) which is
> 0fe9:db98
>
> On Mon, May 26, 2008 at 12:20 PM,  <bumkunjo@gmx.de> wrote:
> >
> > Thanks for the patch, Frieder - it seems to work perfectly on my vdr box
> - all
> > channels tune - good reception.
> > i will report if any issues appear. if I can help testing upcoming
> versions of
> > the driver ask me.
> >
> > Thanks a lot to Chris and Stephen for your work,
> >
> > Jochen
> >
> > Am Sonntag 25 Mai 2008 13:28:20 schrieb stev391@email.com:
> >>  Hans-Frieder,
> >>
> >> Thanks, for this patch.  I have tested it on 1 of 3 machines that I have
> >> access to with this DVB card. No issues (Now loads 80 firmwares, instead
> >> of 3)
> >>
> >> It doesn't break Chris Pascoe's xc-test branch with the DViCO Fusion
> HDTV
> >> DVB-T Dual Express.
> >>
> >> It also makes my patch, to get support into the v4l-dvb head, (newer
> >> version then posted here) work a lot more reliably (Perfectly on this
> >> test machine, I will run it on my mythbox for a week or so before I post
> >> it).
> >>
> >> I think you should email Chris Pascoe and petition him to include it in
> >> his branch.  As this will definitely help alot of people out.
> >>
> >> Thanks again,
> >>
> >> Stephen.
> >>
> >>   ----- Original Message -----
> >>   From: "Hans-Frieder Vogt"
> >>   To: "jochen s" , stev391@email.com
> >>   Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
> >>   Date: Fri, 23 May 2008 21:46:58 +0200
> >>
> >>
> >>   Jochen,
> >>
> >>   you are indeed missing firmwares. The xc-test branch from Chris
> >>   Pascoe uses the special collection of firmwares
> >>   xc3028-dvico-au-01.fw which only contains firmwares for 7MHz
> >>   bandwidth (just try to tune a channel in the 7MHz band to confirm
> >>   this). To make the card work also for other bandwidths please apply
> >>   the following patch and put the standard firmware for xc3028
> >>   (xc3028-v27.fw) in the usual place (e.g. /lib/firmware).
> >>
> >>   This approach should also work for australia, because the standard
> >>   firmware also contains those firmwares in xc3028-dvico-au-01.fw.
> >>
> >>   Stephen, can you confirm this?
> >>
> >>   Cheers,
> >>   Hans-Frieder
> >>
> >>   --- xc-test.orig/linux/drivers/media/video/cx23885/cx23885-dvb.c
> >>   2008-04-26 23:40:52.000000000 +0200
> >>   +++ xc-test/linux/drivers/media/video/cx23885/cx23885-dvb.c
> >>   2008-05-19 23:15:08.000000000 +0200
> >>   @@ -217,9 +217,9 @@ static int dvb_register(struct cx23885_t
> >>   .callback = cx23885_dvico_xc2028_callback,
> >>   };
> >>   static struct xc2028_ctrl ctl = {
> >>   - .fname = "xc3028-dvico-au-01.fw",
> >>   + .fname = "xc3028-v27.fw",
> >>   .max_len = 64,
> >>   - .scode_table = ZARLINK456,
> >>   + .demod = XC3028_FE_ZARLINK456,
> >>   };
> >>
> >>   fe = dvb_attach(xc2028_attach, port->dvb.frontend,
> >
> >
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
>
>
>
> --
> Zac Spitzer -
> http://zacster.blogspot.com (My Blog)
> +61 405 847 168
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>



-- 
Convergent Home Technologies Ltd
www.dianemo.co.uk
Tel: +44 (0)1245 330101
Fax: +44 (0)1245 263916

Unit 205 Waterhouse Business Centre
Cromar Way
Chelmsford
Essex CM1 2QE
UK

------=_Part_11094_32997565.1211795549825
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I have a dual digitial 4 (rev 2 ) as well... so i hope this patch works this card too ;-)<br><br><div class="gmail_quote">On Mon, May 26, 2008 at 10:29 AM, Zac Spitzer &lt;<a href="mailto:zac.spitzer@gmail.com">zac.spitzer@gmail.com</a>&gt; wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">which pci id is this for? I have a dual digitial 4 (rev 2 ) which is 0fe9:db98<br>
<div><div></div><div class="Wj3C7c"><br>
On Mon, May 26, 2008 at 12:20 PM, &nbsp;&lt;<a href="mailto:bumkunjo@gmx.de">bumkunjo@gmx.de</a>&gt; wrote:<br>
&gt;<br>
&gt; Thanks for the patch, Frieder - it seems to work perfectly on my vdr box - all<br>
&gt; channels tune - good reception.<br>
&gt; i will report if any issues appear. if I can help testing upcoming versions of<br>
&gt; the driver ask me.<br>
&gt;<br>
&gt; Thanks a lot to Chris and Stephen for your work,<br>
&gt;<br>
&gt; Jochen<br>
&gt;<br>
&gt; Am Sonntag 25 Mai 2008 13:28:20 schrieb <a href="mailto:stev391@email.com">stev391@email.com</a>:<br>
&gt;&gt; &nbsp;Hans-Frieder,<br>
&gt;&gt;<br>
&gt;&gt; Thanks, for this patch. &nbsp;I have tested it on 1 of 3 machines that I have<br>
&gt;&gt; access to with this DVB card. No issues (Now loads 80 firmwares, instead<br>
&gt;&gt; of 3)<br>
&gt;&gt;<br>
&gt;&gt; It doesn&#39;t break Chris Pascoe&#39;s xc-test branch with the DViCO Fusion HDTV<br>
&gt;&gt; DVB-T Dual Express.<br>
&gt;&gt;<br>
&gt;&gt; It also makes my patch, to get support into the v4l-dvb head, (newer<br>
&gt;&gt; version then posted here) work a lot more reliably (Perfectly on this<br>
&gt;&gt; test machine, I will run it on my mythbox for a week or so before I post<br>
&gt;&gt; it).<br>
&gt;&gt;<br>
&gt;&gt; I think you should email Chris Pascoe and petition him to include it in<br>
&gt;&gt; his branch. &nbsp;As this will definitely help alot of people out.<br>
&gt;&gt;<br>
&gt;&gt; Thanks again,<br>
&gt;&gt;<br>
&gt;&gt; Stephen.<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; ----- Original Message -----<br>
&gt;&gt; &nbsp; From: &quot;Hans-Frieder Vogt&quot;<br>
&gt;&gt; &nbsp; To: &quot;jochen s&quot; , <a href="mailto:stev391@email.com">stev391@email.com</a><br>
&gt;&gt; &nbsp; Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]<br>
&gt;&gt; &nbsp; Date: Fri, 23 May 2008 21:46:58 +0200<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; Jochen,<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; you are indeed missing firmwares. The xc-test branch from Chris<br>
&gt;&gt; &nbsp; Pascoe uses the special collection of firmwares<br>
&gt;&gt; &nbsp; xc3028-dvico-au-01.fw which only contains firmwares for 7MHz<br>
&gt;&gt; &nbsp; bandwidth (just try to tune a channel in the 7MHz band to confirm<br>
&gt;&gt; &nbsp; this). To make the card work also for other bandwidths please apply<br>
&gt;&gt; &nbsp; the following patch and put the standard firmware for xc3028<br>
&gt;&gt; &nbsp; (xc3028-v27.fw) in the usual place (e.g. /lib/firmware).<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; This approach should also work for australia, because the standard<br>
&gt;&gt; &nbsp; firmware also contains those firmwares in xc3028-dvico-au-01.fw.<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; Stephen, can you confirm this?<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; Cheers,<br>
&gt;&gt; &nbsp; Hans-Frieder<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; --- xc-test.orig/linux/drivers/media/video/cx23885/cx23885-dvb.c<br>
&gt;&gt; &nbsp; 2008-04-26 23:40:52.000000000 +0200<br>
&gt;&gt; &nbsp; +++ xc-test/linux/drivers/media/video/cx23885/cx23885-dvb.c<br>
&gt;&gt; &nbsp; 2008-05-19 23:15:08.000000000 +0200<br>
&gt;&gt; &nbsp; @@ -217,9 +217,9 @@ static int dvb_register(struct cx23885_t<br>
&gt;&gt; &nbsp; .callback = cx23885_dvico_xc2028_callback,<br>
&gt;&gt; &nbsp; };<br>
&gt;&gt; &nbsp; static struct xc2028_ctrl ctl = {<br>
&gt;&gt; &nbsp; - .fname = &quot;xc3028-dvico-au-01.fw&quot;,<br>
&gt;&gt; &nbsp; + .fname = &quot;xc3028-v27.fw&quot;,<br>
&gt;&gt; &nbsp; .max_len = 64,<br>
&gt;&gt; &nbsp; - .scode_table = ZARLINK456,<br>
&gt;&gt; &nbsp; + .demod = XC3028_FE_ZARLINK456,<br>
&gt;&gt; &nbsp; };<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; fe = dvb_attach(xc2028_attach, port-&gt;dvb.frontend,<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; _______________________________________________<br>
&gt; linux-dvb mailing list<br>
&gt; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
&gt;<br>
<br>
<br>
<br>
</div></div><font color="#888888">--<br>
Zac Spitzer -<br>
<a href="http://zacster.blogspot.com" target="_blank">http://zacster.blogspot.com</a> (My Blog)<br>
+61 405 847 168<br>
</font><div><div></div><div class="Wj3C7c"><br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br><br clear="all"><br>-- <br>Convergent Home Technologies Ltd<br><a href="http://www.dianemo.co.uk">www.dianemo.co.uk</a><br>Tel: +44 (0)1245 330101<br>Fax: +44 (0)1245 263916<br><br>Unit 205 Waterhouse Business Centre<br>
Cromar Way<br>Chelmsford<br>Essex CM1 2QE<br>UK

------=_Part_11094_32997565.1211795549825--


--===============0349991118==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0349991118==--
