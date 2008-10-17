Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KqvaK-0005Mp-Qw
	for linux-dvb@linuxtv.org; Fri, 17 Oct 2008 22:06:11 +0200
Received: by nf-out-0910.google.com with SMTP id g13so373001nfb.11
	for <linux-dvb@linuxtv.org>; Fri, 17 Oct 2008 13:06:05 -0700 (PDT)
Message-ID: <412bdbff0810171306n5f8768a2g48255db266d16aa8@mail.gmail.com>
Date: Fri, 17 Oct 2008 16:06:05 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Darron Broad" <darron@kewl.org>
In-Reply-To: <2207.1224273353@kewl.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
	<2207.1224273353@kewl.org>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [RFC] SNR units in tuners
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

On Fri, Oct 17, 2008 at 3:55 PM, Darron Broad <darron@kewl.org> wrote:
>>===
> <SNIP>
>>cx24116.c       percent scaled to 0-0xffff, support for ESN0
> <SNIP>
>
> There is no hole here but I thought I would pass you by some
> history with this.
>
> The scaled value was calibrated against two domestic satellite
> receivers. The first being a nokia 9600s with dvb2000 and
> the other being a Fortec star beta. At the time there was
> no knowledge of what the cx24116 value represented and no
> great idea of what the domestic box values represented.
> However, the scaling function matches very closely to those
> two machines. What this means in essence is not much but
> may be useful to you.

By all means, if you have information to share about how the
calculation was arrived at, please do.

At this point the goal is to understand what the value means for
different demods.  For the simple cases where the answer is "it's the
SNR in 0.1db as provided by register X", then it's easy.  If it's "I
don't really know and I just guessed based on empirical testing, then
that is useful information too.

Once people have reported in with the information, I will see about
submitting a patch reflecting this information as a comment in the
driver source for the various demods.

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
