Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.237])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mattvermeulen@gmail.com>) id 1JRoBv-0005tn-UJ
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 13:36:52 +0100
Received: by wx-out-0506.google.com with SMTP id s11so2133608wxc.17
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 04:36:47 -0800 (PST)
Message-ID: <950c7d180802200436s68bab78ej3eb01a93090c313f@mail.gmail.com>
Date: Wed, 20 Feb 2008 21:36:46 +0900
From: "Matthew Vermeulen" <mattvermeulen@gmail.com>
To: "Filippo Argiolas" <filippo.argiolas@gmail.com>
In-Reply-To: <1203496068.7026.19.camel@tux>
MIME-Version: 1.0
References: <1203434275.6870.25.camel@tux> <1203441662.9150.29.camel@acropora>
	<1203448799.28796.3.camel@youkaida>
	<1203449457.28796.7.camel@youkaida>
	<950c7d180802191310x5882541h61bc60195a998da4@mail.gmail.com>
	<1203495773.7026.15.camel@tux> <1203496068.7026.19.camel@tux>
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
Content-Type: multipart/mixed; boundary="===============1942749517=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1942749517==
Content-Type: multipart/alternative;
	boundary="----=_Part_9355_29976276.1203511006921"

------=_Part_9355_29976276.1203511006921
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Feb 20, 2008 5:27 PM, Filippo Argiolas <filippo.argiolas@gmail.com>
wrote:

>
> Il giorno mer, 20/02/2008 alle 09.22 +0100, Filippo Argiolas ha scritto:
> > Il giorno mer, 20/02/2008 alle 06.10 +0900, Matthew Vermeulen ha
> > scritto:
> > > Hi all... I'm seeing exactly the same problems everyone else is (log
> > > flooding etc) except that I can't seem to get any keys picked by lirc
> > > or /dev/input/event7 at all...
> >
> > Are you sure that the input device is receiving the events?
> > Did you try evtest /dev/input/event7?
> > Is LIRC properly configured?
> > Are you using this file for lircd.conf
> > [http://linux.bytesex.org/v4l2/linux-input-layer-lircd.conf]?
> > Does irw catch some event?
>
> I forgot to say to not use irrecord with dev/input driver since it's
> thinked to record raw events from remotes and doesn't work with input
> devices (usually it ends up with a lircd.conf file that interprets key
> press and release as separated events doubling each event).
> Just use the proper input-layer-lircd.conf.
>
>
I've got that file all set up, my hardware.conf for lirc is pasted below:
# /etc/lirc/hardware.conf
#
#Chosen Remote Control
REMOTE="Compro Videomate U500"
REMOTE_MODULES=""
REMOTE_DRIVER="devinput"
REMOTE_DEVICE="/dev/input/event7"
REMOTE_LIRCD_CONF="/etc/lirc/lircd.conf"
REMOTE_LIRCD_ARGS=""

#Chosen IR Transmitter
TRANSMITTER="None"
TRANSMITTER_MODULES=""
TRANSMITTER_DRIVER=""
TRANSMITTER_DEVICE=""
TRANSMITTER_LIRCD_CONF=""
TRANSMITTER_LIRCD_ARGS=""

#Enable lircd
START_LIRCD="true"

#Don't start lircmd even if there seems to be a good config file
#START_LIRCMD="false"

#Try to load appropriate kernel modules
LOAD_MODULES="true"

# Default configuration files for your hardware if any
LIRCMD_CONF=""

#Forcing noninteractive reconfiguration
#If lirc is to be reconfigured by an external application
#that doesn't have a debconf frontend available, the noninteractive
#frontend can be invoked and set to parse REMOTE and TRANSMITTER
#It will then populate all other variables without any user input
#If you would like to configure lirc via standard methods, be sure
#to leave this set to "false"
FORCE_NONINTERACTIVE_RECONFIGURATION="false"
START_LIRCMD=""

My /etc/lirc/lircd.conf contains the contents of the lircd.conf file you
linked to. Like I said previously, the only way I know the thing is seeing
keypresses is by looking at dmesg or the syslog - evtest and irw pick up
nothing, nor does xev or anything else I know to test with. I think lirc is
properly configured, insofar as i can change the device to point to my
multimedia keyboard using the devinput driver which can then be picked up by
lirc...

I do know the actual tuner is receiving the remote keypresses because of the
changes to the codes listed in syslog...

Hope this helps you (help me ;) )

Cheers,

Matt

-- 
Matthew Vermeulen
http://www.matthewv.id.au/
MatthewV @ irc.freenode.net

