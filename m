Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KqTpg-000800-Te
	for linux-dvb@linuxtv.org; Thu, 16 Oct 2008 16:28:11 +0200
Received: by ey-out-2122.google.com with SMTP id 25so7778eya.17
	for <linux-dvb@linuxtv.org>; Thu, 16 Oct 2008 07:28:05 -0700 (PDT)
Message-ID: <412bdbff0810160728w396fd41ek4bb9818e191305e5@mail.gmail.com>
Date: Thu, 16 Oct 2008 10:28:04 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <48F633FA.4000106@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0810150724h2ab46767ib7cfa52e3fdbc5fa@mail.gmail.com>
	<48F5FE80.5010106@linuxtv.org>
	<412bdbff0810150740h61049f5fvb679bdebbcd4084d@mail.gmail.com>
	<48F633FA.4000106@linuxtv.org>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Revisiting the SNR/Strength issue
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

On Wed, Oct 15, 2008 at 2:18 PM, Steven Toth <stoth@linuxtv.org> wrote:
> It will happen when someone cares enough to do it, that's the Linux mantra.

I care enough to do it, but I'm trying to see if there's a solution
that doesn't require me to learn the intimate details of how SNR is
computed for every demodulator in the codebase (and then change that
representation to dB).

I think it's actually really important that regular users be able to
use their application of choice (Kaffeine/MythTV/other) and be able to
tell whether they have a descent signal without having to look at the
kernel driver source code for the demodulator that is in their tuner
(that sentence alone has six words most regular users couldn't even
define).

> Let's quantify this. How many frontends would have to change?

I didn't get a chance to do a count last night.  I will do this
tonight when I get home.

>> engineering would have to be done, and in many cases without a signal
>> generator this would be very difficult.  This could take months or
>> years, or might never happen.
>
> You don't need a signal generator, you _do_ need a comparison product that
> is reliably reporting db.
>
>>
>> Certainly I'm in favor of expressing that there is a preferred unit
>> that new frontends should use (whether that be ESNO or db), but the
>> solution I'm suggesting would allow the field to become useful *now*.
>> This would hold us over until all the other frontends are converted to
>> db (which I have doubts will ever actually happen).
>
> I'm not in favour of this.
>
> I'd rather see a single unit of measure agreed up, and each respective
> maintainer go back and perform the necessary code changes. I'm speaking as a
> developer of eight (?) different demod drivers in the kernel. That's no
> small task, but I'd happily conform if I could.
>
> Lastly, for the sake of this discussion, assuming that db is agreed upon, if
> the driver cannot successfully delivery SNR in terms of db then  the bogus
> function returning junk should be removed.
>
> Those two changes alone would be a better long term approach, I think.

I'll see tonight how many demods we're talking about.  Certainly in
the long term I agree that this would be a better approach - I'm just
concerned that "long term" could mean "never", in which case I don't
think it would not be unreasonable to have a less-than-perfect
solution.

Cheers,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
