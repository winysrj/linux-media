Return-path: <video4linux-list-bounces@redhat.com>
Date: Sun, 4 Jan 2009 15:25:12 -0200
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: CityK <cityk@rogers.com>
Message-ID: <20090104152512.0f168fc5@gmail.com>
In-Reply-To: <4960EE73.1000406@rogers.com>
References: <b24e53350901032021t2fdc4e54saec05f223d430f35@mail.gmail.com>
	<412bdbff0901032118y9dda1c2uaeb451c0874a65cd@mail.gmail.com>
	<49605AFA.3000208@rogers.com> <20090104135840.7de113de@gmail.com>
	<4960EE73.1000406@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	Chehab <mchehab@redhat.com>, linux-media <linux-media@vger.kernel.org>
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

Hello,

On Sun, 04 Jan 2009 12:14:27 -0500
CityK <cityk@rogers.com> wrote:

> Douglas Schilling Landgraf wrote:
> > Hello,
> >
> > On Sun, 04 Jan 2009 01:45:14 -0500
> > CityK <cityk@rogers.com> wrote:
> >
> >   
> >> Devin Heitmueller wrote:
> >>     
> >>> On Sat, Jan 3, 2009 at 11:21 PM, Robert Krakora
> >>> <rob.krakora@messagenetsystems.com> wrote:
> >>>   
> >>>       
> >>>> Mauro:
> >>>>
> >>>> The KWorld 330U employs the Samsung S5H1409X01 demodulator, not
> >>>> the LGDT330X.  Hence the error initializing the LGDT330X in the
> >>>> current source in em28xx-dvb.c.
> >>>>
> >>>> Best Regards,
> >>>>     
> >>>>         
> >>> Hello Robert,
> >>>
> >>> Well, that's good to know.  I don't think anyone has done any work
> >>> on that device recently, so I don't know why the code has it as an
> >>> lgdt3303.
> >>>       
> >> I believe Douglas submitted this patch
> >> (http://linuxtv.org/hg/v4l-dvb/rev/77f789d59de8) that got
> >> committed. 
> >
> > I don't remember sending this specific patch.
> >   
> 
> Sorry, that was a memory association thing --- I had originally looked
> at the KWorld patch (Mauro, Dec 9) at the same time that I had with
> the ever so slightly older, and topically similar, HVR-850 patch
> (Douglas, Dec 8; see http://linuxtv.org/hg/v4l-dvb/rev/402de62fe6a6).

Sure, no problem.

> Mauro -- can you shed any light in regards the "A316" part of the name
> descriptor ?

Probably inherited from vendor/product ID, as follow:

em28xx-cards.c:

{ USB_DEVICE(0xeb1a, 0xa316), .driver_info = EM2883_BOARD_KWORLD_HYBRID_A316 },
                        ^^^

Cheers,
Douglas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
