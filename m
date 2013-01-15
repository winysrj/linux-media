Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab3AOMYm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 07:24:42 -0500
Date: Tue, 15 Jan 2013 10:23:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Johannes Stezenbach <js@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130115102357.536c7b00@redhat.com>
In-Reply-To: <50F51994.1030703@iki.fi>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<20130115082008.GA30007@linuxtv.org>
	<50F51994.1030703@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 15 Jan 2013 10:55:48 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 01/15/2013 10:20 AM, Johannes Stezenbach wrote:
> > On Tue, Jan 15, 2013 at 12:30:46AM -0200, Mauro Carvalho Chehab wrote:
> >> Add DVBv5 methods to retrieve QoS statistics.
> >
> > According to http://en.wikipedia.org/wiki/Qos:
> > "Quality of service in computer network trafficking refers
> > to resource reservation control mechanisms"
> >
> > I think it is misleading to use the term QoS for DVB, what
> > the patch series seems to be about is receiption or signal quality.
> 
> I totally agree that (and I have used name signal statistics).

I have no problem on calling it as signal statistics. 

Yet, IMHO, the above definition is not ok. Being worked on a 
telecommunications service provider during a long time, the QoS term 
is used to any measures used to measure the quality level of a service. 
As such, BER measure on a PDH or SDH link is called as a QoS measure.

Ok, in recent years, the mechanism that priorizes voice/video traffic
on an IP network got called QoS mechanisms, as they are there to
improve the QoS measures on an IP link, making them close to the
QoS measures (in particular, latency) obtained on a non-IP media.

Anyway, to avoid confusion, I'll just use "DVB statistics API" on
the next rfc's.

Regards,
Mauro
