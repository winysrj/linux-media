Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KTj9D-0001Yg-40
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 22:10:16 +0200
Received: by nf-out-0910.google.com with SMTP id g13so808831nfb.11
	for <linux-dvb@linuxtv.org>; Thu, 14 Aug 2008 13:10:11 -0700 (PDT)
Message-ID: <412bdbff0808141310o443794e1v54baccb33e2ae6b1@mail.gmail.com>
Date: Thu, 14 Aug 2008 16:10:11 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Nicolas Will" <nico@youplala.net>
In-Reply-To: <1218743866.8654.2.camel@youkaida>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0808141157t241748b4n5d82b15fcbc18d4a@mail.gmail.com>
	<1218743866.8654.2.camel@youkaida>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Possible bug in dib0700_core.c i2c transfer function
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

On Thu, Aug 14, 2008 at 3:57 PM, Nicolas Will <nico@youplala.net> wrote:
> I cannot code or really understand the details, but could this explain
> the more or less regular i2c read failures or even write failures
> eventually leading to device lock-ups that we are still experiencing if
> we are a bit too agressive?

In regards to i2c and the dib0700, I am actually debugging two
independent issues.  One is the behavior I described above, where I
can clearly see i2c read requests being turned into i2c writes.  The
second is what I would describe as "intermittent i2c read and write
failures", where the dib0700 is returning "-32" to the request.

For example (taken from a USB bus capture attempt to set the xc5000
signal source via the dib0700):

d3cd8b00 1554060054 S Co:8:109:0 s 40 03 0000 0000 0006 6 = 03c8000d 0000
d3cd8b00 1554061321 C Co:8:109:0 -32 6 >

I figured I would start with the issue that seems pretty well
understood and reproducible before I start talking about the
flaky/intermittent i2c read/write failures.  Unfortunately I don't
have an i2c bus analyzer which would be useful to better understand
whether this is a failure in the dib0700, or whether the request is
being passed through to the xc5000 and the xc5000 is reporting the
failure.  Without the dib0700 datasheet, I don't know what the status
code means...

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
