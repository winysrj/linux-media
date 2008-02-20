Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.178])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1JRjXO-0002iv-0P
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 08:38:42 +0100
Received: by wa-out-1112.google.com with SMTP id m28so3776998wag.13
	for <linux-dvb@linuxtv.org>; Tue, 19 Feb 2008 23:38:36 -0800 (PST)
Message-ID: <8ad9209c0802192338v66cfb4c4n42d733629421fe6c@mail.gmail.com>
Date: Wed, 20 Feb 2008 08:38:36 +0100
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1203458171.8019.20.camel@anden.nu>
MIME-Version: 1.0
Content-Disposition: inline
References: <8ad9209c0802111207t51e82a3eg53cf93c0bda0515b@mail.gmail.com>
	<1202762738.8087.8.camel@youkaida> <1203458171.8019.20.camel@anden.nu>
Subject: Re: [linux-dvb] Very quiet around Nova-T 500
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On 2/19/08, Jonas Anden <jonas@anden.nu> wrote:
> > > There is not a lot being said about the Nova-T 500 the last week.
> > > Don=B4t know if that is a good (coders coding) or a bad (nothin
> > > happening)
> >
> > Or coders busy on other code, or coders who ran out of ideas, or coders
> > enjoying life, etc.
>
> ..or just waiting for the problem to reappear ;( The trouble with the
> second tuner dying is tricky (for me) to isolate.
>
> As a workaround, enabling full debug (debug=3D15) on the dvb_usb_dib0700
> module has made my system rock solid. I turned on debugging to try to
> isolate the issue, but with debugging enabled the problem does not
> appear (at least not on my system).
>
> I haven't really figured out *what* in the debug code is helping yet,
> but I still suspect that this is timing-related and the debug code
> simply slows things down a bit. Enabling debugging will put a whole lot
> of "junk" in your system log files, but at least the second tuner wont
> die on you. If you go this path, make sure your log rotation works as it
> should -- my weekly rotated logs are up to 130 MB in size ;)
>
>  // J
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Could someone that knows what they are doing document that option on the wi=
ki ?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
