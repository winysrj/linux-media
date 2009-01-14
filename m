Return-path: <video4linux-list-bounces@redhat.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
To: CityK <cityk@rogers.com>
Date: Wed, 14 Jan 2009 19:24:40 +0100
References: <496A9485.7060808@gmail.com> <496D6CF6.6030005@rogers.com>
	<200901140837.43282.hverkuil@xs4all.nl>
In-Reply-To: <200901140837.43282.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901141924.41026.hverkuil@xs4all.nl>
Cc: V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>, Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
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

On Wednesday 14 January 2009 08:37:43 Hans Verkuil wrote:
> On Wednesday 14 January 2009 05:41:26 CityK wrote:
> > hermann pitton wrote:
> > > Hi,
> > >
> > > Am Montag, den 12.01.2009, 21:10 -0500 schrieb CityK:
> > >> Hans Verkuil wrote:
> > >>> Yes, I can. I'll do saa7134 since I have an empress card
> > >>> anyway. It should be quite easy (the cx18 complication is not
> > >>> an issue here).
> > >>>
> > >>> Regards,
> > >>>
> > >>> 	Hans
> > >>
> > >> Thanks Hans!
> > >
> > > yes, Hans is a very fine guy.
> >
> > He is indeed.
>
> Absolutely! :-)
>
> FYI: I have a patch, but I won't have time to test it until Friday.
> You should get something from me then. The main change was actually
> to the saa6752hs.c i2c module (it wasn't yet converted to
> v4l2_subdev), and I need to test that first with my empress card.

OK, I couldn't help myself and went ahead and tested it. It seems fine, 
so please test my tree: 

http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-saa7134

Let me know if it works. If it does, then I'll ask Mauro to pull from my 
tree.

Thanks,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
