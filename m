Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471Ab3AORDB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 12:03:01 -0500
Date: Tue, 15 Jan 2013 15:02:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130115150220.6fabe7f2@redhat.com>
In-Reply-To: <CAGoCfiw+rXzeskA95iHkwW-OU5v=QVYMryO82dLJYKxDjsvWBw@mail.gmail.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<50F522AD.8000109@iki.fi>
	<20130115111041.6b78a935@redhat.com>
	<50F56C63.7010503@iki.fi>
	<20130115132151.415180e1@redhat.com>
	<CAGoCfiw+rXzeskA95iHkwW-OU5v=QVYMryO82dLJYKxDjsvWBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 15 Jan 2013 10:47:50 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> On Tue, Jan 15, 2013 at 10:21 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> >> Lets say SS, SNR, BER, UCB are queried, but only SS and SNR are ready to
> >> be returned, whilst rest are not possible? As I remember DVBv5 API is
> >> broken by design and cannot return error code per request.
> >
> > The one(s) not available will have "FE_SCALE_NOT_AVAILABLE" as scale,
> > and its value is undefined.
> 
> We may wish to rethink this approach - it lacks the ability to specify
> why the data isn't available.  It would probably be very useful for
> userland to know the difference between a statistic not being
> available because the hardware doesn't ever provide that data (in
> which case a GUI might do something like not show the option),

As already explained:
len = 0 in this case.

> versus
> it not being available temporarily due to a lack of signal lock (in
> which as a GUI might show the option but indicate that the data is not
> currently available).

FE_SCALE_NOT_AVAILABLE

> Likewise I would want to know that data isn't
> being shown due to some error condition versus it not being supported
> by the hardware or the data being temporarily unavailable due to a
> lack of signal lock.

I'm not sure if we have enough bits for a per-layer error error code,
but there is space for a per-stats error code. We can even extend it
to the entire DVBv5 API, as there are some reserved space there.

Yet, IMHO, this is overkill: userspace just needs to know if a given
stats property is not supported by a driver or not available.

> See, I've been thinking about it for two minutes, and already found
> three perfectly reasonable error conditions userland would probably
> want to differentiate between.  Do we really think it's wise to make
> this field the equivalent of a bool?
> 
> It might make sense to add something equivalent to errno for a per-stat basis.

I don't object to add it, but IMHO it is overkill for stats.

Regards,
Mauro
