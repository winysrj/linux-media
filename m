Return-path: <linux-media-owner@vger.kernel.org>
Received: from pv33p04im-asmtp002.me.com ([17.143.181.11]:50534 "EHLO
        pv33p04im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751066AbcIJLLb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Sep 2016 07:11:31 -0400
Received: from process-dkim-sign-daemon.pv33p04im-asmtp002.me.com by
 pv33p04im-asmtp002.me.com
 (Oracle Communications Messaging Server 7.0.5.38.0 64bit (built Feb 26 2016))
 id <0ODA00500CBYX400@pv33p04im-asmtp002.me.com> for
 linux-media@vger.kernel.org; Sat, 10 Sep 2016 11:11:09 +0000 (GMT)
Content-type: text/plain; charset=utf-8
MIME-version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: uvcvideo error on second capture from USB device,
 leading to V4L2_BUF_FLAG_ERROR
From: Oliver Collyer <ovcollyer@mac.com>
In-reply-to: <20160910105817.eoyvvy5u5mkkrb5c@zver>
Date: Sat, 10 Sep 2016 14:11:03 +0300
Cc: linux-media@vger.kernel.org, Support INOGENI <support@inogeni.com>,
        james.liu@magewell.net
Content-transfer-encoding: quoted-printable
Message-id: <18B7A999-C7A2-4F95-A82A-5F878E3E6D80@mac.com>
References: <C29C248E-5D7A-4E69-A88D-7B971D42E984@mac.com>
 <20160904192538.75czuv7c2imru6ds@zver>
 <AE433005-988F-4352-8CF3-30690C82CAA6@mac.com>
 <20160905201935.wpgtrtt7e4bjjylo@zver>
 <FE81AFD0-C5F1-4FE7-A282-3294E668066C@mac.com>
 <20160906122823.toxscjyxomrh2col@zver>
 <71006CF0-B710-435A-B5A5-C0D0D20DE34F@mac.com>
 <20160910101440.nlb4sp43u36yj4ql@zver>
 <E8CA02F7-7F3C-4D0A-BAFC-24CAB8A57AEB@mac.com>
 <20160910105817.eoyvvy5u5mkkrb5c@zver>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>=20
> These two chunks look like legit resilience measure, and maybe could =
be
> even added to upstream ffmpeg, maybe for non-default mode.
>=20

Well I=E2=80=99ve posted it to the FFmpeg dev list for feedback, so we =
will see.

Non-default mode - yes maybe it needs to be optional. And/or only have =
an effect at the start of the capture; I am concerned that in some =
situation where a capture momentarily loses signal and delivers a =
corrupted buffer that my patch would then actually do more than an end =
user would require by ignoring subsequent buffers and maybe turning it =
into a bigger issue.

>>=20
>> +   =20
>> +    /* if we just encounted some corrupted buffers then we ignore =
the next few
>> +     * legitimate buffers because they can arrive at irregular =
intervals, causing
>> +     * the timestamps of the input and output streams to be =
out-of-sync and FFmpeg
>> +     * to continually emit warnings. */
>> +    if (s->buffers_ignore) {
>> +        av_log(ctx, AV_LOG_WARNING,
>> +               "Ignoring dequeued v4l2 buffer due to earlier =
corruption.\n");
>> +        s->buffers_ignore --;
>> +        enqueue_buffer(s, &buf);
>> +        return FFERROR_REDO;
>> +    }
>=20
> Not clear exactly happens here so that such workaround is needed=E2=80=A6=

>=20

Yes, this is the ugly bit. I had it outputting the timestamps of all the =
buffers received and it clearly showed that 2-3 of them are stamped =
closer together. It=E2=80=99s as if something is taking extra time to =
recover from whatever was causing the original problem.

