Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1K4KVD-0003Or-7i
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 20:48:01 +0200
Received: by fk-out-0910.google.com with SMTP id f40so589582fka.1
	for <linux-dvb@linuxtv.org>; Thu, 05 Jun 2008 11:47:53 -0700 (PDT)
Message-ID: <854d46170806051147t6917ca8cm70839cda91101e0a@mail.gmail.com>
Date: Thu, 5 Jun 2008 20:47:53 +0200
From: "Faruk A" <fa@elwak.com>
To: "Stuart Morris" <stuart_morris@talk21.com>
In-Reply-To: <502885.47327.qm@web86703.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <502885.47327.qm@web86703.mail.ukl.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to get a PCTV Sat HDTC Pro USB (452e) running?
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

Hi Stuart!

I'm using the same driver on TT S2-3650 CI and vdr (v. 1.60).
I don't know if patch to the video.h is necessary but
this is what i always do, two multiproto sources one patched with
pctv45e/tt_s2_36xx for drivers only and one unpatched source for compiling
softwares like vdr...

Faruk



On Thu, Jun 5, 2008 at 6:34 PM, Stuart Morris <stuart_morris@talk21.com> wrote:
> Dominik
> Thanks for your work on the pctv452e/tts23600 driver.
> I intend to purchase a
> tt 3600 at some point soon so I have not yet used the
> driver, but I have a
> couple of comments.
>
> I have recently patched multiproto plus with the
> pctv452e/tts23600 patch set
> and noticed a problem with VDR 1.7.0.
> The patch to linux/include/linux/dvb/frontend.h
> towards the end of
> patch_multiproto_pctv452e_tts23600.diff causes a
> compile error with VDR 1.7.0.
> It's not obvious what this patch is for.
>
> There is also a patch to
> linux/include/linux/dvb/video.h. Are the patches to
> the dvb headers really necessary? Is this intentional?
>
>
>
>      __________________________________________________________
> Sent from Yahoo! Mail.
> A Smarter Email http://uk.docs.yahoo.com/nowyoucan.html
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
