Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <amitay@gmail.com>) id 1Jnrbo-00082g-B8
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 10:42:51 +0200
Received: by yw-out-2324.google.com with SMTP id 5so943564ywh.41
	for <linux-dvb@linuxtv.org>; Mon, 21 Apr 2008 01:42:40 -0700 (PDT)
Message-ID: <75a6c8000804210142h46304ce0w126f465bef458a0f@mail.gmail.com>
Date: Mon, 21 Apr 2008 18:42:39 +1000
From: "Amitay Isaacs" <amitay@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <919241.88594.qm@web55605.mail.re4.yahoo.com>
MIME-Version: 1.0
References: <919241.88594.qm@web55605.mail.re4.yahoo.com>
Subject: Re: [linux-dvb] HVR1200 / HVR1700 / TDA10048 support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0189115796=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0189115796==
Content-Type: multipart/alternative;
	boundary="----=_Part_7378_18523019.1208767359975"

------=_Part_7378_18523019.1208767359975
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Trevor,

I have the skeleton driver code ready. The driver calls tda10048_attach()
and I am
getting tda10048_readreg error (ret == -5). I need to find the demodulator
I2C address
for TDA10048 on DTV1000S board.

Is there any way to find out the demod_address?

Amitay.

On Mon, Apr 21, 2008 at 3:54 PM, Trevor Boon <trevor_boon@yahoo.com> wrote:

> Hi Amitay,
>
> Although, this is just speculation, the pcb label is
> lr6655 which, afaik, is a Lifeview model code?
>
> I've had a look at the driver inf file (lr6655.inf)
> and can only see three files being used:
>
> 3xHybrid.sys
> NXPMV32.dll
> (34CoInstaller.dll) is remarked out in the lr6655.inf
>
> I can also see 'Proteus' reference board being listed
> in the driver .inf file. Does this help?
>
>

------=_Part_7378_18523019.1208767359975
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Trevor,<br><br>I have the skeleton driver code ready. The driver calls tda10048_attach() and I am <br>getting tda10048_readreg error (ret == -5). I need to find the demodulator I2C address<br>for TDA10048 on DTV1000S board. <br>
<br>Is there any way to find out the demod_address?<br><br>Amitay.<br><br><div class="gmail_quote">On Mon, Apr 21, 2008 at 3:54 PM, Trevor Boon &lt;<a href="mailto:trevor_boon@yahoo.com">trevor_boon@yahoo.com</a>&gt; wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hi Amitay,<br>
<br>
Although, this is just speculation, the pcb label is<br>
lr6655 which, afaik, is a Lifeview model code?<br>
<br>
I&#39;ve had a look at the driver inf file (lr6655.inf)<br>
and can only see three files being used:<br>
<br>
3xHybrid.sys<br>
NXPMV32.dll<br>
(34CoInstaller.dll) is remarked out in the lr6655.inf<br>
<br>
I can also see &#39;Proteus&#39; reference board being listed<br>
in the driver .inf file. Does this help?<br>
<br></blockquote></div>

------=_Part_7378_18523019.1208767359975--


--===============0189115796==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0189115796==--
