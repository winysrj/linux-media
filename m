Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1KvGZM-00046U-Gi
	for linux-dvb@linuxtv.org; Wed, 29 Oct 2008 20:19:05 +0100
Received: by qw-out-2122.google.com with SMTP id 9so99440qwb.17
	for <linux-dvb@linuxtv.org>; Wed, 29 Oct 2008 12:19:00 -0700 (PDT)
Message-ID: <c74595dc0810291219i520e3e9fv1769374f2e61a6de@mail.gmail.com>
Date: Wed, 29 Oct 2008 21:19:00 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Mika Laitio" <lamikr@pilppa.org>
In-Reply-To: <Pine.LNX.4.64.0810291745410.13299@shogun.pilppa.org>
MIME-Version: 1.0
References: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
	<Pine.LNX.4.64.0810291745410.13299@shogun.pilppa.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1891535866=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1891535866==
Content-Type: multipart/alternative;
	boundary="----=_Part_152227_25668061.1225307940188"

------=_Part_152227_25668061.1225307940188
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I'm not aware of dvb-apps that use S2API, can you point me to that version?

S2 channels are found with old scan version using mantis driver as well.
The output of scan-s2 is a bit different to support S2, there are few more
parameters that will appear in the output such as:
Sx - used delivery system
Mx - modulation
Rx - rolloff
Cx - FEC rate

Some of those are not yet ready, but I'm adding them right now.
The frequencies files will be also extended to support those parameters as
inputs.

scan-s2 I've posted also includes uncommitted diseqc support that allows to
work with more than 4 LNBs.


On Wed, Oct 29, 2008 at 5:51 PM, Mika Laitio <lamikr@pilppa.org> wrote:

> Hello all,
>>
>> I've setup the http://mercurial.intuxication.org/hg/scan-s2/ repository
>> with
>> scan utility ported to work with Igor's S2API driver.
>> Driver is available here:
>> http://mercurial.intuxication.org/hg/s2-liplianin/
>>
>
> Hi
>
> Sorry for a stupid question but as also the dv-apps version of scan and
> szap seems to work with S2API due to api's backward compatibility,
> is the finding and locking of of S2 channels the "new" features that are
> visible for the end users?
>
> I mean is the output of scan and scan-2 commands for example the same?
>
> Mika
>

------=_Part_152227_25668061.1225307940188
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">I&#39;m not aware of dvb-apps that use S2API, can you point me to that version?<br><br>S2 channels are found with old scan version using mantis driver as well.<br>The output of scan-s2 is a bit different to support S2, there are few more parameters that will appear in the output such as:<br>
Sx - used delivery system<br>Mx - modulation<br>Rx - rolloff<br>Cx - FEC rate<br><br>Some of those are not yet ready, but I&#39;m adding them right now.<br>The frequencies files will be also extended to support those parameters as inputs.<br>
<br>scan-s2 I&#39;ve posted also includes uncommitted diseqc support that allows to work with more than 4 LNBs.<br><br><br><div class="gmail_quote">On Wed, Oct 29, 2008 at 5:51 PM, Mika Laitio <span dir="ltr">&lt;<a href="mailto:lamikr@pilppa.org">lamikr@pilppa.org</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class="Ih2E3d"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">

Hello all,<br>
<br>
I&#39;ve setup the <a href="http://mercurial.intuxication.org/hg/scan-s2/" target="_blank">http://mercurial.intuxication.org/hg/scan-s2/</a> repository with<br>
scan utility ported to work with Igor&#39;s S2API driver.<br>
Driver is available here: <a href="http://mercurial.intuxication.org/hg/s2-liplianin/" target="_blank">http://mercurial.intuxication.org/hg/s2-liplianin/</a><br>
</blockquote>
<br></div>
Hi<br>
<br>
Sorry for a stupid question but as also the dv-apps version of scan and szap seems to work with S2API due to api&#39;s backward compatibility,<br>
is the finding and locking of of S2 channels the &quot;new&quot; features that are visible for the end users?<br>
<br>
I mean is the output of scan and scan-2 commands for example the same?<br><font color="#888888">
<br>
Mika<br>
</font></blockquote></div><br></div>

------=_Part_152227_25668061.1225307940188--


--===============1891535866==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1891535866==--
