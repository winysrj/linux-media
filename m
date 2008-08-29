Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KZ9H3-0000GR-CN
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 21:04:46 +0200
Received: by nf-out-0910.google.com with SMTP id g13so275347nfb.11
	for <linux-dvb@linuxtv.org>; Fri, 29 Aug 2008 12:04:42 -0700 (PDT)
Message-ID: <37219a840808291204o7012d75t95bd8dbcf3ee0cc2@mail.gmail.com>
Date: Fri, 29 Aug 2008 15:04:41 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Matyas Sustik" <linux-dvb.list@sustik.com>
In-Reply-To: <48B83C83.7050801@sustik.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <48B822A9.6070400@sustik.com>
	<37219a840808290932n23165451nfcdfa6ded704713e@mail.gmail.com>
	<48B83C83.7050801@sustik.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fusion HDTV 7
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

On Fri, Aug 29, 2008 at 2:14 PM, Matyas Sustik
<linux-dvb.list@sustik.com> wrote:
> Thanks for the quick response!
>
> Michael Krufky wrote:
>> No, you must have used a "car=4" option....  Next time read the error
>> message and it might help you figure out what you did wrong.
>
> I reverted to the stock kernel modules and cx23885 indeed loaded with
> "card=4".  However channel scanning did not find anything.  Since you
> wrote:
>
>> FusionHDTV7 is not supported in 2.6.26.y -- you should use the
>> linuxtv.org modules from the development repository, instead.
>
> I just got the sources again and did make, make install (no make load)
> and rebooted.  Module loaded, dmesg indicated no errors.
>
> Scanning turns up nothing though, I only get:
>> scan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB
> scanning /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>>> tune to: 57028615:8VSB
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x1ffb
>>>> tune to: 63028615:8VSB
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x1ffb
>>>> tune to: 69028615:8VSB
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x1ffb
>>>> tune to: 79028615:8VSB
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x1ffb
> ...
>
> I picked us-ATSC-center-frequencies-8VSB for the over the air channels (in
> Austin TX), please correct me if I was wrong there.
>
> Is there a way to make sure that the card is receiving anything?  I would
> like to rule out a malfunctioning card.  Does the load of the module indicate
> that some communication has already taken place with the card?
>
> I will try a different cable next.  I can also ask a friend to test-drive the
> card under windows but I would do that as a last resort.  (If there is a
> hardware error on the card I need to return it soon.)
>
>> Did you reboot your machine before trying the new modules?
>
> That was the problem.  It was not clear to me that other than the cx23885
> module need to be updated, that there are dependencies regarding module
> versions.  (The module system is not modular enough it seems; presumably as a
> result of constant changes in the module and kernel interfaces?)
>
> Thanks again for your help!
> Matyas
> -
> Every hardware eventually breaks.  Every software eventually works.



I'm kind of in a rush right now.

I didnt have time to read your whole email, but I just need to point
out that your method is flawed.

#1, as i think I already stated in my previous email, you *need* to
use the v4l-dvb mercurial repository if you want the FusionHDTV7 to
work.

#2, if you are passing card=4, then THAT is why it is not working.
FusionHDTV7 is *not* card 4.  Dont pass anything, let it autodetect.

Good Luck,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
