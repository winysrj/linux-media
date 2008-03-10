Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [66.249.82.230] (helo=wx-out-0506.google.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <derk.dukker@gmail.com>) id 1JYgqP-0004Yx-Gu
	for linux-dvb@linuxtv.org; Mon, 10 Mar 2008 13:11:16 +0100
Received: by wx-out-0506.google.com with SMTP id s11so1661602wxc.17
	for <linux-dvb@linuxtv.org>; Mon, 10 Mar 2008 05:06:21 -0700 (PDT)
Message-ID: <e2d627830803100459k7d0eddd4lcfa97013767a6ec7@mail.gmail.com>
Date: Mon, 10 Mar 2008 12:59:55 +0100
From: "Derk Dukker" <derk.dukker@gmail.com>
To: "Tero Pelander" <tpeland@tkukoulu.fi>
In-Reply-To: <20080310111710.GA27766@tkukoulu.fi>
MIME-Version: 1.0
References: <20080310111710.GA27766@tkukoulu.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] illegal bandwith value,
	driver for Terratec Cinergy DT usb XS
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0616483573=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0616483573==
Content-Type: multipart/alternative;
	boundary="----=_Part_17584_14176333.1205150395857"

------=_Part_17584_14176333.1205150395857
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Tero,

I also have a Terratec Cinergy DT XS diversity but can't get it working with
the Cinergy CI usb, do you have any idea how I can make it work?
By the way, they showed on CEBIT a EeePC with linux on it with the Cinergy
XSS. They also said that they will release linux drivers for all of their tv
tuners.

Regards

On Mon, Mar 10, 2008 at 12:17 PM, Tero Pelander <tpeland@tkukoulu.fi> wrote:

> The driver in linux kernel 2.6.24.2 for "Terratec Cinergy DT usb XS
> diversity" sets the reported bandwith outside the fe_bandwidth_t range.
> The value 0 (BANDWIDTH_8_MHZ) is replaced with 8000. Here is an example
> showing the problem...
>
> Device: Terratec Cinergy DT usb xs diversity
> Linux: 2.6.24.2 (modules: mt2266, dvb_usb_dib0700)
> Firmware: dvb-usb-dib0700-1.10.fw
>
>
> Received event for frontend 0
>
> Status for frontend 0 is now:
>   0 (no signal)
>
> Reported parameters for frontend 0 are now:
>   Frequency: 714000000 Hz
>   Inversion: AUTO (2)
>   Bandwidth: 8 (0)
>   High priority stream code rate: AUTO (9)
>   Low priority stream code rate: AUTO (9)
>   Constellation: QAM64 (3)
>   Transmission mode: AUTO (2)
>   Guard interval: AUTO (4)
>   Hierarchy information: AUTO (4)
>
> Received event for frontend 0
>
> Status for frontend 0 is now:
>   FE_HAS_SIGNAL (found something above the noise level)
>   FE_HAS_CARRIER (found a DVB signal)
>   FE_HAS_VITERBI (FEC is stable)
>   FE_HAS_SYNC (found sync bytes)
>   FE_HAS_LOCK (everything's working)
>
> Reported parameters for frontend 0 are now:
>   Frequency: 714000000 Hz
>   Inversion: AUTO (2)
>   Bandwidth: ??? (8000)
>   High priority stream code rate: 2/3 (2)
>   Low priority stream code rate: 1/2 (1)
>   Constellation: QAM64 (3)
>   Transmission mode: 8K (1)
>   Guard interval: 1/8 (2)
>   Hierarchy information: NONE (0)
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_17584_14176333.1205150395857
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Tero,<br><br>I also have a Terratec Cinergy DT XS diversity but can&#39;t get it working with the Cinergy CI usb, do you have any idea how I can make it work?<br>By the way, they showed on CEBIT a EeePC with linux on it with the Cinergy XSS. They also said that they will release linux drivers for all of their tv tuners. <br>
<br>Regards<br><br><div class="gmail_quote">On Mon, Mar 10, 2008 at 12:17 PM, Tero Pelander &lt;<a href="mailto:tpeland@tkukoulu.fi">tpeland@tkukoulu.fi</a>&gt; wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
The driver in linux kernel <a href="http://2.6.24.2" target="_blank">2.6.24.2</a> for &quot;Terratec Cinergy DT usb XS<br>
diversity&quot; sets the reported bandwith outside the fe_bandwidth_t range.<br>
The value 0 (BANDWIDTH_8_MHZ) is replaced with 8000. Here is an example<br>
showing the problem...<br>
<br>
Device: Terratec Cinergy DT usb xs diversity<br>
Linux: <a href="http://2.6.24.2" target="_blank">2.6.24.2</a> (modules: mt2266, dvb_usb_dib0700)<br>
Firmware: dvb-usb-dib0700-1.10.fw<br>
<br>
<br>
Received event for frontend 0<br>
<br>
Status for frontend 0 is now:<br>
 &nbsp; 0 (no signal)<br>
<br>
Reported parameters for frontend 0 are now:<br>
 &nbsp; Frequency: 714000000 Hz<br>
 &nbsp; Inversion: AUTO (2)<br>
 &nbsp; Bandwidth: 8 (0)<br>
 &nbsp; High priority stream code rate: AUTO (9)<br>
 &nbsp; Low priority stream code rate: AUTO (9)<br>
 &nbsp; Constellation: QAM64 (3)<br>
 &nbsp; Transmission mode: AUTO (2)<br>
 &nbsp; Guard interval: AUTO (4)<br>
 &nbsp; Hierarchy information: AUTO (4)<br>
<br>
Received event for frontend 0<br>
<br>
Status for frontend 0 is now:<br>
 &nbsp; FE_HAS_SIGNAL (found something above the noise level)<br>
 &nbsp; FE_HAS_CARRIER (found a DVB signal)<br>
 &nbsp; FE_HAS_VITERBI (FEC is stable)<br>
 &nbsp; FE_HAS_SYNC (found sync bytes)<br>
 &nbsp; FE_HAS_LOCK (everything&#39;s working)<br>
<br>
Reported parameters for frontend 0 are now:<br>
 &nbsp; Frequency: 714000000 Hz<br>
 &nbsp; Inversion: AUTO (2)<br>
 &nbsp; Bandwidth: ??? (8000)<br>
 &nbsp; High priority stream code rate: 2/3 (2)<br>
 &nbsp; Low priority stream code rate: 1/2 (1)<br>
 &nbsp; Constellation: QAM64 (3)<br>
 &nbsp; Transmission mode: 8K (1)<br>
 &nbsp; Guard interval: 1/8 (2)<br>
 &nbsp; Hierarchy information: NONE (0)<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br>

------=_Part_17584_14176333.1205150395857--


--===============0616483573==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0616483573==--
