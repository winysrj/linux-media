Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KFVFS-0004vW-Bq
	for linux-dvb@linuxtv.org; Sun, 06 Jul 2008 16:29:55 +0200
Received: by nf-out-0910.google.com with SMTP id g13so622209nfb.11
	for <linux-dvb@linuxtv.org>; Sun, 06 Jul 2008 07:29:48 -0700 (PDT)
Message-ID: <412bdbff0807060729o639f98b1s383d146856feb6da@mail.gmail.com>
Date: Sun, 6 Jul 2008 10:29:48 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <1215343022.10393.945.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <1214139259.2994.8.camel@jaswinder.satnam>
	<200807060315.51736@orion.escape-edv.de> <48708BBF.9050400@cadsoft.de>
	<1215343022.10393.945.camel@pmac.infradead.org>
Cc: kernelnewbies <kernelnewbies@nl.linux.org>, linux-dvb@linuxtv.org,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Jaswinder Singh <jaswinder@infradead.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-dvb] [PATCH] Remove fdump tool for av7110 firmware
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

On Sun, Jul 6, 2008 at 7:17 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Sun, 2008-07-06 at 11:09 +0200, Klaus Schmidinger wrote:
>> On 07/06/08 03:15, Oliver Endriss wrote:
>> > Jaswinder Singh wrote:
>> >> There's no point in this, since the user can use the BUILTIN_FIRMWARE
>> >> option to include arbitrary firmware files directly in the kernel image.
>> >
>> > NAK! This option allows to compile the firmware into the _driver_,
>> > which is very useful if you want to test various driver/firmware
>> > combinations. Having the firmware in the _kernel_ does not help!
>>
>> I strongly support Oliver's request!
>> Working with various driver versions is much easier with the
>> firmware compiled into the driver!
>
> That's strange; I've found exactly the opposite to be the case.
>
> If I want to test permutations of driver and firmware, as I've done for
> the libertas driver a number of times, I find it _much_ better to
> preserve the modularity. I can build each version of the driver and can
> test that against various firmware versions without having to rebuild
> it, and with much less chance of something going wrong so that I'm not
> actually testing what I think I'm testing.
>
> Perhaps I'm missing something that would help me work better? Please
> could you help me understand how you currently work, and I'll attempt to
> make it easier for you. Can you talk me through an example of a session
> where you had to do this testing of 'various driver/firmware
> combinations'?
>
>
> --
> dwmw2
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

Correct me if I'm wrong, but doesn't this also affect those
distributions that consider kernels with binary firmware blobs to not
be free software?  Those distributions take the stance that the
firmware must be loadable by userland, in which case the proposed
patch removes this capability.

Is there some downside to leaving this functionality in there?  Are
there known bugs or maintainability issues with the code as-is?

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
