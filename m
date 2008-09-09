Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.234])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KdAXk-0003g9-R4
	for linux-dvb@linuxtv.org; Tue, 09 Sep 2008 23:14:38 +0200
Received: by wx-out-0506.google.com with SMTP id t16so703358wxc.17
	for <linux-dvb@linuxtv.org>; Tue, 09 Sep 2008 14:14:32 -0700 (PDT)
Message-ID: <d9def9db0809091414t5953e696s521aa2f7525d182d@mail.gmail.com>
Date: Tue, 9 Sep 2008 23:14:31 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Simon Kenyon" <simon@koala.ie>
In-Reply-To: <1220993974.17270.22.camel@localhost>
MIME-Version: 1.0
Content-Disposition: inline
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<48C66829.1010902@grumpydevil.homelinux.org>
	<d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
	<1220993974.17270.22.camel@localhost>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

On Tue, Sep 9, 2008 at 10:59 PM, Simon Kenyon <simon@koala.ie> wrote:
> On Tue, 2008-09-09 at 17:33 +0200, Markus Rechberger wrote:
>> As from my side I have to write it was a good move for the em28xx to
>> make it independent especially
>> since business customers use the improved version now and don't have
>> to fear any uncoordinated
>> breakage.
>
> as i said before (and to which you did not respond), this may be good
> for you, but it is not good for the rest of us.

You seem to forget that some developers broke kernel modules which the
em28xx depends on.
Noone cared to fix it even after pointing out to the bug (nor to
revert anything), breaking it was easy.

You might have a single device and don't get the whole impact on
everything there.
That I decline the work of a community wouldn't be true either, I'm
glad about any participation the patches show
up a constant contribution by the community which doesn't fight and
it's smoothly getting in there - but in
a managed manner. Try to get any v4l device work on the Acer Aspire
One, you'll very likely fail with a couple
of things there.

We're doing full service on everything not just the driver, without
having an impact on the rest of the system.

Anyway I'd appreciate to get back to the topic again and the question
which I pointed out to, how many devices
are supported by Steven's patch and how many by the work which Manu
used to managed for years with a couple of
people. There are multiple ways which can lead to success, the beauty
of a patch or framework won't matter too much (nevermind
if Steven's or Manu's work seems to be more prettier to someone).

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
