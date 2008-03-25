Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <makosoft@googlemail.com>) id 1JeBkW-0003f5-GD
	for linux-dvb@linuxtv.org; Tue, 25 Mar 2008 17:11:45 +0100
Received: by rn-out-0910.google.com with SMTP id e11so1701481rng.17
	for <linux-dvb@linuxtv.org>; Tue, 25 Mar 2008 09:11:39 -0700 (PDT)
Message-ID: <c8b4dbe10803250911l4499dcfatb4d11184437e9c1@mail.gmail.com>
Date: Tue, 25 Mar 2008 16:11:35 +0000
From: "Aidan Thornton" <makosoft@googlemail.com>
To: "Markus Rechberger" <mrechberger@gmail.com>
In-Reply-To: <d9def9db0803241604mc1c9d1g1144af2f7619192a@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <c8b4dbe10803241504t68d96ec9m8a4edb7b34c1d6ef@mail.gmail.com>
	<d9def9db0803241604mc1c9d1g1144af2f7619192a@mail.gmail.com>
Cc: DVB ML <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] DVB-T support for original (A1C0) HVR-900
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

On Mon, Mar 24, 2008 at 11:04 PM, Markus Rechberger
<mrechberger@gmail.com> wrote:
>
> On 3/24/08, Aidan Thornton <makosoft@googlemail.com> wrote:
>  > Hi,
>  >
>  > I've been attempting to get something that can cleanly support DVB-T
>  > on the original HVR-900, based on up-to-date v4l-dvb and Markus'
>  > em2880-dvb (that is to say, something that could hopefully be cleaned
>  > up to a mergable state and won't be too hard to keep updated if it
>  > doesn't get merged). The current (somewhat messy, still incomplete)
>  > tree is at http://www.makomk.com/hg/v4l-dvb-em28xx/ - em2880-dvb.c is
>  > particularly bad. I don't have access to DVB-T signals at the moment,
>  > but as far as I can tell, it works. Anyone want to test it? General
>  > comments? (Other hardware will be added if I have the time,
>  > information, and someone willing to test it.)
>  >
>
>  This is more than incomplete, VBI is missing (nor tested with various
>  video standards), and this device is 2 years old and not getting sold
>  anymore.
>  It's better to keep everything together at mcentral.de (this will very
>  likely be moved to an empia domain in near future).
>
>  I will join Empia at 1st April 08, adding support for their new
>  devices (and also improving support of the older ones).
>
>  Markus
>

Hi,

I've deliberately avoided adding code for VBI - it's just too
difficult to get right on em28xx due to interesting buffer management
and locking issues. (For example, have you fixed the issue that causes
a kernel panic when recording analog video with MythTV? That was a
particularly interesting one.) In any case, that's another issue
entirely - this code is for DVB-T support.

Also, just because this device isn't being sold anymore doesn't mean
it's not worth adding - there are other, fairly similar devices still
on sale. Unfortunately, I don't have access to newer hardware, and
most of the people with the access and knowledge don't seem to want to
have anything to do with it. (Why do I have a feeling that you have a
hand in this?) However, adding support should be easy - all the
necessary code exists and has done for a while (even drx397xd support
for the Pinnacle 330e and the new HVR-900).

Mainly, though, I'm doing it for my own benefit - I have this
hardware, and the changes are small and self-contained enough that I
should be able to stay up-to-date with upstream and keep newer kernels
working with minimal effort. (This tree is actually an updated version
of code I've been using for the past few months on PAL-I and DVB-T,
but didn't publish due to a bug with switching from digital to
analog.)

(By the way, I still reckon your userspace code is a dead end, at
least as far as getting anything merged into the kernel. I think I may
have already explained why.)

Aidan

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
