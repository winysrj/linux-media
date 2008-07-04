Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1KEe7I-0004qU-Mm
	for linux-dvb@linuxtv.org; Fri, 04 Jul 2008 07:46:00 +0200
Message-ID: <486DB90D.2030200@iinet.net.au>
Date: Fri, 04 Jul 2008 13:45:49 +0800
From: timf <timf@iinet.net.au>
MIME-Version: 1.0
To: "George, Tom \(RTIO\)" <Tom.George@riotinto.com>
References: <C74607610AB6D64794BA3820A9567DA705A6C81A@sbscpex06.corp.riotinto.org>
In-Reply-To: <C74607610AB6D64794BA3820A9567DA705A6C81A@sbscpex06.corp.riotinto.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvb_usb_dib0700 tuning problems?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

George, Tom (RTIO) wrote:
<snip>
>
>
> root@jaws:/home/tom# scan -a 1 =

> /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Perth
>
> Anyone got an idea what is going on here???????
>
> CHeers,
>
> Tom
>
> Tom George
>
> RTIO WA Demand Coordinator =96 Office of the CIO
>
> Rio Tinto
>
> Central Park, 152 - 158 St Georges Terrace, Perth, 6000, Western Australia
>
> T: +61 (9) 8 94247251 M: +61 (0) 417940173 F: +61 (0) 8 9327 2456
>
> Tom.george@riotinto.com http://www.riotinto.com
>
> This email (including all attachments) is the sole property of Rio =

> Tinto Limited and may be confidential. If you are not the intended =

> recipient, you must not use or forward the information contained in =

> it. This message may not be reproduced or otherwise republished =

> without the written consent of the sender. If you have received this =

> message in error, please delete the e-mail and notify the sender.
> ------------------------------------------------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
Hi Tom,

I just tried:

scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Perth

and scan without -a 1 works fine.

(Tuned all channels)

Regards,
Tim

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
