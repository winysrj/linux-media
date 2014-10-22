Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:34592 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaJVJVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 05:21:32 -0400
Received: by mail-ob0-f171.google.com with SMTP id wp18so185736obc.16
        for <linux-media@vger.kernel.org>; Wed, 22 Oct 2014 02:21:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL8zT=hDEth-xoEr=9phzdZ9dXJMBeP9rpiTLYHwoqgf7E4tjQ@mail.gmail.com>
References: <CAL8zT=j2STDuLHW3ONw1+cOfePZceBN7yTsV1WxDjFo0bZMBaA@mail.gmail.com>
 <54465F34.1000400@xs4all.nl> <CAL8zT=herYZ9d3TKrx_5Nre0_RRRXK3Az9-NvmqGE7_SkHLzHg@mail.gmail.com>
 <54466471.8050607@xs4all.nl> <CAL8zT=jykeu33QRvj9JxhuSxV2Cg8La2J8KxVJpu+GsaE9wZnA@mail.gmail.com>
 <1413908485.3081.4.camel@pengutronix.de> <CAL8zT=hDEth-xoEr=9phzdZ9dXJMBeP9rpiTLYHwoqgf7E4tjQ@mail.gmail.com>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Wed, 22 Oct 2014 11:21:16 +0200
Message-ID: <CAL8zT=jQ-pg8x1rqX5SFvgbtKuTsaJXdSVuMU3ocJGRUBCo3Bg@mail.gmail.com>
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
>
> 2014-10-21 18:21 GMT+02:00 Philipp Zabel <p.zabel@pengutronix.de>:
>> Hi Jean-Michel,
>>
>> Am Dienstag, den 21.10.2014, 17:39 +0200 schrieb Jean-Michel Hautbois:
>> [...]
>>> And the output is now :
>>> v4l2-ctl -d1 --stream-out-mmap --stream-mmap --stream-to x.raw
>>> [ 6208.240919] coda 2040000.vpu: Not output type
>>> [ 6208.245316] coda 2040000.vpu: streamon_out (N), streamon_cap (Y)
>>> [ 6208.251353] coda 2040000.vpu: fill bitstream
>>> [ 6208.255653] coda 2040000.vpu: fill bitstream payload : 0
>>> VIDIOC_STREAMON: failed: Invalid argument
>>>
>>> Any idea ?
>>> JM
>>
>> $ trace-cmd record -e v4l2* v4l2-ctl -d13 --stream-out-mmap --stream-mmap --stream-to x.raw
>> [...]
>> $ trace-cmd report -R | grep bytesused
>> [...]
>>     v4l2-ctl-308   [003]  1030.861067: v4l2_qbuf:             minor=44 index=0 type=1 bytesused=0 flags=16387 field=0 timestamp=0 timecode_type=0 timecode_flags=0 timecode_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0 sequence=0
>>     v4l2-ctl-308   [003]  1030.861292: v4l2_qbuf:             minor=44 index=1 type=1 bytesused=0 flags=16387 field=0 timestamp=0 timecode_type=0 timecode_flags=0 timecode_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0 sequence=0
>>     v4l2-ctl-308   [003]  1030.861471: v4l2_qbuf:             minor=44 index=2 type=1 bytesused=0 flags=16387 field=0 timestamp=0 timecode_type=0 timecode_flags=0 timecode_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0 sequence=0
>>     v4l2-ctl-308   [003]  1030.861638: v4l2_qbuf:             minor=44 index=3 type=1 bytesused=0 flags=16387 field=0 timestamp=0 timecode_type=0 timecode_flags=0 timecode_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0 sequence=0
>>     v4l2-ctl-308   [003]  1030.862301: v4l2_qbuf:             minor=44 index=0 type=2 bytesused=3133440 flags=16387 field=1 timestamp=1030852944000 timecode_type=0 timecode_flags=0 timecode_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0 sequence=0
>>     v4l2-ctl-308   [003]  1030.862490: v4l2_qbuf:             minor=44 index=1 type=2 bytesused=3133440 flags=16387 field=1 timestamp=1030853139000 timecode_type=0 timecode_flags=0 timecode_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0 sequence=0
>>     v4l2-ctl-308   [003]  1030.862672: v4l2_qbuf:             minor=44 index=2 type=2 bytesused=3133440 flags=16387 field=1 timestamp=1030853322000 timecode_type=0 timecode_flags=0 timecode_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0 sequence=0
>>     v4l2-ctl-308   [003]  1030.862841: v4l2_qbuf:             minor=44 index=3 type=2 bytesused=3133440 flags=16387 field=1 timestamp=1030853491000 timecode_type=0 timecode_flags=0 timecode_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0 sequence=0
>>

