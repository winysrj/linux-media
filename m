Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab3AARwW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 12:52:22 -0500
Date: Tue, 1 Jan 2013 15:29:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Subject: Re: [PATCH RFCv3] dvb: Add DVBv5 properties for quality parameters
Message-ID: <20130101152932.3873d4cc@redhat.com>
In-Reply-To: <CAHFNz9+hwx9Bpd5ZJC5RRchpvYzKUzzKv43PSzDunr403xiOsQ@mail.gmail.com>
References: <1356739006-22111-1-git-send-email-mchehab@redhat.com>
	<CAGoCfix=2-pXmTE149XvwT+f7j1F29L3Q-dse0y_Rc-3LKucsQ@mail.gmail.com>
	<20130101130041.52dee65f@redhat.com>
	<CAHFNz9+hwx9Bpd5ZJC5RRchpvYzKUzzKv43PSzDunr403xiOsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 1 Jan 2013 22:18:49 +0530
Manu Abraham <abraham.manu@gmail.com> escreveu:

> On Tue, Jan 1, 2013 at 8:30 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> 
> > [RFCv4] dvb: Add DVBv5 properties for quality parameters
> >
> > The DVBv3 quality parameters are limited on several ways:
> >         - Doesn't provide any way to indicate the used measure;
> >         - Userspace need to guess how to calculate the measure;
> >         - Only a limited set of stats are supported;
> >         - Doesn't provide QoS measure for the OFDM TPS/TMCC
> >           carriers, used to detect the network parameters for
> >           DVB-T/ISDB-T;
> >         - Can't be called in a way to require them to be filled
> >           all at once (atomic reads from the hardware), with may
> >           cause troubles on interpreting them on userspace;
> >         - On some OFDM delivery systems, the carriers can be
> >           independently modulated, having different properties.
> >           Currently, there's no way to report per-layer stats;
> 
> per layer stats is a mythical bird, nothing of that sort does exist. 

Had you ever read or tried to get stats from an ISDB-T demod? If you
had, you would see that it only provides per-layer stats. Btw, this is
a requirement to follow the ARIB and ABNT ISDB specs.

Cheers,
Mauro
