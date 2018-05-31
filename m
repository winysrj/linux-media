Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:40462 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755549AbeEaQZo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 12:25:44 -0400
Received: by mail-it0-f54.google.com with SMTP id j186-v6so28741334ita.5
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 09:25:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4b9c4b84704ba4d1a89bd0408e76e68e5554d078.camel@ndufresne.ca>
References: <CAMty3ZAMjCKv1BtLnobRZUzp=9Xu1gY5+R3Zi-JuobAJZQrXxg@mail.gmail.com>
 <4b9c4b84704ba4d1a89bd0408e76e68e5554d078.camel@ndufresne.ca>
From: Jagan Teki <jagan@amarulasolutions.com>
Date: Thu, 31 May 2018 21:55:43 +0530
Message-ID: <CAMty3ZCV0LgDK0vFtN2HvLVZ4W26mvn4xEr0wby1TaYyhbFZsw@mail.gmail.com>
Subject: Re: i.MX6 MIPI-CSI2 OV5640 Camera testing on Mainline Linux
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Discussion of the development of and with GStreamer
        <gstreamer-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 31, 2018 at 9:40 PM, Nicolas Dufresne <nicolas@ndufresne.ca> wr=
ote:
> Le jeudi 31 mai 2018 =C3=A0 20:39 +0530, Jagan Teki a =C3=A9crit :
>> Hi All,
>>
>> I'm trying to verify MIPI-CSI2 OV5640 camera on i.MX6 platform with
>> Mainline Linux.
>>
>> I've followed these[1] instructions to configure MC links and pads
>> based on the probing details from dmesg and trying to capture
>> ipu1_ic_prpenc capture (/dev/video1) but it's not working.
>>
>> Can anyone help me to verify whether I configured all the details
>> properly if not please suggest.
>>
>> I'm pasting full log here, so-that anyone can comment in line and dt
>> changes are at [2]
>
> Be aware that because all of the provided GStreamer logs lines are
> truncated, I won't be able to comment on the issue.

Sorry for the confusion, here is the gst log [3] and dmesg + media-ctl [4]

[3] https://paste.ubuntu.com/p/NpG8ynb8nQ/
[4] https://paste.ubuntu.com/p/VGX3sYdvVW/

Jagan.

--=20
Jagan Teki
Senior Linux Kernel Engineer | Amarula Solutions
U-Boot, Linux | Upstream Maintainer
Hyderabad, India.
