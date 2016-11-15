Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36303 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753042AbcKOXfZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 18:35:25 -0500
MIME-Version: 1.0
In-Reply-To: <20161115232754.GB1041@n2100.armlinux.org.uk>
References: <1479136968-24477-1-git-send-email-hverkuil@xs4all.nl>
 <1479136968-24477-3-git-send-email-hverkuil@xs4all.nl> <CAJ-oXjS-VVkBuYh0inTGAvJbsKzvEqKYrgoSeG6UBQtW_1BEyQ@mail.gmail.com>
 <20161115232754.GB1041@n2100.armlinux.org.uk>
From: Pierre-Hugues Husson <phh@phh.me>
Date: Wed, 16 Nov 2016 00:35:03 +0100
Message-ID: <CAJ-oXjTgYmnNhGh8dW4Ke=zFDN5wwHNoJ40bFUKp0T5dTGLrbw@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 2/5] drm/bridge: dw_hdmi: remove CEC engine register definitions
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-11-16 0:27 GMT+01:00 Russell King - ARM Linux <linux@armlinux.org.uk>:
> On Wed, Nov 16, 2016 at 12:23:50AM +0100, Pierre-Hugues Husson wrote:
>> Hi,
>>
>>
>> 2016-11-14 16:22 GMT+01:00 Hans Verkuil <hverkuil@xs4all.nl>:
>> > From: Russell King <rmk+kernel@arm.linux.org.uk>
>> >
>> > We don't need the CEC engine register definitions, so let's remove the=
m.
>> >
>> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
>> > ---
>> >  drivers/gpu/drm/bridge/dw-hdmi.h | 45 -------------------------------=
---------
>> >  1 file changed, 45 deletions(-)
>> >
>> > diff --git a/drivers/gpu/drm/bridge/dw-hdmi.h b/drivers/gpu/drm/bridge=
/dw-hdmi.h
>> > index fc9a560..26d6845 100644
>> > --- a/drivers/gpu/drm/bridge/dw-hdmi.h
>> > +++ b/drivers/gpu/drm/bridge/dw-hdmi.h
>> > @@ -478,51 +478,6 @@
>> >  #define HDMI_A_PRESETUP                         0x501A
>> >  #define HDMI_A_SRM_BASE                         0x5020
>> >
>> > -/* CEC Engine Registers */
>> > -#define HDMI_CEC_CTRL                           0x7D00
>> > -#define HDMI_CEC_STAT                           0x7D01
>> > -#define HDMI_CEC_MASK                           0x7D02
>> I don't know if this is relevant for a submission, but the build stops
>> working here because of a missing definition HDMI_CEC_MASK
>> Perhaps this should be inverted with 3/5 to make bissecting easier?
>> I was trying to bissect a kernel panic, and I had to fix this by hand
>
> Doesn't make sense - patch 3 doesn't reference HDMI_CEC_MASK.
>
> Please show the build error in full.
The build is actually fixed with patch 4.

Building after patch 2 fails with:
drivers/gpu/drm/bridge/dw-hdmi.c: In function =E2=80=98initialize_hdmi_ih_m=
utes=E2=80=99:
drivers/gpu/drm/bridge/dw-hdmi.c:1300:26: error: =E2=80=98HDMI_CEC_MASK=E2=
=80=99
undeclared (first use in this function)
  hdmi_writeb(hdmi, 0xff, HDMI_CEC_MASK);

The point of switching patch 3 and patch 2, is that the build works
with patch 1,3 applied.
Applying patch 2 breaks the build, but doesn't change any active code,
so it's ok.

So with the order 1,3,2,4,5, the build is broken only after 2, while
with 1,2,3,4,5, it is broken after 2 and 3.

I hope this makes my remark more explicit.

If it doesn't, I think it is quite safe to just ignore it
