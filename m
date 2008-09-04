Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <glenn.l.mcgrath@gmail.com>) id 1Kb70z-0006K7-EM
	for linux-dvb@linuxtv.org; Thu, 04 Sep 2008 07:04:22 +0200
Received: by ti-out-0910.google.com with SMTP id w7so2078630tib.13
	for <linux-dvb@linuxtv.org>; Wed, 03 Sep 2008 22:04:12 -0700 (PDT)
Message-ID: <141058d50809032204o7b8a70d9jc3fa64b4e2f9ef3@mail.gmail.com>
Date: Thu, 4 Sep 2008 15:04:11 +1000
From: "Glenn McGrath" <glenn.l.mcgrath@gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <48BE98CC.1080600@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <141058d50809030655i680f7937o3aa657601d1910a0@mail.gmail.com>
	<48BE98CC.1080600@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fine tuning app ?
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

On Thu, Sep 4, 2008 at 12:01 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> Glenn McGrath wrote:
>> It would be really useful to have a fine tuning app that can use a
>> table of hard coded frequency values  for different countries and fine
>> tune it until the error rate is minimal.
>
> w_scan -- http://wirbel.htpc-forum.de/
>
> ...now with ATSC / QAM Annex-B tuning support!

I didnt realise w_scan did fine tuning... ill try and describe my
situation some more.

First off, w_scan didnt find any channels, i realised it was looking
at the wrong frequencies, so i modified w_scan to check the center
frequency specified by Australian (where i live) regulations, w_scan
only found 1 or 5 station.

I did a lot of digging and found i need to check somewhere within
125kHz of the center frequency (usually center +125kHz is best), if i
just check the center frequency my tv card doesnt even get a lock.

A nice piece of info i found from
http://www.acma.gov.au/webwr/_assets/main/lib100059/geninfo.pdf
---
The centre frequency of the digital television channel is shown in the
service listings in this
book. It should be noted that for implementation reasons, broadcasters
may choose to operate
with a +/- 125 kHz offset from the nominal channel centre frequency.
---

I am still confused about w_scan vs scan, if i do w_scan -x and then
use scan, is scan supposed to do some fine tuning ?  I so see it
trying different frequencies (sometimes very strange frequencies), no
quite sure whats going on.

Also, is this the best place to talk about w_scan or is there a
specific project list ?


Thanks

Glenn

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
