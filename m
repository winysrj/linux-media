Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Fri, 17 Oct 2008 11:40:15 +0200
References: <412bdbff0810150724h2ab46767ib7cfa52e3fdbc5fa@mail.gmail.com>
	<48F633FA.4000106@linuxtv.org>
	<412bdbff0810160728w396fd41ek4bb9818e191305e5@mail.gmail.com>
In-Reply-To: <412bdbff0810160728w396fd41ek4bb9818e191305e5@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810171140.15670.hftom@free.fr>
Subject: Re: [linux-dvb] Revisiting the SNR/Strength issue
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

Le Thursday 16 October 2008 16:28:04 Devin Heitmueller, vous avez =E9crit=
=A0:
> On Wed, Oct 15, 2008 at 2:18 PM, Steven Toth <stoth@linuxtv.org> wrote:
> > It will happen when someone cares enough to do it, that's the Linux
> > mantra.
>
> I care enough to do it, but I'm trying to see if there's a solution
> that doesn't require me to learn the intimate details of how SNR is
> computed for every demodulator in the codebase (and then change that
> representation to dB).
>
> I think it's actually really important that regular users be able to
> use their application of choice (Kaffeine/MythTV/other) and be able to
> tell whether they have a descent signal without having to look at the
> kernel driver source code for the demodulator that is in their tuner
> (that sentence alone has six words most regular users couldn't even
> define).

Have to add that most users even don't know what "dB" is. So, whatever the =

unit, an application would have to translate it in an understandable form, =

which could be as simple as :
"Very bad signal quality"
"Bad signal quality"
"Good signal quality"
"Very good signal quality"

> > Let's quantify this. How many frontends would have to change?
>
> I didn't get a chance to do a count last night.  I will do this
> tonight when I get home.
>
> >> engineering would have to be done, and in many cases without a signal
> >> generator this would be very difficult.  This could take months or
> >> years, or might never happen.
> >
> > You don't need a signal generator, you _do_ need a comparison product
> > that is reliably reporting db.
> >
> >> Certainly I'm in favor of expressing that there is a preferred unit
> >> that new frontends should use (whether that be ESNO or db), but the
> >> solution I'm suggesting would allow the field to become useful *now*.
> >> This would hold us over until all the other frontends are converted to
> >> db (which I have doubts will ever actually happen).
> >
> > I'm not in favour of this.
> >
> > I'd rather see a single unit of measure agreed up, and each respective
> > maintainer go back and perform the necessary code changes. I'm speaking
> > as a developer of eight (?) different demod drivers in the kernel. That=
's
> > no small task, but I'd happily conform if I could.
> >
> > Lastly, for the sake of this discussion, assuming that db is agreed upo=
n,
> > if the driver cannot successfully delivery SNR in terms of db then  the
> > bogus function returning junk should be removed.
> >
> > Those two changes alone would be a better long term approach, I think.
>
> I'll see tonight how many demods we're talking about.  Certainly in
> the long term I agree that this would be a better approach - I'm just
> concerned that "long term" could mean "never".

Yep it could, seeing how much time this issue has been discussed and still =
no =

solution.


-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
