Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1KvPAC-0007W3-Sr
	for linux-dvb@linuxtv.org; Thu, 30 Oct 2008 05:29:41 +0100
Received: by qw-out-2122.google.com with SMTP id 9so224054qwb.17
	for <linux-dvb@linuxtv.org>; Wed, 29 Oct 2008 21:29:36 -0700 (PDT)
Message-ID: <c74595dc0810292129r970c428s79c5fe03492a1c73@mail.gmail.com>
Date: Thu, 30 Oct 2008 06:29:35 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Mika Laitio" <lamikr@pilppa.org>
In-Reply-To: <Pine.LNX.4.64.0810292320260.13931@shogun.pilppa.org>
MIME-Version: 1.0
References: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
	<Pine.LNX.4.64.0810291745410.13299@shogun.pilppa.org>
	<c74595dc0810291219i520e3e9fv1769374f2e61a6de@mail.gmail.com>
	<Pine.LNX.4.64.0810292320260.13931@shogun.pilppa.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1162701188=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1162701188==
Content-Type: multipart/alternative;
	boundary="----=_Part_3876_2403438.1225340976001"

------=_Part_3876_2403438.1225340976001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Oct 29, 2008 at 11:27 PM, Mika Laitio <lamikr@pilppa.org> wrote:

> I'm not aware of dvb-apps that use S2API, can you point me to that version?
>>
>
> I meant that because S2API drivers are backward compatible and supports
> also the older driver API, the old apps works also with S2API version of
> drivers.

Ok. I didn't know that.


 S2 channels are found with old scan version using mantis driver as well.
> The output of scan-s2 is a bit different to support S2, there are few more
> parameters that will appear in the output such as:
> Sx - used delivery system
> Mx - modulation
> Rx - rolloff
> Cx - FEC rate
>
> Some of those are not yet ready, but I'm adding them right now.
> The frequencies files will be also extended to support those parameters as
> inputs.
>

Ok. Do you have time to add to README some words listing the names and order
> for all parameters that scan-s2 requires to be in the input files. That
> would be very helpful, when one later try to add information from other
> satellite frequencies to those files.
>
I will as soon as I'll add support of new input.


>
> Mika
>

------=_Part_3876_2403438.1225340976001
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">On Wed, Oct 29, 2008 at 11:27 PM, Mika Laitio <span dir="ltr">&lt;<a href="mailto:lamikr@pilppa.org">lamikr@pilppa.org</a>&gt;</span> wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
I&#39;m not aware of dvb-apps that use S2API, can you point me to that version?<br>
</blockquote>
<br></div>
I meant that because S2API drivers are backward compatible and supports also the older driver API, the old apps works also with S2API version of drivers.</blockquote><div class="Ih2E3d">Ok. I didn&#39;t know that.<br>&nbsp;<br>

<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
S2 channels are found with old scan version using mantis driver as well.<br>
The output of scan-s2 is a bit different to support S2, there are few more<br>
parameters that will appear in the output such as:<br>
Sx - used delivery system<br>
Mx - modulation<br>
Rx - rolloff<br>
Cx - FEC rate<br>
<br>
Some of those are not yet ready, but I&#39;m adding them right now.<br>
The frequencies files will be also extended to support those parameters as<br>
inputs.<br>
</blockquote>
<br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Ok. Do you have time to add to README some words listing the names and order for all parameters that scan-s2 requires to be in the input files. That would be very helpful, when one later try to add information from other satellite frequencies to those files.<br>
<font color="#888888">
</font></blockquote><div>I will as soon as I&#39;ll add support of new input.<br>&nbsp;<br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<font color="#888888"><br>
Mika<br>
</font></blockquote></div><br></div>

------=_Part_3876_2403438.1225340976001--


--===============1162701188==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1162701188==--