I may have misunderstand something...
I try to encode, and modified the CODA_MAX_FRAME_SIZE to 0x500000 just to see.
And here is the trace-cmd :

$> trace-cmd  record -e v4l2*  v4l2-ctl -d1  --stream-out-mmap
--stream-mmap --stream-to x.raw
[...]
$> trace-cmd report -R | grep bytesused
        v4l2-ctl-1162  [000]   324.061644: v4l2_qbuf:
minor=1 index=0 type=1 bytesused=0 flags=16387 field=0 timestamp=0
timecode_type=0 timecode_flags=0 timecode_frames=0 timeco
de_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0
timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0
sequence=0
        v4l2-ctl-1162  [000]   324.062207: v4l2_qbuf:
minor=1 index=1 type=1 bytesused=0 flags=16387 field=0 timestamp=0
timecode_type=0 timecode_flags=0 timecode_frames=0 timeco
de_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0
timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0
sequence=0
        v4l2-ctl-1162  [000]   324.062297: v4l2_qbuf:
minor=1 index=2 type=1 bytesused=0 flags=16387 field=0 timestamp=0
timecode_type=0 timecode_flags=0 timecode_frames=0 timeco
de_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0
timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0
sequence=0
        v4l2-ctl-1162  [000]   324.062397: v4l2_qbuf:
minor=1 index=3 type=1 bytesused=0 flags=16387 field=0 timestamp=0
timecode_type=0 timecode_flags=0 timecode_frames=0 timeco
de_seconds=0 timecode_minutes=0 timecode_hours=0 timecode_userbits0=0
timecode_userbits1=0 timecode_userbits2=0 timecode_userbits3=0
sequence=0
        v4l2-ctl-1162  [000]   324.062931: v4l2_qbuf:
minor=1 index=0 type=2 bytesused=5242880 flags=16387 field=1
timestamp=324047436000 timecode_type=0 timecode_flags=0 timecod
e_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0
timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0
timecode_userbits3=0 sequence=0
        v4l2-ctl-1162  [000]   324.063070: v4l2_qbuf:
minor=1 index=1 type=2 bytesused=5242880 flags=16387 field=1
timestamp=324047575000 timecode_type=0 timecode_flags=0 timecod
e_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0
timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0
timecode_userbits3=0 sequence=0
        v4l2-ctl-1162  [000]   324.063197: v4l2_qbuf:
minor=1 index=2 type=2 bytesused=5242880 flags=16387 field=1
timestamp=324047704000 timecode_type=0 timecode_flags=0 timecod
e_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0
timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0
timecode_userbits3=0 sequence=0
        v4l2-ctl-1162  [000]   324.063330: v4l2_qbuf:
minor=1 index=3 type=2 bytesused=5242880 flags=16387 field=1
timestamp=324047837000 timecode_type=0 timecode_flags=0 timecod
e_frames=0 timecode_seconds=0 timecode_minutes=0 timecode_hours=0
timecode_userbits0=0 timecode_userbits1=0 timecode_userbits2=0
timecode_userbits3=0 sequence=0


And the bytesused is 5MB which corresponds to the 0x500000...
How is the encoder supposed to work precisely ? I missed something...

Thanks,
JM
