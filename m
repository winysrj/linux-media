Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <derk.dukker@gmail.com>) id 1JjDpZ-0001A1-9u
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 15:25:48 +0200
Received: by yw-out-2324.google.com with SMTP id 5so350492ywh.41
	for <linux-dvb@linuxtv.org>; Tue, 08 Apr 2008 06:25:01 -0700 (PDT)
Message-ID: <e2d627830804080624m9a5c3wf48146b863c5f183@mail.gmail.com>
Date: Tue, 8 Apr 2008 15:24:59 +0200
From: "Derk Dukker" <derk.dukker@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <47EC14A3.7010505@linuxtv.org>
MIME-Version: 1.0
References: <47EBF4B7.2060705@linuxtv.org>
	<c8b4dbe10803271241i20990cf3j1b75c85f1f649916@mail.gmail.com>
	<47EBFC19.4060106@linuxtv.org>
	<c8b4dbe10803271428y13bd710co995e25bb9a2eb614@mail.gmail.com>
	<47EC14A3.7010505@linuxtv.org>
Subject: Re: [linux-dvb] Hauppauge WinTV-CI Spec
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0006901586=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0006901586==
Content-Type: multipart/alternative;
	boundary="----=_Part_21878_4298987.1207661099777"

------=_Part_21878_4298987.1207661099777
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,

I was wondering if there is any progress going on at the Hauppauge WinTV CI
usb. I heard that a guy named Luc is currently working on it. Luc do you
have any information about your progress or do you have a site where I/we
can track back the progress? I also noticed that the design of the Hauppauge
WinTV CI usb is quite the same as the Terratec Cinergy CI usb which I
bought. SmarDTV is the vendor of it (I opened the case and on the print
board stood SmarDTV). You can get the specification from the website (see
also earlier emails).
I think both the devices are the same, so when one driver is created it will
probably also works on the terratec cinergy ci. I don't know if the
specification from smarDTV is enough...
I have had contact with the dutch terratec support and asked them if they
can get me the specification to create a linux driver. He said that he would
check it out if it is possible for me to have the specification, as soon as
he knows more he will update me. But that email responds was 1 or 2 weeks
ago. I will email him again. As soon as I got something I will post it here.

regards,

Derk

On Thu, Mar 27, 2008 at 11:41 PM, Steven Toth <stoth@linuxtv.org> wrote:

