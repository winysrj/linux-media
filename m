Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thewatchman@gmail.com>) id 1LIl4E-0000cX-2b
	for linux-dvb@linuxtv.org; Fri, 02 Jan 2009 15:32:02 +0100
Received: by rn-out-0910.google.com with SMTP id j43so3948298rne.2
	for <linux-dvb@linuxtv.org>; Fri, 02 Jan 2009 06:31:57 -0800 (PST)
Message-ID: <c715948d0901020631rf3b24b1md411d7cad2eb40cc@mail.gmail.com>
Date: Fri, 2 Jan 2009 08:31:57 -0600
From: Greg <thewatchman@gmail.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1230773531.3121.13.camel@palomino.walls.org>
MIME-Version: 1.0
References: <c715948d0812301528h5a4f2a57xa973099ffb33730@mail.gmail.com>
	<1230773531.3121.13.camel@palomino.walls.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] pcHDTV-5500 and FC10 (resend, was too big)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2042944399=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2042944399==
Content-Type: multipart/alternative;
	boundary="----=_Part_134662_29181099.1230906717249"

------=_Part_134662_29181099.1230906717249
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

It seems like something is broken with the code with regard to detecting the
tuner type or maybe the tuner tyes are wrong in the code.

I have tried specifying a tuner type in modeprob.d/options and this has
given me limited success (options cx88xx tuner=64). I have been able to get
the channel scan to work doing this, but so far no video capture. I am not
sure what the correct tuner is or how I can now capture video to see if it
is working. I have tried the watch tv option and catpure video on mythtv tv,
but the live TV times out and the recorded video is just snow, so something
is still not quite right with the setup.

Is there a simple way to dump the digitial video from a specified channnel
to a file and play it with mplayer or something?

Hope someone can help fix this tunner issue. (see my previous post for more
details).

Greg




On Wed, Dec 31, 2008 at 7:32 PM, Andy Walls <awalls@radix.net> wrote:

