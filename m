Return-path: <linux-media-owner@vger.kernel.org>
Received: from pv33p04im-asmtp002.me.com ([17.143.181.11]:51533 "EHLO
        pv33p04im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbcIJHhO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Sep 2016 03:37:14 -0400
Received: from process-dkim-sign-daemon.pv33p04im-asmtp002.me.com by
 pv33p04im-asmtp002.me.com
 (Oracle Communications Messaging Server 7.0.5.38.0 64bit (built Feb 26 2016))
 id <0ODA00D00273F200@pv33p04im-asmtp002.me.com> for
 linux-media@vger.kernel.org; Sat, 10 Sep 2016 07:37:14 +0000 (GMT)
Content-type: text/plain; charset=utf-8
MIME-version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: uvcvideo error on second capture from USB device,
 leading to V4L2_BUF_FLAG_ERROR
From: Oliver Collyer <ovcollyer@mac.com>
In-reply-to: <20160906122823.toxscjyxomrh2col@zver>
Date: Sat, 10 Sep 2016 10:37:08 +0300
Cc: Andrey Utkin <andrey_utkin@fastmail.com>,
        Support INOGENI <support@inogeni.com>, james.liu@magewell.net
Content-transfer-encoding: quoted-printable
Message-id: <71006CF0-B710-435A-B5A5-C0D0D20DE34F@mac.com>
References: <C29C248E-5D7A-4E69-A88D-7B971D42E984@mac.com>
 <20160904192538.75czuv7c2imru6ds@zver>
 <AE433005-988F-4352-8CF3-30690C82CAA6@mac.com>
 <20160905201935.wpgtrtt7e4bjjylo@zver>
 <FE81AFD0-C5F1-4FE7-A282-3294E668066C@mac.com>
 <20160906122823.toxscjyxomrh2col@zver>
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I am curious to tinker with this, just not sure about free time for =
it.
> Please go through the following instruction, and then we'll see if ssh
> is going to help to debug this.
>=20
> Also I think it is worth to CC actual manufacturers. There are =
addresses
> for technical support of both devices in public on maker websites.
> Please CC them when replying with new logs, to let them catch up.
>=20

Ok, so I=E2=80=99ve provided all these logs requested by Andrey in an =
earlier message but I=E2=80=99m unsubscribing from this list now.

I have written a patch for FFmpeg that deals with the problem for both =
devices so it=E2=80=99s not really an issue for me anymore, but I=E2=80=99=
m not sure if the patch will get accepted in their master git as it=E2=80=99=
s a little messy.

I=E2=80=99ve already documented another workaround ("modprobe -r =
uvcvideo && modprobe uvcvideo=E2=80=9D before starting any capture) so =
really it=E2=80=99s up to the people developing these devices and/or the =
v4l2 driver/sub-system as to whether this gets sorted. Nobody from =
Magewell even bothered replying and I=E2=80=99m not going to chase that =
up as I=E2=80=99ve better things to do!

I am however, perfectly happy for anyone to contact me off list/copy me =
into any further discussion and I=E2=80=99m happy to provide ssh access =
to a machine that shows the problem for debugging if that would help.

- Oliver

