Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KNnhV-00070N-IG
	for linux-dvb@linuxtv.org; Tue, 29 Jul 2008 13:49:11 +0200
Received: by ik-out-1112.google.com with SMTP id c21so5790899ika.1
	for <linux-dvb@linuxtv.org>; Tue, 29 Jul 2008 04:49:05 -0700 (PDT)
Message-ID: <412bdbff0807290449q5a225f32tecc1551b42f59046@mail.gmail.com>
Date: Tue, 29 Jul 2008 07:49:04 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Markus Rechberger" <mrechberger@gmail.com>
In-Reply-To: <d9def9db0807282259q548991cfuc5ceebd5e0aee63e@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <16121.64.213.30.2.1216781835.squirrel@webmail.exetel.com.au>
	<d9def9db0807282259q548991cfuc5ceebd5e0aee63e@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVICO firmware compatibility between v4l-dvb and
	in-tree kernel drivers
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello Markus,

On Tue, Jul 29, 2008 at 1:59 AM, Markus Rechberger
> I'm just curious is there an xc3028L used within that device or the normal one?

I know the XC3028L is pin compatible with the XC3028, but did they
change the revision number of the part as returned in register 0x04?
I haven't had a chance to look at any devices with the 3028L, but If
they did change the revision (such as from v1.0 to 1.1), then it would
be very easy to change the tuner_dbg() line to report it as an XC3028L
as opposed to just an XC3028 (making it easier for users to tell us in
the future).

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
