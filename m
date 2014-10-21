Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:33057 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568AbaJUQ0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 12:26:23 -0400
Received: by mail-ob0-f180.google.com with SMTP id va2so1322138obc.11
        for <linux-media@vger.kernel.org>; Tue, 21 Oct 2014 09:26:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413908485.3081.4.camel@pengutronix.de>
References: <CAL8zT=j2STDuLHW3ONw1+cOfePZceBN7yTsV1WxDjFo0bZMBaA@mail.gmail.com>
 <54465F34.1000400@xs4all.nl> <CAL8zT=herYZ9d3TKrx_5Nre0_RRRXK3Az9-NvmqGE7_SkHLzHg@mail.gmail.com>
 <54466471.8050607@xs4all.nl> <CAL8zT=jykeu33QRvj9JxhuSxV2Cg8La2J8KxVJpu+GsaE9wZnA@mail.gmail.com>
 <1413908485.3081.4.camel@pengutronix.de>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Tue, 21 Oct 2014 18:26:07 +0200
Message-ID: <CAL8zT=hDEth-xoEr=9phzdZ9dXJMBeP9rpiTLYHwoqgf7E4tjQ@mail.gmail.com>
Subject: Re: [media] CODA960: Fails to allocate memory
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

2014-10-21 18:21 GMT+02:00 Philipp Zabel <p.zabel@pengutronix.de>:
> Hi Jean-Michel,
>
> Am Dienstag, den 21.10.2014, 17:39 +0200 schrieb Jean-Michel Hautbois:
> [...]
>> And the output is now :
>> v4l2-ctl -d1 --stream-out-mmap --stream-mmap --stream-to x.raw
>> [ 6208.240919] coda 2040000.vpu: Not output type
>> [ 6208.245316] coda 2040000.vpu: streamon_out (N), streamon_cap (Y)
>> [ 6208.251353] coda 2040000.vpu: fill bitstream
>> [ 6208.255653] coda 2040000.vpu: fill bitstream payload : 0
>> VIDIOC_STREAMON: failed: Invalid argument
>>
>> Any idea ?
>> JM
>
> $ trace-cmd record -e v4l2* v4l2-ctl -d13 --stream-out-mmap --stream-mmap --stream-to x.raw
> [...]
> $ trace-cmd report -R | grep bytesused
> [...]
>     v4l2-ctl-308   [003]  1030.861067: v4l2_qbuf:             minor=44 index=0 type=1 bytesused=0 flags=16387 field=0 timestamp=0 timecode_type=0 timecode_flags=0 timecode_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0 sequence=0
>     v4l2-ctl-308   [003]  1030.861292: v4l2_qbuf:             minor=44 index=1 type=1 bytesused=0 flags=16387 field=0 timestamp=0 timecode_type=0 timecode_flags=0 timecode_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0 sequence=0
>     v4l2-ctl-308   [003]  1030.861471: v4l2_qbuf:             minor=44 index=2 type=1 bytesused=0 flags=16387 field=0 timestamp=0 timecode_type=0 timecode_flags=0 timecode_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0 sequence=0
>     v4l2-ctl-308   [003]  1030.861638: v4l2_qbuf:             minor=44 index=3 type=1 bytesused=0 flags=16387 field=0 timestamp=0 timecode_type=0 timecode_flags=0 timecode_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0 sequence=0
>     v4l2-ctl-308   [003]  1030.862301: v4l2_qbuf:             minor=44 index=0 type=2 bytesused=3133440 flags=16387 field=1 timestamp=1030852944000 timecode_type=0 timecode_flags=0 timecode_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0 sequence=0
>     v4l2-ctl-308   [003]  1030.862490: v4l2_qbuf:             minor=44 index=1 type=2 bytesused=3133440 flags=16387 field=1 timestamp=1030853139000 timecode_type=0 timecode_flags=0 timecode_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0 sequence=0
>     v4l2-ctl-308   [003]  1030.862672: v4l2_qbuf:             minor=44 index=2 type=2 bytesused=3133440 flags=16387 field=1 timestamp=1030853322000 timecode_type=0 timecode_flags=0 timecode_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0 sequence=0
>     v4l2-ctl-308   [003]  1030.862841: v4l2_qbuf:             minor=44 index=3 type=2 bytesused=3133440 flags=16387 field=1 timestamp=1030853491000 timecode_type=0 timecode_flags=0 timecode_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0 sequence=0
>
> The decoder is fed ~ 3 MiB input buffers, which it tries (and fails) to
> copy into the 1 MiB bitstream ringbuffer (currently hard-coded via the
> badly named CODA_MAX_FRAME_SIZE constant), so the bitstream payload in
> the ringbuffer is 0 during start_streaming.

Mmmh, nice, didn't thought to get perf out of there :).
Well, I understand it can't feed the ringbuffer, but is there a way to
make the encoder work ?
I could of course modify CODA_MAX_FRAME_SIZE but this is clearly not
the good thing to do...

Thanks,
JM
