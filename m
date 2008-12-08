Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L9mqb-0005ul-7M
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 21:36:54 +0100
Received: by qyk9 with SMTP id 9so1302333qyk.17
	for <linux-dvb@linuxtv.org>; Mon, 08 Dec 2008 12:36:17 -0800 (PST)
Message-ID: <c74595dc0812081236v4917e57fq7afc854cd63c4dc4@mail.gmail.com>
Date: Mon, 8 Dec 2008 22:36:17 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: e9hack <e9hack@googlemail.com>
In-Reply-To: <493D81DF.4010601@googlemail.com>
MIME-Version: 1.0
References: <492168D8.4050900@googlemail.com>
	<c74595dc0812020849p4d779677ge468871489e7d44@mail.gmail.com>
	<49358FE8.9020701@googlemail.com>
	<c74595dc0812021205x22936540w9ce74549f07339ff@mail.gmail.com>
	<4935B1B3.40709@googlemail.com>
	<c74595dc0812022323w1df844cegc0c0ef269babed66@mail.gmail.com>
	<4936BE27.10800@googlemail.com>
	<9ac6f40e0812031104q1b3a419ub5c1a58d19f96239@mail.gmail.com>
	<c74595dc0812031328i32bc9997t632e0f63a8849b03@mail.gmail.com>
	<493D81DF.4010601@googlemail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH]Fix a bug in scan,
	which outputs the wrong frequency if the current tuned transponder
	is scanned only
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0214966419=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0214966419==
Content-Type: multipart/alternative;
	boundary="----=_Part_54180_10257130.1228768577097"

------=_Part_54180_10257130.1228768577097
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, Dec 8, 2008 at 10:21 PM, e9hack <e9hack@googlemail.com> wrote:

> Alex Betis schrieb:
>
> > There is no need for NIT message. I've added query from driver for
> currently
> > tuned parameters - should work for DVB-T and DVB-C users. DVB-S/S2 will
> get
> > IF frequency, which is not the real transponder frequency.
> > Please update to latest version.
> > Your other patch for DVB-C scan is also there.
> >
> > Let me know if it helps.
> >
>
> It works with the stv0297 and the tda10021 frontend. If the transponder was
> tuned with the
> modulation QAM_AUTO, it would be better to read the current modulation from
> the frontend.

All the tuned parameters are read from the frontend, the problem is that the
frontend returns the values that were used to tune, not the real tuned
values, so if tuning was done with QAM_AUTO, scan-s2 output will not include
modulation since frontend returned QAM_AUTO.


> Currently, QAM_AUTO isn't implemented for a DVB-C frontend, but I'm working
> on an
> implementation for the stv0297.
>
> Regards,
> Hartmut
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_54180_10257130.1228768577097
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">On Mon, Dec 8, 2008 at 10:21 PM, e9hack <span dir="ltr">&lt;<a href="mailto:e9hack@googlemail.com">e9hack@googlemail.com</a>&gt;</span> wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Alex Betis schrieb:<br>
<div class="Ih2E3d"><br>
&gt; There is no need for NIT message. I&#39;ve added query from driver for currently<br>
&gt; tuned parameters - should work for DVB-T and DVB-C users. DVB-S/S2 will get<br>
&gt; IF frequency, which is not the real transponder frequency.<br>
&gt; Please update to latest version.<br>
&gt; Your other patch for DVB-C scan is also there.<br>
&gt;<br>
&gt; Let me know if it helps.<br>
&gt;<br>
<br>
</div>It works with the stv0297 and the tda10021 frontend. If the transponder was tuned with the<br>
modulation QAM_AUTO, it would be better to read the current modulation from the frontend.</blockquote><div>All the tuned parameters are read from the frontend, the problem is that the frontend returns the values that were used to tune, not the real tuned values, so if tuning was done with QAM_AUTO, scan-s2 output will not include modulation since frontend returned QAM_AUTO.<br>
<br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
Currently, QAM_AUTO isn&#39;t implemented for a DVB-C frontend, but I&#39;m working on an<br>
implementation for the stv0297.<br>
<div><div></div><div class="Wj3C7c"><br>
Regards,<br>
Hartmut<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br></div>

------=_Part_54180_10257130.1228768577097--


--===============0214966419==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0214966419==--
