Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.229])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ian.bonham@gmail.com>) id 1JTxqv-0003ng-TO
	for linux-dvb@linuxtv.org; Tue, 26 Feb 2008 12:20:06 +0100
Received: by wx-out-0506.google.com with SMTP id s11so2202015wxc.17
	for <linux-dvb@linuxtv.org>; Tue, 26 Feb 2008 03:19:58 -0800 (PST)
Message-ID: <2f8cbffc0802260319s76e8b82geb56a3f842539844@mail.gmail.com>
Date: Tue, 26 Feb 2008 12:19:57 +0100
From: "Ian Bonham" <ian.bonham@gmail.com>
To: "Craig Whitmore" <lennon@orcon.net.nz>
In-Reply-To: <747784AF573B4316BB5944669524B302@CraigPC>
MIME-Version: 1.0
References: <2f8cbffc0802230359w2922f888s90ac43fcb68ad406@mail.gmail.com>
	<747784AF573B4316BB5944669524B302@CraigPC>
Cc: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] HVR4000 Update?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1073373688=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1073373688==
Content-Type: multipart/alternative;
	boundary="----=_Part_13653_19309190.1204024797856"

------=_Part_13653_19309190.1204024797856
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Craig,

Thanks for that, after some tinkering about and being able to read that site
I've got DVB-S and DVB-T working on the HVR4000. I've not been able to tune
any DVB-S2, but am working mainly with Myth, so not sure whats required for
S2 with that.

To get DVB-S and DVB-T working in Myth, I had my frontend0 and frontend1
showing in /dev/dvb/adapter0. I created a folder /dev/dvb/adatper1 and
linked frontend0 (and the dvb, net and demux) in that folder into
/dev/dvb/adapter0/frontend1 and so on. That got me around Myth being unable
to handle multifrontends (I'm using Ubuntu feeds, building Myth from source
and patching is a job I'd need a spare weekend for!). I was able to set up
dvb cards and access the types happily that way.

The only thing with Myth that's maybe important to note is you must switch
off EIT scanning. I did not realise this at first and watching DVB-S
channels, every 10 minutes or so Myth would crash. Watching the backend log,
I saw the EIT scan kicking in and trying to access the DVB-T tuner whilst I
was watching the DVB-S channels. Obviously this caused a conflict, so by
turning off EIT scan I've had no problems since.

Hope that helps someone else struggling, and thanks for your pointers Craig,

Ian


On 23/02/2008, Craig Whitmore <lennon@orcon.net.nz> wrote:
>
> > Can anyone please make a clear guide on what I should do to get my HVR4k
> > going properly with Myth? If I can't get things going 'properly' just
> > being able
>   > to help beta stuff would be good. What SVN do I need to check-out?
> What
> patches do I need to apply? What Myth do I need to check out? Then what
> > patches does that need?
>
>
> If you check
> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000
> there are links how to get:
>
> - Single Frontend (Either DVB-S or DVB-T)
> - Multi Frontend Going (DVB-S and DVB-T)
> - Multi Proto Going (DVB-S/S2 or DVB-T)
> - Multi Proto with Multi Frontends (DVB-S/S2 and DVB-T)
> ..
> Thanks
>
>

------=_Part_13653_19309190.1204024797856
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Craig,<br><br>Thanks for that, after some tinkering about and being able to read that site I&#39;ve got DVB-S and DVB-T working on the HVR4000. I&#39;ve not been able to tune any DVB-S2, but am working mainly with Myth, so not sure whats required for S2 with that.<br>
<br>To get DVB-S and DVB-T working in Myth, I had my frontend0 and frontend1 showing in /dev/dvb/adapter0. I created a folder /dev/dvb/adatper1 and linked frontend0 (and the dvb, net and demux) in that folder into /dev/dvb/adapter0/frontend1 and so on. That got me around Myth being unable to handle multifrontends (I&#39;m using Ubuntu feeds, building Myth from source and patching is a job I&#39;d need a spare weekend for!). I was able to set up dvb cards and access the types happily that way. <br>
<br>The only thing with Myth that&#39;s maybe important to note is you must switch off EIT scanning. I did not realise this at first and watching DVB-S channels, every 10 minutes or so Myth would crash. Watching the backend log, I saw the EIT scan kicking in and trying to access the DVB-T tuner whilst I was watching the DVB-S channels. Obviously this caused a conflict, so by turning off EIT scan I&#39;ve had no problems since.<br>
<br>Hope that helps someone else struggling, and thanks for your pointers Craig,<br><br>Ian<br><br><br><div><span class="gmail_quote">On 23/02/2008, <b class="gmail_sendername">Craig Whitmore</b> &lt;<a href="mailto:lennon@orcon.net.nz">lennon@orcon.net.nz</a>&gt; wrote:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
&gt; Can anyone please make a clear guide on what I should do to get my HVR4k<br> &gt; going properly with Myth? If I can&#39;t get things going &#39;properly&#39; just<br> &gt; being able<br>&nbsp;&nbsp;&gt; to help beta stuff would be good. What SVN do I need to check-out? What<br>
 patches do I need to apply? What Myth do I need to check out? Then what<br> &gt; patches does that need?<br> <br> <br>If you check <a href="http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000">http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000</a><br>
 there are links how to get:<br> <br> - Single Frontend (Either DVB-S or DVB-T)<br> - Multi Frontend Going (DVB-S and DVB-T)<br> - Multi Proto Going (DVB-S/S2 or DVB-T)<br> - Multi Proto with Multi Frontends (DVB-S/S2 and DVB-T)<br>
 ..<br> Thanks<br> <br> </blockquote></div><br>

------=_Part_13653_19309190.1204024797856--


--===============1073373688==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1073373688==--
