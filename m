Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.242])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JeC0P-0005pk-Dv
	for linux-dvb@linuxtv.org; Tue, 25 Mar 2008 17:28:11 +0100
Received: by an-out-0708.google.com with SMTP id d18so2637107and.125
	for <linux-dvb@linuxtv.org>; Tue, 25 Mar 2008 09:28:03 -0700 (PDT)
Message-ID: <d9def9db0803250928u6197e854xbecad1930d879a8@mail.gmail.com>
Date: Tue, 25 Mar 2008 17:28:03 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Aidan Thornton" <makosoft@googlemail.com>
In-Reply-To: <c8b4dbe10803250911l4499dcfatb4d11184437e9c1@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <c8b4dbe10803241504t68d96ec9m8a4edb7b34c1d6ef@mail.gmail.com>
	<d9def9db0803241604mc1c9d1g1144af2f7619192a@mail.gmail.com>
	<c8b4dbe10803250911l4499dcfatb4d11184437e9c1@mail.gmail.com>
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

On 3/25/08, Aidan Thornton <makosoft@googlemail.com> wrote:
> On Mon, Mar 24, 2008 at 11:04 PM, Markus Rechberger
> <mrechberger@gmail.com> wrote:
> >
> > On 3/24/08, Aidan Thornton <makosoft@googlemail.com> wrote:
> > > Hi,
> > >
> > > I've been attempting to get something that can cleanly support DVB-T
> > > on the original HVR-900, based on up-to-date v4l-dvb and Markus'
> > > em2880-dvb (that is to say, something that could hopefully be cleaned
> > > up to a mergable state and won't be too hard to keep updated if it
> > > doesn't get merged). The current (somewhat messy, still incomplete)
> > > tree is at http://www.makomk.com/hg/v4l-dvb-em28xx/ - em2880-dvb.c is
> > > particularly bad. I don't have access to DVB-T signals at the moment,
> > > but as far as I can tell, it works. Anyone want to test it? General
> > > comments? (Other hardware will be added if I have the time,
> > > information, and someone willing to test it.)
> > >
> >
> > This is more than incomplete, VBI is missing (nor tested with various
> > video standards), and this device is 2 years old and not getting sold
> > anymore.
> > It's better to keep everything together at mcentral.de (this will very
> > likely be moved to an empia domain in near future).
> >
> > I will join Empia at 1st April 08, adding support for their new
> > devices (and also improving support of the older ones).
> >
> > Markus
> >
>
> Hi,
>
> I've deliberately avoided adding code for VBI - it's just too
> difficult to get right on em28xx due to interesting buffer management
> and locking issues. (For example, have you fixed the issue that causes
> a kernel panic when recording analog video with MythTV? That was a
> particularly interesting one.) In any case, that's another issue
> entirely - this code is for DVB-T support.
>

I'm not aware of that bug, although VBI just needs some finetuning. I
got it work with zapping/libzvbi a long time ago. As for now I put it
onto the todolist for next month.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