------=_Part_9355_29976276.1203511006921
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">On Feb 20, 2008 5:27 PM, Filippo Argiolas &lt;<a href="mailto:filippo.argiolas@gmail.com">filippo.argiolas@gmail.com</a>&gt; wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>Il giorno mer, 20/02/2008 alle 09.22 +0100, Filippo Argiolas ha scritto:<br><div class="Ih2E3d">&gt; Il giorno mer, 20/02/2008 alle 06.10 +0900, Matthew Vermeulen ha<br>&gt; scritto:<br>&gt; &gt; Hi all... I&#39;m seeing exactly the same problems everyone else is (log<br>
&gt; &gt; flooding etc) except that I can&#39;t seem to get any keys picked by lirc<br>&gt; &gt; or /dev/input/event7 at all...<br>&gt;<br>&gt; Are you sure that the input device is receiving the events?<br>&gt; Did you try evtest /dev/input/event7?<br>
&gt; Is LIRC properly configured?<br>&gt; Are you using this file for lircd.conf<br>&gt; [<a href="http://linux.bytesex.org/v4l2/linux-input-layer-lircd.conf" target="_blank">http://linux.bytesex.org/v4l2/linux-input-layer-lircd.conf</a>]?<br>
&gt; Does irw catch some event?<br><br></div>I forgot to say to not use irrecord with dev/input driver since it&#39;s<br>thinked to record raw events from remotes and doesn&#39;t work with input<br>devices (usually it ends up with a lircd.conf file that interprets key<br>
press and release as separated events doubling each event).<br>Just use the proper input-layer-lircd.conf.<br><br></blockquote></div><br>I&#39;ve got that file all set up, my hardware.conf for lirc is pasted below:<br># /etc/lirc/hardware.conf<br>
#<br>#Chosen Remote Control<br>REMOTE=&quot;Compro Videomate U500&quot;<br>REMOTE_MODULES=&quot;&quot;<br>REMOTE_DRIVER=&quot;devinput&quot;<br>REMOTE_DEVICE=&quot;/dev/input/event7&quot;<br>REMOTE_LIRCD_CONF=&quot;/etc/lirc/lircd.conf&quot;<br>
REMOTE_LIRCD_ARGS=&quot;&quot;<br><br>#Chosen IR Transmitter<br>TRANSMITTER=&quot;None&quot;<br>TRANSMITTER_MODULES=&quot;&quot;<br>TRANSMITTER_DRIVER=&quot;&quot;<br>TRANSMITTER_DEVICE=&quot;&quot;<br>TRANSMITTER_LIRCD_CONF=&quot;&quot;<br>
TRANSMITTER_LIRCD_ARGS=&quot;&quot;<br><br>#Enable lircd<br>START_LIRCD=&quot;true&quot;<br><br>#Don&#39;t start lircmd even if there seems to be a good config file<br>#START_LIRCMD=&quot;false&quot;<br><br>#Try to load appropriate kernel modules<br>
LOAD_MODULES=&quot;true&quot;<br><br># Default configuration files for your hardware if any<br>LIRCMD_CONF=&quot;&quot;<br><br>#Forcing noninteractive reconfiguration<br>#If lirc is to be reconfigured by an external application<br>
#that doesn&#39;t have a debconf frontend available, the noninteractive<br>#frontend can be invoked and set to parse REMOTE and TRANSMITTER<br>#It will then populate all other variables without any user input<br>#If you would like to configure lirc via standard methods, be sure<br>
#to leave this set to &quot;false&quot;<br>FORCE_NONINTERACTIVE_RECONFIGURATION=&quot;false&quot;<br>START_LIRCMD=&quot;&quot;<br><br>My /etc/lirc/lircd.conf contains the contents of the lircd.conf file you linked to. Like I said previously, the only way I know the thing is seeing keypresses is by looking at dmesg or the syslog - evtest and irw pick up nothing, nor does xev or anything else I know to test with. I think lirc is properly configured, insofar as i can change the device to point to my multimedia keyboard using the devinput driver which can then be picked up by lirc...<br>
<br>I do know the actual tuner is receiving the remote keypresses because of the changes to the codes listed in syslog...<br><br>Hope this helps you (help me ;) )<br><br>Cheers,<br><br>Matt<br clear="all"><br>-- <br>Matthew Vermeulen<br>
<a href="http://www.matthewv.id.au/">http://www.matthewv.id.au/</a><br>MatthewV @ <a href="http://irc.freenode.net">irc.freenode.net</a>

------=_Part_9355_29976276.1203511006921--


--===============1942749517==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1942749517==--
