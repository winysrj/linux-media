Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f178.google.com ([209.85.210.178]:35937 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727614AbeHaToz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 15:44:55 -0400
Received: by mail-pf1-f178.google.com with SMTP id b11-v6so5705341pfo.3
        for <linux-media@vger.kernel.org>; Fri, 31 Aug 2018 08:36:52 -0700 (PDT)
MIME-Version: 1.0
References: <20180829105828.4502-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20180829105828.4502-1-sakari.ailus@linux.intel.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Sat, 1 Sep 2018 00:36:40 +0900
Message-ID: <CAC5umyhdKujYUOcvOOwx_iixHyty4Q53UpbHnAkWU1nfxCT=Hg@mail.gmail.com>
Subject: Re: [RFC 1/1] v4l: samsung, ov9650: Rely on V4L2-set sub-device names
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        riverful.kim@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        a.hajda@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018=E5=B9=B48=E6=9C=8829=E6=97=A5(=E6=B0=B4) 19:58 Sakari Ailus <sakari.ai=
lus@linux.intel.com>:
>
> v4l2_i2c_subdev_init() sets the name of the sub-devices (as well as
> entities) to what is fairly certainly known to be unique in the system,
> even if there were more devices of the same kind.
>
> These drivers (m5mols, noon010pc30, ov9650, s5c73m3, s5k4ecgx, s5k6aa) se=
t
> the name to the name of the driver or the module while omitting the
> device's I=C2=B2C address and bus, leaving the devices with a static name=
 and
> effectively limiting the number of such devices in a media device to 1.
>
> Address this by using the name set by the V4L2 framework.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi,
>
> I'm a bit uncertain about this one. I discussed the matter with Hans and
> his view was this is a bug (I don't disagree), but this bug affects uAPI.
> Also these devices tend to be a few years old and might not see much use
> in newer devices, so why bother? The naming convention musn't be copied t=
o
> newer drivers though.
>
> Any opinions?

The change for the ov9650 driver looks OK to me.

My media device setup script needs to be updated by this change, but
it is not a big deal.

Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
