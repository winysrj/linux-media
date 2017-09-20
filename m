Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:18550 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751480AbdITJOK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 05:14:10 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8K9E9FJ006784
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 10:14:09 +0100
Received: from mail-pg0-f69.google.com (mail-pg0-f69.google.com [74.125.83.69])
        by mx07-00252a01.pphosted.com with ESMTP id 2d0sc01ykj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 10:14:09 +0100
Received: by mail-pg0-f69.google.com with SMTP id i130so4485975pgc.5
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 02:14:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170919134930.6fa28562@recife.lan>
References: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
 <3e638375aff788b24f988e452214649d6100a596.1505826082.git.dave.stevenson@raspberrypi.org>
 <1505834685.10076.5.camel@pengutronix.de> <20170919134930.6fa28562@recife.lan>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Wed, 20 Sep 2017 10:14:06 +0100
Message-ID: <CAAoAYcNCPrpZWvxTTsCtGd4vobsQKDw-ckLhXyRst0dS++h_Ag@mail.gmail.com>
Subject: Re: [PATCH 2/3] [media] tc358743: Increase FIFO level to 300.
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro & Philipp

On 19 September 2017 at 17:49, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Em Tue, 19 Sep 2017 17:24:45 +0200
> Philipp Zabel <p.zabel@pengutronix.de> escreveu:
>
>> Hi Dave,
>>
>> On Tue, 2017-09-19 at 14:08 +0100, Dave Stevenson wrote:
>> > The existing fixed value of 16 worked for UYVY 720P60 over
>> > 2 lanes at 594MHz, or UYVY 1080P60 over 4 lanes. (RGB888
>> > 1080P60 needs 6 lanes at 594MHz).
>> > It doesn't allow for lower resolutions to work as the FIFO
>> > underflows.
>> >
>> > Using a value of 300 works for all resolutions down to VGA60,
>> > and the increase in frame delay is <4usecs for 1080P60 UYVY
>> > (2.55usecs for RGB888).
>> >
>> > Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
>>
>> Can we increase this to 320? This would also allow
>> 720p60 at 594 Mbps / 4 lanes, according to the xls.

Unless I've missed something then the driver would currently request
only 2 lanes for 720p60 UYVY, and that works with the existing FIFO
setting of 16. Likewise 720p60 RGB888 requests 3 lanes and also works
on a FIFO setting of 16.
How/why were you thinking we need to run all four lanes for 720p60
without other significant driver mods around lane config?

Once I've got a v3 done on the Unicam driver I'll bash through the
standard HDMI modes and check what value they need - I can see a big
spreadsheet coming on.
I'll ignore interlaced modes as I can't see any support for it in the
driver. Receiving the fields on different CSI-2 data types is
something I know the Unicam hardware won't handle nicely, and I
suspect it'd be an issue for many other platforms too.

> Hmm... if this is dependent on the resolution and frame rate, wouldn't
> it be better to dynamically adjust it accordingly?

It's setting up the FIFO matching the incoming HDMI data rate and
outgoing CSI rate. That means it's dependent on the incoming pixel
clock, blanking, colour format and resolution, and output CSI link
frequency, number of lanes, and colour format.
Whilst it could be set dynamically based on all those parameters, is
there a significant enough gain in doing so?

The value of 300 works for all cases I've tried, and referencing back
it is also the value that Hans said Cisco use via platform data on
their hardware [1]. Generally I'm seeing that values of 0-130 are
required, so 300 is giving a fair safety margin.

Second question is does anyone have a suitable relationship with
Toshiba to get permission to release details of these register
calculations? The datasheet and value spreadsheet are marked as
confidential, and probably under NDA in almost all cases. Whilst they
can't object to drivers containing values to make them work, they
might over releasing significant details.

Thanks,
  Dave

[1] https://www.spinics.net/lists/linux-media/msg116360.html
