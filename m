Return-path: <video4linux-list-bounces@redhat.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Wed, 28 May 2008 08:13:51 +0200
References: <20080522223700.2f103a14@core>
	<1211932138.3197.29.camel@palomino.walls.org>
	<412bdbff0805271746x3db9ae28h3c0f0b565f50d4c6@mail.gmail.com>
In-Reply-To: <412bdbff0805271746x3db9ae28h3c0f0b565f50d4c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805280813.51909.hverkuil@xs4all.nl>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] video4linux: Push down the BKL
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wednesday 28 May 2008 02:46:22 Devin Heitmueller wrote:
> Hello Andy,
>
> On Tue, May 27, 2008 at 7:48 PM, Andy Walls <awalls@radix.net> wrote:
> > MythTV's mythbackend can open both sides of the card at the same
> > time and the cx18 driver supports it.  On my HVR-1600, MythTV may
> > have the digital side of the card open pulling EPG data off of the
> > ATSC broadcasts, when I open up the MythTV frontend and start
> > watching live TV on the analog side of the card.  MythTV also
> > supports
> > Picture-in-Picture using both the analog and digital parts of the
> > HVR-1600.
>
> In this case, what you see as a 'feature' in MythTV is actually a
> problem in our case.  While the HVR-1600 can support this scenario,

Actually, it depends on how the card was defined. There are cards that 
only utilize the analog part of the cx23418, cards that can do both 
digital and analog at the same time and cards that can do either 
digital or analog. The cx18 driver supports the first two cases but not 
yet the last.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
