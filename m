Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6HGGmgP028472
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 12:16:48 -0400
Received: from smtp-vbr5.xs4all.nl (smtp-vbr5.xs4all.nl [194.109.24.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6HGGYuJ007182
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 12:16:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: mchehab@infradead.org
Date: Thu, 17 Jul 2008 18:16:22 +0200
References: <3dbf42455956d17b8aa6.1214002733@localhost>
	<Pine.LNX.4.58.0806240032081.535@shell2.speakeasy.net>
	<20080624225951.GF8831@plankton.ifup.org>
In-Reply-To: <20080624225951.GF8831@plankton.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807171816.22303.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] [PATCH] v4l: Introduce "index"
	attribute for?persistent video4linux device nodes
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

On Wednesday 25 June 2008 00:59:51 Brandon Philips wrote:
> On 00:34 Tue 24 Jun 2008, Trent Piepho wrote:
> > On Mon, 23 Jun 2008, Brandon Philips wrote:
> > > +	for (i = 0; i < 32; i++) {
> > > +		if (used & (1 << i))
> > > +			continue;
> > > +		return i;
> > > +	}
> >
> > 	i = ffz(used);
> > 	return i >= 32 ? -ENFILE : i;
>
> Err. Right :D  Tested and pushed.
>
> Mauro-
>
> Updated http://ifup.org/hg/v4l-dvb to have Trent's improvement.
>
> Cheers,
>
> 	Brandon


Hi Mauro,

I think you missed this pull request from Brandon. Can you merge this?

Thanks,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
