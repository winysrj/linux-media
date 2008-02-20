Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.232])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mattvermeulen@gmail.com>) id 1JRoiM-0002qz-Kk
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 14:10:23 +0100
Received: by wx-out-0506.google.com with SMTP id s11so2144189wxc.17
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 05:10:18 -0800 (PST)
Message-ID: <950c7d180802200510q520db11dua30c9d36f231c624@mail.gmail.com>
Date: Wed, 20 Feb 2008 22:10:17 +0900
From: "Matthew Vermeulen" <mattvermeulen@gmail.com>
To: "Nicolas Will" <nico@youplala.net>
In-Reply-To: <1203494091.11318.7.camel@youkaida>
MIME-Version: 1.0
References: <1203434275.6870.25.camel@tux> <1203441662.9150.29.camel@acropora>
	<1203448799.28796.3.camel@youkaida>
	<1203449457.28796.7.camel@youkaida>
	<950c7d180802191310x5882541h61bc60195a998da4@mail.gmail.com>
	<1203458966.28796.13.camel@youkaida>
	<950c7d180802192339s5fa402fan6a9ac8674e128689@mail.gmail.com>
	<1203494091.11318.7.camel@youkaida>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700 ir
	receiver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0128374561=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0128374561==
Content-Type: multipart/alternative;
	boundary="----=_Part_9452_27095304.1203513017595"

------=_Part_9452_27095304.1203513017595
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Feb 20, 2008 4:54 PM, Nicolas Will <nico@youplala.net> wrote:

>
> On Wed, 2008-02-20 at 16:39 +0900, Matthew Vermeulen wrote:
> > On Feb 20, 2008 7:09 AM, Nicolas Will <nico@youplala.net> wrote:
> >
> >
> >         On Wed, 2008-02-20 at 06:10 +0900, Matthew Vermeulen wrote:
> >         > Hi all... I'm seeing exactly the same problems everyone else
> >         is (log
> >         > flooding etc) except that I can't seem to get any keys
> >         picked by lirc
> >         > or /dev/input/event7 at all...
> >         >
> >         > Would this patch help in this case?
> >
> >
> >         It would help with the flooding, most probably, though there
> >         was a patch
> >         for that available before.
> >
> >         As for LIRC not picking up the event, I would be tempted to
> >         say no, it
> >         won't help.
> >
> >         Are you certain that your LIRC is configured properly? Are you
> >         certain
> >         that your event number is the right one?
> >
> >
> >         Nico
> >
> > I believe so... in so far as I can tell... I sent an email to this
> > list about a week ago describing my problems, but there was no
> > response. (subject: Compro Videomate U500). I've copied it below:
> >
> > Hi all,
> >
> > I've still been trying to get the inluded remote with my USB DVB-T
> > Tuner working. It's a Compro Videomate U500 - it useses the dibcom
> > 7000 chipset. After upgrading to Ubuntu 8.04 (hardy) I can now see the
> > remote when I do a "cat /proc/bus/input/devices":
> >
> > I: Bus=0003 Vendor=185b Product=1e78 Version=0100
> > N: Name="IR-receiver inside an USB DVB receiver"
> > P: Phys=usb-0000:00:02.1-4/ir0
> > S: Sysfs=/devices/pci0000:00/0000 :00:02.1/usb1/1-4/input/input7
> > U: Uniq=
> > H: Handlers=kbd event7
> > B: EV=3
> > B: KEY=10afc332 2842845 0 0 0 4 80018000 2180 40000801 9e96c0 0 800200
> > ffc
>
> Weird.
>
> You went through all this, I guess:
>
>
> http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500#Remote_control
>
> And you are running a recent v4l-dvb tree, I assume.
>
> >
> > However, I get now output running irrecord:
>
> I was never too lucky with irrecord on my system, IIRC.
>
> Nico
>
Ok - just thought I'd try the patch on the latest tree and see what
happens... as expected, it put an end to the syslog flooding - but nothing
really has improved... I still see a single error line in the syslog every
time I press a key - so obviously the kernel is seeing something happen, but
deciding it's unknown and not taking it any further. Something must be wrong
with some mappings somewhere.. :S Here's the syslog output anyway - there is
one line for every key press:

Feb 20 22:07:07 matthew-desktop kernel: [38161.388548] dib0700: Unknown
remote controller key: 12 7E  1  0
Feb 20 22:07:09 matthew-desktop kernel: [38162.678839] dib0700: Unknown
remote controller key: 18 7C  1  0
Feb 20 22:07:10 matthew-desktop kernel: [38162.906413] dib0700: Unknown
remote controller key: 18 7C  1  0
Feb 20 22:07:14 matthew-desktop kernel: [38165.183338] dib0700: Unknown
remote controller key: 1C 4D  1  0
Feb 20 22:07:18 matthew-desktop kernel: [38167.156040] dib0700: Unknown
remote controller key: 1F 7D  1  0
Feb 20 22:07:21 matthew-desktop kernel: [38168.598632] dib0700: Unknown
remote controller key: 19 43  1  0

This is very annoying because it seems that polling the syslog every 150ms
might even give you something if you could work it out ;) Anyway.. any ideas
where to now...?

Cheers,

Matt

