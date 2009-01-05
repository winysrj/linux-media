Return-path: <video4linux-list-bounces@redhat.com>
Date: Mon, 5 Jan 2009 00:43:32 -0200
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: "Robert Krakora" <rob.krakora@messagenetsystems.com>
Message-ID: <20090105004332.7d7c3a85@gmail.com>
In-Reply-To: <b24e53350901041128p29b149b6u7c48874fe106138d@mail.gmail.com>
References: <b24e53350901032021t2fdc4e54saec05f223d430f35@mail.gmail.com>
	<412bdbff0901032118y9dda1c2uaeb451c0874a65cd@mail.gmail.com>
	<49605AFA.3000208@rogers.com>
	<b24e53350901041128p29b149b6u7c48874fe106138d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jerry Geis <geisj@messagenetsystems.com>, video4linux-list@redhat.com,
	linux-media <linux-media@vger.kernel.org>, CityK <cityk@rogers.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: KWorld 330U Employs Samsung S5H1409X01 Demodulator
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

On Sun, 4 Jan 2009 14:28:11 -0500
"Robert Krakora" <rob.krakora@messagenetsystems.com> wrote:

> On Sun, Jan 4, 2009 at 1:45 AM, CityK <cityk@rogers.com> wrote:
> 
> > Devin Heitmueller wrote:
> > > On Sat, Jan 3, 2009 at 11:21 PM, Robert Krakora
> > > <rob.krakora@messagenetsystems.com> wrote:
> > >
> > >> Mauro:
> > >>
> > >> The KWorld 330U employs the Samsung S5H1409X01 demodulator, not
> > >> the LGDT330X.  Hence the error initializing the LGDT330X in the
> > >> current
> > source
> > >> in em28xx-dvb.c.
> > >>
> > >> Best Regards,
> > >>
> > >
> > > Hello Robert,
> > >
> > > Well, that's good to know.  I don't think anyone has done any
> > > work on that device recently, so I don't know why the code has it
> > > as an lgdt3303.
> >
> > I believe Douglas submitted this patch
> > (http://linuxtv.org/hg/v4l-dvb/rev/77f789d59de8) that got committed.
> >
> > I've been meaning to get back to this because the "A316" part of the
> > name caught my attention -- I do not recall having seen such a
> > reference made by KWorld, nor is it typical of their nomenclature
> > style, rather, it is entirely consistent with that used by AVerMedia
> >
> >
> >
> >
> Douglas:
> 
> A316 is actually the product ID portion of the USB vendor/product
> IDs.  It should be 330 instead of A316.

I agree with that. It should be replaced.

Cheers,
Douglas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
