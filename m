Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LEplC-00065t-QA
	for linux-dvb@linuxtv.org; Mon, 22 Dec 2008 19:44:12 +0100
Received: by qw-out-2122.google.com with SMTP id 9so815778qwb.17
	for <linux-dvb@linuxtv.org>; Mon, 22 Dec 2008 10:44:06 -0800 (PST)
Message-ID: <412bdbff0812221044v3caf8f2ladbfb8fb27fda9e@mail.gmail.com>
Date: Mon, 22 Dec 2008 13:44:06 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Matt R" <mattr121@gmail.com>
In-Reply-To: <25864d030812221027i6fc25460lc0e0592558772dab@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <25864d030812220513i22938f4dt28b0190f8aaafeba@mail.gmail.com>
	<412bdbff0812220752p4f4d3bf0t741472a8349db683@mail.gmail.com>
	<25864d030812221027i6fc25460lc0e0592558772dab@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Pinnacle USB TV tuner sticks
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

Hello Matt,

On Mon, Dec 22, 2008 at 1:27 PM, Matt R <mattr121@gmail.com> wrote:
> Avermedia's "Hybrid Volar Max" has all four (ATSC/QAM/NTSC/FM) tuning
> features (and one can buy a remote from aver directly, completing its
> feature set nicely except for recording). I noticed that some of their
> non-US models from a year ago declared support for linux (and I even
> downloaded some sources for them!). Do you know if their US models have
> either Aver-provided or OSS support for linux?

Just to be clear, some of the problems are not that the hardware
doesn't support all four - it is the Linux driver support that is the
issue.  For example, the 801e hardware supports all four, but because
of issues in the framework I wouldn't have been able to get the analog
working without a ton of work (several weeks of development).

Hmm....  I don't know much about the Avermedia products.  However, if
they are making source available and we aren't already integrating it
then I should look into that...  Could you send me a link including to
where you are getting the source?

> It looks like if this "Hybrid Volar Max" is a no go, the best options for
> now might be:
> 1. Hauppauge's 950Q

Bear in mind the 950Q has no analog support currently in the Linux
driver.  But the ClearQAM support I am sure is better tested and known
to work.

> 2. Pinnacle 800e

Bear in mind the 800e hardware has no ClearQAM support so if that's
important to you then that's a showstopper.

> with 801 potentially working in the future. Do you agree?

Certainly if people don't see ClearQAM working for this device then
it's my fault and I should spend the cycles to figure out what is
going on there.  There's probably only a few hours of work required
once I get the environment setup.

> If I go ahead and keep the 801e, I will be glad to help you with some
> testing (and if more time is available, perhaps some coding as well,
> although I would have to learn the ropes first on these devices and device
> programming in general.)

I've got access to cable now so I should be able to get the ClearQAM
working.  I just never got around to testing it and nobody said they
were having problems so I assumed it worked.

Out of curiosity, what application are you using?

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
