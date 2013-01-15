Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757202Ab3AOPYH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 10:24:07 -0500
Date: Tue, 15 Jan 2013 13:23:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130115132335.1383cdad@redhat.com>
In-Reply-To: <CAHFNz9JQPVoPXhs7d4Ou_vbYWV5uUKimTnuD+FCVOmwvCDDRkA@mail.gmail.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<CAHFNz9JQPVoPXhs7d4Ou_vbYWV5uUKimTnuD+FCVOmwvCDDRkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 15 Jan 2013 16:08:14 +0530
Manu Abraham <abraham.manu@gmail.com> escreveu:

> On Tue, Jan 15, 2013 at 8:00 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Add DVBv5 methods to retrieve QoS statistics.
> >
> > Those methods allow per-layer and global statistics.
> >
> > Implemented 2 QoS statistics on mb86a20s, one global only
> > (signal strengh), and one per layer (BER).
> >
> > Tested with a modified version of dvbv5-zap, that allows monitoring
> > those stats. Test data follows
> >
> > Tested with 1-segment at layer A, and 12-segment at layer B:
> >
> > [ 3735.973058] i2c i2c-4: mb86a20s_layer_bitrate: layer A bitrate: 440 kbps; counter = 196608 (0x030000)
> > [ 3735.976803] i2c i2c-4: mb86a20s_layer_bitrate: layer B bitrate: 16851 kbps; counter = 8257536 (0x7e0000)
> >
> > a) Global stats:
> >
> > Signal strength:
> >         QOS_SIGNAL_STRENGTH[0] = 4096
> >
> > BER (sum of BE count and bit counts for both layers):
> >         QOS_BIT_ERROR_COUNT[0] = 1087865
> >         QOS_TOTAL_BITS_COUNT[0] = 67043313
> >
> > b) Per-layer stats:
> >
> > Layer A BER:
> >         QOS_BIT_ERROR_COUNT[1] = 236
> >         QOS_TOTAL_BITS_COUNT[1] = 917490
> >
> > Layer B BER:
> >         QOS_BIT_ERROR_COUNT[2] = 1087629
> >         QOS_TOTAL_BITS_COUNT[2] = 66125823
> >
> > TODO:
> >         - add more statistics at mb86a20s;
> >         - implement support for DTV_QOS_ENUM;
> >         - some cleanups at get_frontend logic at dvb core, to avoid
> >           it to be called outside the DVB thread loop.
> >
> > All the above changes can be done a little later during this development
> > cycle, so my plan is to merge it upstream at the beginning of the
> > next week, to allow others to test.
> >
> 
> 
> An API should be simple. This is far from simple. This API looks horribly
> complex and broken, for anyone to use it in a sane way.

It is not complex. See my answer to Antti with a few code snippets.

> Polling from within dvb-core is not a good idea, as it can cause acquisition
> failures. Continuous polling is known to cause issues.

Polling from Kernel or from userspace has the same results. If a hardware is
known to be broken with polling, the driver needs to handle it. With a
Kernel polling, drivers can have more control, as it should not be hard to
change the dvb-frontend polling time for it to be set by the driver.

It could even be possible to have an interrupt-driven process to update the
statistics, if the hardware supports it.

> Adding counters to be controlled externally by a user is the most silliest
> thing altogether.

Huh? There's nothing that userspace can control. All userspace does with the
API is to read values. Nothing more, nothing less.

> All these things put together, makes it the most inconvenient thing to be used.
> Eventually, it results in more broken applications than existing.
> 
> Not to forget that too much work has to be put into drivers, which aren't going
> to make things better, but rather even more worser.

Not necessarily drivers need to be patched, as the existing callbacks could
be used. Still, I think it makes sense to gradually change the drivers we
care to the new way, in order to provide a better API. Of course, the old 
calls should still work. So, it is not getting anything worser.

Regards,
Mauro