> On Tue, 2008-12-30 at 17:28 -0600, Greg wrote:
> > I have been trying to get my PCHD-5500 card to work  with FC10. So far
> > I am able to get  the analog tuner portion of the card to work but not
> > the digital. Devinheitmueller was pointing me in the direction to
> > look. I am getting a crash in one of the modules, which looks like it
> > is coming from the line:
> >
> > div = ((frequency + t_params->iffreq) * 62500 + offset +
> > tun->stepsize/2) / tun->stepsize;
> >
> >
> > The crash is apparently being cased by a zero stepsize. This crash
> > occured when I was scanning for channels either from mythtvset or
> > Kaffeine, or a command line program that came with the card. I also
> > have  Hauppague 250 card in the system which seems to work.
> >
> > If I select the digital tuner from mythtv the application just hangs
> > and I get a blank screen.
> >
> > I tried hacking the tuner-types.mod.c file and adding the following
> > lines to it that I coppied from one of the other cards (though I
> > suspect these values are not right for this card)
> >
> >     [TUNER_LG_NTSC_TAPE] = { /* LGINNOTEK NTSC */
> >                 .name   = "LG NTSC (TAPE series)",
> >                 .params = tuner_fm1236_mk3_params,
> >                 .count  = ARRAY_SIZE(tuner_fm1236_mk3_params),
> >                 //adding these lines copied from above so that we have
> > no-zero values
> >                 .min = 16 * 53.00,
> >                 .max = 16 * 803.00,
> >                 .stepsize = 62500,
> >
>
> The TAPE-Hxxx series tuners are an LG rebrand of the equivalent Phillips
> tuner.  The TAPE-H091F-MK3 and TAPE-Hxxx data sheets I have say this
> about the analog ranges:
>
> Low :   55.25 - 157.25 MHz
> Mid :  163.25 - 439.25 MHz
> High:  445.25 - 801.25 MHz
> FM:     88.00 - 108.00 MHz
>
> The step size is programmable: 31.25 kHz, 50.00 kHz, 62.50 kHz, ...
>
> With a control byte of 0x8e (as in the tuner_fm1236_mk3_params), you're
> programming a step size of 62.50 kHz.
>
> Of course this is an analog M/N system tuner with FM radio.  I suspect
> this isn't the tuner you're looking for, for Digital TV.
>
> Regards,
> Andy
>
>

------=_Part_134662_29181099.1230906717249
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

It seems like something is broken with the code with regard to detecting the tuner type or maybe the tuner tyes are wrong in the code.<br><br>I have tried specifying a tuner type in modeprob.d/options and this has given me limited success (options cx88xx tuner=64). I have been able to get the channel scan to work doing this, but so far no video capture. I am not sure what the correct tuner is or how I can now capture video to see if it is working. I have tried the watch tv option and catpure video on mythtv tv, but the live TV times out and the recorded video is just snow, so something is still not quite right with the setup. <br>
<br>Is there a simple way to dump the digitial video from a specified channnel to a file and play it with mplayer or something?<br><br>Hope someone can help fix this tunner issue. (see my previous post for more details).<br>
<br>Greg<br><br><br><br><br><div class="gmail_quote">On Wed, Dec 31, 2008 at 7:32 PM, Andy Walls <span dir="ltr">&lt;<a href="mailto:awalls@radix.net">awalls@radix.net</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div><div></div><div class="Wj3C7c">On Tue, 2008-12-30 at 17:28 -0600, Greg wrote:<br>
&gt; I have been trying to get my PCHD-5500 card to work &nbsp;with FC10. So far<br>
&gt; I am able to get &nbsp;the analog tuner portion of the card to work but not<br>
&gt; the digital. Devinheitmueller was pointing me in the direction to<br>
&gt; look. I am getting a crash in one of the modules, which looks like it<br>
&gt; is coming from the line:<br>
&gt;<br>
&gt; div = ((frequency + t_params-&gt;iffreq) * 62500 + offset +<br>
&gt; tun-&gt;stepsize/2) / tun-&gt;stepsize;<br>
&gt;<br>
&gt;<br>
&gt; The crash is apparently being cased by a zero stepsize. This crash<br>
&gt; occured when I was scanning for channels either from mythtvset or<br>
&gt; Kaffeine, or a command line program that came with the card. I also<br>
&gt; have &nbsp;Hauppague 250 card in the system which seems to work.<br>
&gt;<br>
&gt; If I select the digital tuner from mythtv the application just hangs<br>
&gt; and I get a blank screen.<br>
&gt;<br>
&gt; I tried hacking the tuner-types.mod.c file and adding the following<br>
&gt; lines to it that I coppied from one of the other cards (though I<br>
&gt; suspect these values are not right for this card)<br>
&gt;<br>
&gt; &nbsp; &nbsp; [TUNER_LG_NTSC_TAPE] = { /* LGINNOTEK NTSC */<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .name &nbsp; = &quot;LG NTSC (TAPE series)&quot;,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .params = tuner_fm1236_mk3_params,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .count &nbsp;= ARRAY_SIZE(tuner_fm1236_mk3_params),<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; //adding these lines copied from above so that we have<br>
&gt; no-zero values<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .min = 16 * 53.00,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .max = 16 * 803.00,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .stepsize = 62500,<br>
&gt;<br>
<br>
</div></div>The TAPE-Hxxx series tuners are an LG rebrand of the equivalent Phillips<br>
tuner. &nbsp;The TAPE-H091F-MK3 and TAPE-Hxxx data sheets I have say this<br>
about the analog ranges:<br>
<br>
Low : &nbsp; 55.25 - 157.25 MHz<br>
Mid : &nbsp;163.25 - 439.25 MHz<br>
High: &nbsp;445.25 - 801.25 MHz<br>
FM: &nbsp; &nbsp; 88.00 - 108.00 MHz<br>
<br>
The step size is programmable: 31.25 kHz, 50.00 kHz, 62.50 kHz, ...<br>
<br>
With a control byte of 0x8e (as in the tuner_fm1236_mk3_params), you&#39;re<br>
programming a step size of 62.50 kHz.<br>
<br>
Of course this is an analog M/N system tuner with FM radio. &nbsp;I suspect<br>
this isn&#39;t the tuner you&#39;re looking for, for Digital TV.<br>
<br>
Regards,<br>
<font color="#888888">Andy<br>
<br>
</font></blockquote></div><br>

------=_Part_134662_29181099.1230906717249--


--===============2042944399==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2042944399==--
