Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:56718 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3AOPrv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 10:47:51 -0500
Received: by mail-qc0-f182.google.com with SMTP id k19so151097qcs.41
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2013 07:47:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130115132151.415180e1@redhat.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<50F522AD.8000109@iki.fi>
	<20130115111041.6b78a935@redhat.com>
	<50F56C63.7010503@iki.fi>
	<20130115132151.415180e1@redhat.com>
Date: Tue, 15 Jan 2013 10:47:50 -0500
Message-ID: <CAGoCfiw+rXzeskA95iHkwW-OU5v=QVYMryO82dLJYKxDjsvWBw@mail.gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 15, 2013 at 10:21 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>> Lets say SS, SNR, BER, UCB are queried, but only SS and SNR are ready to
>> be returned, whilst rest are not possible? As I remember DVBv5 API is
>> broken by design and cannot return error code per request.
>
> The one(s) not available will have "FE_SCALE_NOT_AVAILABLE" as scale,
> and its value is undefined.

We may wish to rethink this approach - it lacks the ability to specify
why the data isn't available.  It would probably be very useful for
userland to know the difference between a statistic not being
available because the hardware doesn't ever provide that data (in
which case a GUI might do something like not show the option), versus
it not being available temporarily due to a lack of signal lock (in
which as a GUI might show the option but indicate that the data is not
currently available).  Likewise I would want to know that data isn't
being shown due to some error condition versus it not being supported
by the hardware or the data being temporarily unavailable due to a
lack of signal lock.

See, I've been thinking about it for two minutes, and already found
three perfectly reasonable error conditions userland would probably
want to differentiate between.  Do we really think it's wise to make
this field the equivalent of a bool?

It might make sense to add something equivalent to errno for a per-stat basis.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
