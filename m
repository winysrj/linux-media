Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40311 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab3AOKiP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 05:38:15 -0500
Received: by mail-ob0-f174.google.com with SMTP id ta14so4885601obb.5
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2013 02:38:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
Date: Tue, 15 Jan 2013 16:08:14 +0530
Message-ID: <CAHFNz9JQPVoPXhs7d4Ou_vbYWV5uUKimTnuD+FCVOmwvCDDRkA@mail.gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 15, 2013 at 8:00 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Add DVBv5 methods to retrieve QoS statistics.
>
> Those methods allow per-layer and global statistics.
>
> Implemented 2 QoS statistics on mb86a20s, one global only
> (signal strengh), and one per layer (BER).
>
> Tested with a modified version of dvbv5-zap, that allows monitoring
> those stats. Test data follows
>
> Tested with 1-segment at layer A, and 12-segment at layer B:
>
> [ 3735.973058] i2c i2c-4: mb86a20s_layer_bitrate: layer A bitrate: 440 kbps; counter = 196608 (0x030000)
> [ 3735.976803] i2c i2c-4: mb86a20s_layer_bitrate: layer B bitrate: 16851 kbps; counter = 8257536 (0x7e0000)
>
> a) Global stats:
>
> Signal strength:
>         QOS_SIGNAL_STRENGTH[0] = 4096
>
> BER (sum of BE count and bit counts for both layers):
>         QOS_BIT_ERROR_COUNT[0] = 1087865
>         QOS_TOTAL_BITS_COUNT[0] = 67043313
>
> b) Per-layer stats:
>
> Layer A BER:
>         QOS_BIT_ERROR_COUNT[1] = 236
>         QOS_TOTAL_BITS_COUNT[1] = 917490
>
> Layer B BER:
>         QOS_BIT_ERROR_COUNT[2] = 1087629
>         QOS_TOTAL_BITS_COUNT[2] = 66125823
>
> TODO:
>         - add more statistics at mb86a20s;
>         - implement support for DTV_QOS_ENUM;
>         - some cleanups at get_frontend logic at dvb core, to avoid
>           it to be called outside the DVB thread loop.
>
> All the above changes can be done a little later during this development
> cycle, so my plan is to merge it upstream at the beginning of the
> next week, to allow others to test.
>


An API should be simple. This is far from simple. This API looks horribly
complex and broken, for anyone to use it in a sane way.

Polling from within dvb-core is not a good idea, as it can cause acquisition
failures. Continuous polling is known to cause issues.

Adding counters to be controlled externally by a user is the most silliest
thing altogether.

All these things put together, makes it the most inconvenient thing to be used.
Eventually, it results in more broken applications than existing.

Not to forget that too much work has to be put into drivers, which aren't going
to make things better, but rather even more worser.


Manu
