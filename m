Return-path: <linux-media-owner@vger.kernel.org>
Received: from pv33p04im-asmtp001.me.com ([17.143.181.10]:55760 "EHLO
        pv33p04im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933053AbcIFKwI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 06:52:08 -0400
Received: from process-dkim-sign-daemon.pv33p04im-asmtp001.me.com by
 pv33p04im-asmtp001.me.com
 (Oracle Communications Messaging Server 7.0.5.38.0 64bit (built Feb 26 2016))
 id <0OD200000WNZKG00@pv33p04im-asmtp001.me.com> for
 linux-media@vger.kernel.org; Tue, 06 Sep 2016 10:51:56 +0000 (GMT)
Content-type: text/plain; charset=utf-8
MIME-version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: uvcvideo error on second capture from USB device,
 leading to V4L2_BUF_FLAG_ERROR
From: Oliver Collyer <ovcollyer@mac.com>
In-reply-to: <20160905201935.wpgtrtt7e4bjjylo@zver>
Date: Tue, 06 Sep 2016 13:51:51 +0300
Cc: Andrey Utkin <andrey_utkin@fastmail.com>
Content-transfer-encoding: quoted-printable
Message-id: <FE81AFD0-C5F1-4FE7-A282-3294E668066C@mac.com>
References: <C29C248E-5D7A-4E69-A88D-7B971D42E984@mac.com>
 <20160904192538.75czuv7c2imru6ds@zver>
 <AE433005-988F-4352-8CF3-30690C82CAA6@mac.com>
 <20160905201935.wpgtrtt7e4bjjylo@zver>
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So today I installed Ubuntu 16.04 on another PC (this one a high spec =
machine with a Rampage V Extreme motherboard) and I reproduced exactly =
the same errors and trace.

Rebooting the same PC back into Windows 10 and using the same USB 3.0 =
port, I had no problems capturing using FFmpeg via DirectShow. I could =
start and stop the capture repeatedly without any warnings or errors =
appearing in FFmpeg (built from the same source).

If the hardware is misbehaving, on both these capture devices, then DS =
must be handling it better than V4L2. Or there is simply an obscure bug =
in V4L2 which only manifests itself with certain devices.

Would providing ssh access to the machine be of interest to anyone who =
wants to debug this?

> On 5 Sep 2016, at 23:19, Andrey Utkin <andrey_utkin@fastmail.com> =
wrote:
>=20
> On Mon, Sep 05, 2016 at 10:43:49PM +0300, Oliver Collyer wrote:
>> I do not have any knowledge of uvcvideo and the associated classes =
apart from the studying I=E2=80=99ve done the past day or two, but it =
seems likely that error -71 and the later setting of V4L2_BUF_FLAG_ERROR =
are linked. Also, the fact it only happens in captures after the first =
one suggests something isn=E2=80=99t being cleared down or released =
properly in uvcvideo/v4l2-core at the end of the first capture.
>>=20
>> Let me know what I need to do next to further narrow it down.
>=20
> Have tried to reproduce this (with kernel 4.6.0 and fresh build of
> ffmpeg) with uvcvideo-driven laptop webcam, and it doesn't happen to =
me.
> Also -EPROTO in uvcvideo comes from low-level USB stuff, see
> drivers/media/usb/uvc/uvc_status.c:127:
>=20
> 	case -EPROTO:		/* Device is disconnected (reported by =
some
> 				 * host controller). */
>=20
> So it seems like hardware misbehaves. To further clairify situation, I
> have such question: do the devices work in other operation systems on
> the same machine?
>=20
> Reviewing your original email mentioning that two different devices
> reproduce same problem, which is apparently related to disconnection =
in
> the middle of USB communication, I came to me that the connected =
device
> may be underpowered. So,
> - try plugging your devices through reliable _active_ USB hub,
> - use the most reliable cables you can get,
> - plug into USB 3.0 port if available - it should provide more power
>   than 1.0 and 2.0.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

