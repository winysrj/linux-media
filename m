Return-path: <mchehab@pedra>
Received: from utopia.booyaka.com ([72.9.107.138]:37437 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab0JIPWl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Oct 2010 11:22:41 -0400
Date: Sat, 9 Oct 2010 09:22:40 -0600 (MDT)
From: Paul Walmsley <paul@booyaka.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: tvp5150: COMPOSITE0 input should not force-enable
 TV mode
In-Reply-To: <AANLkTinhS=GOV=1uR6H=9_=S-nyirdm6Z7HF6N5wKw2T@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1010090919230.15379@utopia.booyaka.com>
References: <alpine.DEB.2.00.1010082229160.15379@utopia.booyaka.com> <AANLkTinhS=GOV=1uR6H=9_=S-nyirdm6Z7HF6N5wKw2T@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="155748971-1186952724-1286637760=:15379"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--155748971-1186952724-1286637760=:15379
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 9 Oct 2010, Devin Heitmueller wrote:

> On Sat, Oct 9, 2010 at 12:31 AM, Paul Walmsley <paul@booyaka.com> wrote:
> >
> > When digitizing composite video from a analog videotape source using th=
e
> > TVP5150's first composite input channel, the captured stream exhibits
> > tearing and synchronization problems[1].
> >
> > It turns out that commit c0477ad9feca01bd8eff95d7482c33753d05c700 cause=
d
> > "TV mode" (as opposed to "VCR mode" or "auto-detect") to be forcibly
> > enabled for both composite inputs. =A0According to the chip
> > documentation[2], "TV mode" disables a "chrominance trap" input filter,
> > which appears to be necessary for high-quality video capture from an
> > analog videotape source. =A0[ Commit
> > c7c0b34c27bbf0671807e902fbfea6270c8f138d subsequently restricted the
> > problem to the first composite input, apparently inadvertently. ]
>=20
> FYI:  This isn't a newly discovered issue:
>=20
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg13869.html

It wouldn't surprise me if many people discovered this issue since 2006. =
=20

Thanks for the link,


- Paul
--155748971-1186952724-1286637760=:15379--