-- 
Matthew Vermeulen
http://www.matthewv.id.au/
MatthewV @ irc.freenode.net

------=_Part_9452_27095304.1203513017595
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Feb 20, 2008 4:54 PM, Nicolas Will &lt;<a href="mailto:nico@youplala.net">nico@youplala.net</a>&gt; wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div><div></div><div class="Wj3C7c"><br>On Wed, 2008-02-20 at 16:39 +0900, Matthew Vermeulen wrote:<br>&gt; On Feb 20, 2008 7:09 AM, Nicolas Will &lt;<a href="mailto:nico@youplala.net">nico@youplala.net</a>&gt; wrote:<br>
&gt;<br>&gt;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; On Wed, 2008-02-20 at 06:10 +0900, Matthew Vermeulen wrote:<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Hi all... I&#39;m seeing exactly the same problems everyone else<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; is (log<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; flooding etc) except that I can&#39;t seem to get any keys<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; picked by lirc<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; or /dev/input/event7 at all...<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Would this patch help in this case?<br>&gt;<br>&gt;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; It would help with the flooding, most probably, though there<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; was a patch<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; for that available before.<br>&gt;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; As for LIRC not picking up the event, I would be tempted to<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; say no, it<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; won&#39;t help.<br>&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Are you certain that your LIRC is configured properly? Are you<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; certain<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; that your event number is the right one?<br>&gt;<br>&gt;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; Nico<br>&gt;<br>&gt; I believe so... in so far as I can tell... I sent an email to this<br>
&gt; list about a week ago describing my problems, but there was no<br>&gt; response. (subject: Compro Videomate U500). I&#39;ve copied it below:<br>&gt;<br>&gt; Hi all,<br>&gt;<br>&gt; I&#39;ve still been trying to get the inluded remote with my USB DVB-T<br>
&gt; Tuner working. It&#39;s a Compro Videomate U500 - it useses the dibcom<br>&gt; 7000 chipset. After upgrading to Ubuntu 8.04 (hardy) I can now see the<br>&gt; remote when I do a &quot;cat /proc/bus/input/devices&quot;:<br>
&gt;<br>&gt; I: Bus=0003 Vendor=185b Product=1e78 Version=0100<br>&gt; N: Name=&quot;IR-receiver inside an USB DVB receiver&quot;<br>&gt; P: Phys=usb-0000:00:02.1-4/ir0<br>&gt; S: Sysfs=/devices/pci0000:00/0000 :00:02.1/usb1/1-4/input/input7<br>
&gt; U: Uniq=<br>&gt; H: Handlers=kbd event7<br>&gt; B: EV=3<br>&gt; B: KEY=10afc332 2842845 0 0 0 4 80018000 2180 40000801 9e96c0 0 800200<br>&gt; ffc<br><br></div></div>Weird.<br><br>You went through all this, I guess:<br>
<br><a href="http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500#Remote_control" target="_blank">http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500#Remote_control</a><br><br>And you are running a recent v4l-dvb tree, I assume.<br>
<div class="Ih2E3d"><br>&gt;<br>&gt; However, I get now output running irrecord:<br><br></div>I was never too lucky with irrecord on my system, IIRC.<br><div><div></div><div class="Wj3C7c"><br>Nico<br></div></div></blockquote>
<div>Ok - just thought I&#39;d try the patch on the latest tree and see what happens... as expected, it put an end to the syslog flooding - but nothing really has improved... I still see a single error line in the syslog every time I press a key - so obviously the kernel is seeing something happen, but deciding it&#39;s unknown and not taking it any further. Something must be wrong with some mappings somewhere.. :S Here&#39;s the syslog output anyway - there is one line for every key press:<br>
<br>Feb 20 22:07:07 matthew-desktop kernel: [38161.388548] dib0700: Unknown remote controller key: 12 7E&nbsp; 1&nbsp; 0<br>Feb 20 22:07:09 matthew-desktop kernel: [38162.678839] dib0700: Unknown remote controller key: 18 7C&nbsp; 1&nbsp; 0<br>
Feb 20 22:07:10 matthew-desktop kernel: [38162.906413] dib0700: Unknown remote controller key: 18 7C&nbsp; 1&nbsp; 0<br>Feb 20 22:07:14 matthew-desktop kernel: [38165.183338] dib0700: Unknown remote controller key: 1C 4D&nbsp; 1&nbsp; 0<br>Feb 20 22:07:18 matthew-desktop kernel: [38167.156040] dib0700: Unknown remote controller key: 1F 7D&nbsp; 1&nbsp; 0<br>
Feb 20 22:07:21 matthew-desktop kernel: [38168.598632] dib0700: Unknown remote controller key: 19 43&nbsp; 1&nbsp; 0<br><br>This is very annoying because it seems that polling the syslog every 150ms might even give you something if you could work it out ;) Anyway.. any ideas where to now...?<br>
<br>Cheers,<br><br>Matt<br></div></div><br>-- <br>Matthew Vermeulen<br><a href="http://www.matthewv.id.au/">http://www.matthewv.id.au/</a><br>MatthewV @ <a href="http://irc.freenode.net">irc.freenode.net</a>

------=_Part_9452_27095304.1203513017595--


--===============0128374561==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0128374561==--