> Aidan Thornton wrote:
> > On Thu, Mar 27, 2008 at 7:57 PM, Steven Toth <stoth@linuxtv.org> wrote:
> >> Aidan Thornton wrote:
> >>  > On Thu, Mar 27, 2008 at 7:25 PM, Steven Toth <stoth@linuxtv.org>
> wrote:
> >>  >> Recap: I said I'd notify the list when the spec was released for
> the
> >>  >>  Hauppauge CI device.
> >>  >>
> >>  >>  Hello!
> >>  >>
> >>  >>  http://www.smardtv.com/index.php?page=dvbci&rubrique=specification
> >>  >>
> >>  >>  Looks like SmartDTV have finally got something out of the door.
> Put your
> >>  >>  email address in their database and they'll email you the PDF with
> full
> >>  >>  command interface describing the protocol.
> >>  >>
> >>  >>  Regards,
> >>  >>
> >>  >>  - Steve
> >>  >
> >>  > Hi,
> >>  >
> >>  > I'm not sure how that's relevant. It seems to be the spec for
> >>  > something called CI+, intended to prevent unauthorised systems from
> >>  > getting access to the decrypted stream coming out the CAM and ensure
> >>  > only authorised host devices can use CAMs. I expect open source
> >>  > software will be able to make use of this stuff approximately when
> >>  > hell freezes over. If this catches on, say hello to more copy
> >>  > protection and bye-bye to being able to use CAMs under Linux!
> >>
> >>  A subset of the spec will work with the CI USB device, for those that
> >>  are interested.
> >
> > Yeah, that's what I was wondering about - it doesn't seem to specify
> > anything about CI USB devices, just the standard PC card based
> > interface. (It even states that it doesn't deal with any interfaces
> > other than that one). In what sense does the WinTV-CI implement this -
> > does it translate between standard CIs and some subset of this
> > protocol done over USB? (I'm not even sure, at a glance, if this makes
> > sense.)
>
> I only glanced at the spec, but from what I'm told the command API is
> implemented over USB. I suspect that Luc (the guy working on the Linux
> driver) might be able to consolidate this command set, with the USB logs
> he's been capturing. If not then something is clearly wrong.
>
> I'd been promised this document during December 2007 by the vendor and
> said that I'd post it here to the community as soon as it was released.
>
> - Steve
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_21878_4298987.1207661099777
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,<br><br>I was wondering if there is any progress going on at the Hauppauge WinTV CI usb. I heard that a guy named Luc is currently working on it. Luc do you have any information about your progress or do you have a site where I/we can track back the progress? I also noticed that the design of the Hauppauge WinTV CI usb is quite the same as the Terratec Cinergy CI usb which I bought. SmarDTV is the vendor of it (I opened the case and on the print board stood SmarDTV). You can get the specification from the website (see also earlier emails).<br>
I think both the devices are the same, so when one driver is created it will probably also works on the terratec cinergy ci. I don&#39;t know if the specification from smarDTV is enough...<br>I have had contact with the dutch terratec support and asked them if they can get me the specification to create a linux driver. He said that he would check it out if it is possible for me to have the specification, as soon as he knows more he will update me. But that email responds was 1 or 2 weeks ago. I will email him again. As soon as I got something I will post it here.<br>
<br>regards,<br><br>Derk<br><br><div class="gmail_quote">On Thu, Mar 27, 2008 at 11:41 PM, Steven Toth &lt;<a href="mailto:stoth@linuxtv.org">stoth@linuxtv.org</a>&gt; wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Aidan Thornton wrote:<br>
<div class="Ih2E3d">&gt; On Thu, Mar 27, 2008 at 7:57 PM, Steven Toth &lt;<a href="mailto:stoth@linuxtv.org">stoth@linuxtv.org</a>&gt; wrote:<br>
&gt;&gt; Aidan Thornton wrote:<br>
&gt;&gt; &nbsp;&gt; On Thu, Mar 27, 2008 at 7:25 PM, Steven Toth &lt;<a href="mailto:stoth@linuxtv.org">stoth@linuxtv.org</a>&gt; wrote:<br>
&gt;&gt; &nbsp;&gt;&gt; Recap: I said I&#39;d notify the list when the spec was released for the<br>
&gt;&gt; &nbsp;&gt;&gt; &nbsp;Hauppauge CI device.<br>
&gt;&gt; &nbsp;&gt;&gt;<br>
&gt;&gt; &nbsp;&gt;&gt; &nbsp;Hello!<br>
&gt;&gt; &nbsp;&gt;&gt;<br>
&gt;&gt; &nbsp;&gt;&gt; &nbsp;<a href="http://www.smardtv.com/index.php?page=dvbci&amp;rubrique=specification" target="_blank">http://www.smardtv.com/index.php?page=dvbci&amp;rubrique=specification</a><br>
&gt;&gt; &nbsp;&gt;&gt;<br>
&gt;&gt; &nbsp;&gt;&gt; &nbsp;Looks like SmartDTV have finally got something out of the door. Put your<br>
&gt;&gt; &nbsp;&gt;&gt; &nbsp;email address in their database and they&#39;ll email you the PDF with full<br>
&gt;&gt; &nbsp;&gt;&gt; &nbsp;command interface describing the protocol.<br>
&gt;&gt; &nbsp;&gt;&gt;<br>
&gt;&gt; &nbsp;&gt;&gt; &nbsp;Regards,<br>
&gt;&gt; &nbsp;&gt;&gt;<br>
&gt;&gt; &nbsp;&gt;&gt; &nbsp;- Steve<br>
&gt;&gt; &nbsp;&gt;<br>
&gt;&gt; &nbsp;&gt; Hi,<br>
&gt;&gt; &nbsp;&gt;<br>
&gt;&gt; &nbsp;&gt; I&#39;m not sure how that&#39;s relevant. It seems to be the spec for<br>
&gt;&gt; &nbsp;&gt; something called CI+, intended to prevent unauthorised systems from<br>
&gt;&gt; &nbsp;&gt; getting access to the decrypted stream coming out the CAM and ensure<br>
&gt;&gt; &nbsp;&gt; only authorised host devices can use CAMs. I expect open source<br>
&gt;&gt; &nbsp;&gt; software will be able to make use of this stuff approximately when<br>
&gt;&gt; &nbsp;&gt; hell freezes over. If this catches on, say hello to more copy<br>
&gt;&gt; &nbsp;&gt; protection and bye-bye to being able to use CAMs under Linux!<br>
&gt;&gt;<br>
&gt;&gt; &nbsp;A subset of the spec will work with the CI USB device, for those that<br>
&gt;&gt; &nbsp;are interested.<br>
&gt;<br>
</div>&gt; Yeah, that&#39;s what I was wondering about - it doesn&#39;t seem to specify<br>
&gt; anything about CI USB devices, just the standard PC card based<br>
&gt; interface. (It even states that it doesn&#39;t deal with any interfaces<br>
&gt; other than that one). In what sense does the WinTV-CI implement this -<br>
&gt; does it translate between standard CIs and some subset of this<br>
&gt; protocol done over USB? (I&#39;m not even sure, at a glance, if this makes<br>
&gt; sense.)<br>
<br>
I only glanced at the spec, but from what I&#39;m told the command API is<br>
implemented over USB. I suspect that Luc (the guy working on the Linux<br>
driver) might be able to consolidate this command set, with the USB logs<br>
he&#39;s been capturing. If not then something is clearly wrong.<br>
<br>
I&#39;d been promised this document during December 2007 by the vendor and<br>
said that I&#39;d post it here to the community as soon as it was released.<br>
<div><div></div><div class="Wj3C7c"><br>
- Steve<br>
<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br>

------=_Part_21878_4298987.1207661099777--


--===============0006901586==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0006901586==--
