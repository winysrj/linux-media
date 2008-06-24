Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5ON0utM026617
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 19:00:56 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5OMxvmo002791
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 19:00:43 -0400
Received: by rv-out-0506.google.com with SMTP id f6so9376391rvb.51
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 15:59:56 -0700 (PDT)
Date: Tue, 24 Jun 2008 15:59:51 -0700
From: Brandon Philips <brandon@ifup.org>
To: Trent Piepho <xyzzy@speakeasy.org>, mchehab@infradead.org
Message-ID: <20080624225951.GF8831@plankton.ifup.org>
References: <3dbf42455956d17b8aa6.1214002733@localhost>
	<200806221334.45894.hverkuil@xs4all.nl>
	<20080623150734.GF18397@plankton.ifup.org>
	<200806231800.44274.hverkuil@xs4all.nl>
	<20080623233952.GA4569@plankton>
	<Pine.LNX.4.58.0806240032081.535@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0806240032081.535@shell2.speakeasy.net>
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
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

On 00:34 Tue 24 Jun 2008, Trent Piepho wrote:
> On Mon, 23 Jun 2008, Brandon Philips wrote:
> > +	for (i = 0; i < 32; i++) {
> > +		if (used & (1 << i))
> > +			continue;
> > +		return i;
> > +	}
> 
> 	i = ffz(used);
> 	return i >= 32 ? -ENFILE : i;

Err. Right :D  Tested and pushed.

Mauro-

Updated http://ifup.org/hg/v4l-dvb to have Trent's improvement.

Cheers,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
