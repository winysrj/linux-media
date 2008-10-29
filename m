Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1KvGSU-0003GO-Qk
	for linux-dvb@linuxtv.org; Wed, 29 Oct 2008 20:11:59 +0100
Received: by qw-out-2122.google.com with SMTP id 9so96973qwb.17
	for <linux-dvb@linuxtv.org>; Wed, 29 Oct 2008 12:11:54 -0700 (PDT)
Message-ID: <c74595dc0810291211k144f4f72nbbf85b3d3b8a79aa@mail.gmail.com>
Date: Wed, 29 Oct 2008 21:11:54 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: jean-paul@goedee.nl
In-Reply-To: <20081029164747.h5xzc1hhwo0oocww@webmail.goedee.nl>
MIME-Version: 1.0
References: <20081029164747.h5xzc1hhwo0oocww@webmail.goedee.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Update: S2API , scan-s2, TT 3200_CI, VDR 1.7.0,
	Streamdev (latest version)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1925856035=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1925856035==
Content-Type: multipart/alternative;
	boundary="----=_Part_152015_23309563.1225307514726"

------=_Part_152015_23309563.1225307514726
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Please specify what was the error in scan-s2 compilation and what changeset
you've used?


On Wed, Oct 29, 2008 at 5:47 PM, <jean-paul@goedee.nl> wrote:

> S2API (drivers) latest version compile without error, Compiling
> scan-s2 give a error on DDS or something like that. Remove it from
> scan.c and compile it again.
>
> Scanning booth LNB?s (astra 1  & 3) and only normal S. Try al options
> but no S2 channels.  Compile VDR with S2API patch and streamdev
> plugin. No problem so far. Copy the new channels.conf to the vdr
> directory and start vdr. Tuning to FTA channels is no problem but
> encrypt channels are not available. For so far as I can see the caids
> are correct (verify with the caids of mij production system  (also
> 2*tt 3200 incl cam/card and multiproto/vdr 1.7.0 and off Corse
> streamdev.
>
> No S2 channels, No encrypt channels.
>
> Regards
>
> Jean-Paul
>
>
>
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_152015_23309563.1225307514726
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Please specify what was the error in scan-s2 compilation and what changeset you&#39;ve used?<br><br><br><div class="gmail_quote">On Wed, Oct 29, 2008 at 5:47 PM,  <span dir="ltr">&lt;<a href="mailto:jean-paul@goedee.nl">jean-paul@goedee.nl</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">S2API (drivers) latest version compile without error, Compiling<br>
scan-s2 give a error on DDS or something like that. Remove it from<br>
scan.c and compile it again.<br>
<br>
Scanning booth LNB?s (astra 1 &nbsp;&amp; 3) and only normal S. Try al options<br>
but no S2 channels. &nbsp;Compile VDR with S2API patch and streamdev<br>
plugin. No problem so far. Copy the new channels.conf to the vdr<br>
directory and start vdr. Tuning to FTA channels is no problem but<br>
encrypt channels are not available. For so far as I can see the caids<br>
are correct (verify with the caids of mij production system &nbsp;(also<br>
2*tt 3200 incl cam/card and multiproto/vdr 1.7.0 and off Corse<br>
streamdev.<br>
<br>
No S2 channels, No encrypt channels.<br>
<br>
Regards<br>
<br>
Jean-Paul<br>
<br>
<br>
<br>
<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br></div>

------=_Part_152015_23309563.1225307514726--


--===============1925856035==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1925856035==--
