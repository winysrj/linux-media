Return-path: <linux-media-owner@vger.kernel.org>
Received: from pv33p04im-asmtp001.me.com ([17.143.181.10]:37300 "EHLO
        pv33p04im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932266AbcIEUcS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 16:32:18 -0400
Received: from process-dkim-sign-daemon.pv33p04im-asmtp001.me.com by
 pv33p04im-asmtp001.me.com
 (Oracle Communications Messaging Server 7.0.5.38.0 64bit (built Feb 26 2016))
 id <0OD100800STCLH00@pv33p04im-asmtp001.me.com> for
 linux-media@vger.kernel.org; Mon, 05 Sep 2016 20:32:16 +0000 (GMT)
Content-type: text/plain; charset=utf-8
MIME-version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: uvcvideo error on second capture from USB device,
 leading to V4L2_BUF_FLAG_ERROR
From: Oliver Collyer <ovcollyer@mac.com>
In-reply-to: <20160905201935.wpgtrtt7e4bjjylo@zver>
Date: Mon, 05 Sep 2016 23:32:10 +0300
Cc: linux-media@vger.kernel.org
Content-transfer-encoding: quoted-printable
Message-id: <A7196057-BFD6-4CF4-8386-7101688FC3F6@mac.com>
References: <C29C248E-5D7A-4E69-A88D-7B971D42E984@mac.com>
 <20160904192538.75czuv7c2imru6ds@zver>
 <AE433005-988F-4352-8CF3-30690C82CAA6@mac.com>
 <20160905201935.wpgtrtt7e4bjjylo@zver>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


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

Yes, they work perfectly with dshow on Windows on on multiple PCs =
including this one.

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

I will experiment with different ports and report back.

Still, I=E2=80=99m not sure how that suggestion fits with the fact that =
it always works perfectly after "modprobe -r uvcvideo && modprobe =
uvcvideo=E2=80=9D and only fails again once the capture is stopped and =
restarted?

Perhaps some kind of =E2=80=9Cquirk=E2=80=9D can be added for these =
devices that does some extra clearing up/re-initializing at the start of =
the capture - kind of like *some* of what reloading the module does but =
only for the specific device.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

