Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40624 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbeJQCGR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Oct 2018 22:06:17 -0400
Received: by mail-pf1-f193.google.com with SMTP id g21-v6so4852147pfi.7
        for <linux-media@vger.kernel.org>; Tue, 16 Oct 2018 11:14:37 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 1/4] media: ov5640: fix resolution update
From: Samuel Bobrowicz <sam@elite-embedded.com>
In-Reply-To: <9748474.vgieh7tsac@avalon>
Date: Tue, 16 Oct 2018 11:14:33 -0700
Cc: Hugues FRUCHET <hugues.fruchet@st.com>,
        jacopo mondi <jacopo@jmondi.org>,
        "slongerbeam@gmail.com" <slongerbeam@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "daniel@zonque.org" <daniel@zonque.org>,
        "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0B91449C-7F68-4F14-BA39-1D4C41DC5DB6@elite-embedded.com>
References: <1539067682-60604-1-git-send-email-sam@elite-embedded.com> <5292714.SW9firoZdu@avalon> <0295fe15-6802-ecd9-f42d-391184fc1344@st.com> <9748474.vgieh7tsac@avalon>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Glad this is spurring a lot of conversation, and I=E2=80=99m happy to see th=
is many contributors too. I think we have all solved many of these problems (=
and the many others) offline, and now it=E2=80=99s the hard part to try to g=
lue them all together. I decided to jump back in the mix with these patches b=
ecause they seemed that they would be the easiest to rebase and were obvious=
 bug fixes. I was hoping we could get this one applied and have a better sta=
rting place to work from before we start what is a very necessary restructur=
e of the mode setting, but if everybody is ready to go now, we can just do a=
 larger overhaul and I can withdraw this patch from this series. I expect th=
e larger overhaul to warrant its own patch series.

I=E2=80=99m not going to comment yet on some of the proposed changes below, b=
ecause I think it is better if we just move the discussion to its own series=
.

Another note, I also agree that prior to changing the rest of mode setting, t=
he next step is to introduce maximes critical pll setting patch. It is requi=
red for my platform to work at all (yes my platform has never worked with ma=
in line) because my CSI2 receiver needs the PCLK PERIOD register to be set p=
roperly. I actually have tweaked Maximes original patch so that it doesn=E2=80=
=99t introduce a regression for MIPI platforms, but it will need to be teste=
d on DVP platforms. I=E2=80=99ll send it out RFC tonight, so hopefully that w=
ill get us closer to a single patch that doesn=E2=80=99t break things in eit=
her mode.

IMO I would like to see this patch broken out of Maximes larger series, beca=
use I think it is getting bogged down by the many other changes there.

With this many interested parties, someone would really be helping if they p=
ut out a organized to do list that we could schedule out :)

> On Oct 16, 2018, at 5:15 AM, Laurent Pinchart <laurent.pinchart@ideasonboa=
rd.com> wrote:
>=20
> Hi Hugues,
>=20
>> On Monday, 15 October 2018 18:13:12 EEST Hugues FRUCHET wrote:
>> Hi Laurent, Jacopo, Sam,
>>=20
>> I'm also OK to change to a simpler alternative;
>> - drop the "restore" step
>> - send the whole init register sequence + mode changes + format changes=20=

>> at streamon
>>=20
>> is this what you have in mind Laurent ?
>=20
> Yes, that's pretty much the idea. The init sequence could be sent when=20
> powering the sensor on to save time at streamon. Everything else can be=20=

> programmed at streamon time to simplify the implementation.
>=20
>>> On 10/10/2018 02:41 PM, Laurent Pinchart wrote:
>>>> On Wednesday, 10 October 2018 13:58:04 EEST jacopo mondi wrote:
>>>>=20
>>>> Hi Sam,
>>>>=20
>>>> thanks for the patch, I see the same issue you reported, but I
>>>> think this patch can be improved.
>>>>=20
>>>> (expanding the Cc list to all people involved in recent ov5640
>>>> developemts, not just for this patch, but for the whole series to look
>>>> at. Copying names from another series cover letter, hope it is
>>>> complete.)
>>>>=20
>>>>> On Mon, Oct 08, 2018 at 11:47:59PM -0700, Sam Bobrowicz wrote:
>>>>>=20
>>>>> set_fmt was not properly triggering a mode change when
>>>>> a new mode was set that happened to have the same format
>>>>> as the previous mode (for example, when only changing the
>>>>> frame dimensions). Fix this.
>>>>>=20
>>>>> Signed-off-by: Sam Bobrowicz <sam@elite-embedded.com>
>>>>> ---
>>>>>=20
>>>>>  drivers/media/i2c/ov5640.c | 8 ++++----
>>>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>>>=20
>>>>> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
>>>>> index eaefdb5..5031aab 100644
>>>>> --- a/drivers/media/i2c/ov5640.c
>>>>> +++ b/drivers/media/i2c/ov5640.c
>>>>> @@ -2045,12 +2045,12 @@ static int ov5640_set_fmt(struct v4l2_subdev
>>>>> *sd,
>>>>>          goto out;
>>>>>      }
>>>>>=20
>>>>> -    if (new_mode !=3D sensor->current_mode) {
>>>>> +
>>>>> +    if (new_mode !=3D sensor->current_mode ||
>>>>> +        mbus_fmt->code !=3D sensor->fmt.code) {
>>>>> +        sensor->fmt =3D *mbus_fmt;
>>>>>          sensor->current_mode =3D new_mode;
>>>>>          sensor->pending_mode_change =3D true;
>>>>> -    }
>>>>> -    if (mbus_fmt->code !=3D sensor->fmt.code) {
>>>>> -        sensor->fmt =3D *mbus_fmt;
>>>>>          sensor->pending_fmt_change =3D true;
>>>>>      }
>>>>=20
>>>> How I did reproduce the issue:
>>>>=20
>>>> # Set 1024x768 on ov5640 without changing the image format
>>>> # (default image size at startup is 640x480)
>>>> $ media-ctl --set-v4l2 "'ov5640 2-003c':0[fmt:UYVY2X8/1024x768
>>>> field:none]"
>>>>   sensor->pending_mode_change =3D true; //verified this flag gets set
>>>>=20
>>>> # Start streaming, after having configured the whole pipeline to work
>>>> # with 1024x768
>>>> $  yavta -c10 -n4 -f UYVY -s 1024x768 /dev/video4
>>>>    Unable to start streaming: Broken pipe (32).
>>>>=20
>>>> # Inspect which part of pipeline validation went wrong
>>>> # Turns out the sensor->fmt field is not updated, and when get_fmt()
>>>> # is called, the old one is returned.
>>>> $ media-ctl -e "ov5640 2-003c" -p
>>>>   ...
>>>>   [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb xfer:srgb
>>>>   ycbcr:601 quantization:full-range] ^^^ ^^^
>>>>=20
>>>> So yes, sensor->fmt is not udapted as it should be when only image
>>>> resolution is changed.
>>>>=20
>>>> Although I still see value in having two separate flags for the
>>>> 'mode_change' (which in ov5640 lingo is resolution) and 'fmt_change'
>>>> (which in ov5640 lingo is the image format), and write their
>>>> configuration to registers only when they get actually changed.
>>>>=20
>>>> For this reasons I would like to propse the following patch which I
>>>> have tested by:
>>>> 1) changing resolution only
>>>> 2) changing format only
>>>> 3) change both
>>>>=20
>>>> What do you and others think?
>>>=20
>>> I think that the format setting code should be completely rewritten, it'=
s
>>> pretty much unmaintainable as-is.
>>>=20
>>>> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
>>>> index eaefdb5..e392b9d 100644
>>>> --- a/drivers/media/i2c/ov5640.c
>>>> +++ b/drivers/media/i2c/ov5640.c
>>>> @@ -2020,6 +2020,7 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,=

>>>>         struct ov5640_dev *sensor =3D to_ov5640_dev(sd);
>>>>         const struct ov5640_mode_info *new_mode;
>>>>         struct v4l2_mbus_framefmt *mbus_fmt =3D &format->format;
>>>> +       struct v4l2_mbus_framefmt *fmt;
>>>>         int ret;
>>>>=20
>>>>         if (format->pad !=3D 0)
>>>> @@ -2037,22 +2038,19 @@ static int ov5640_set_fmt(struct v4l2_subdev
>>>> *sd,
>>>>         if (ret)
>>>>                 goto out;
>>>>=20
>>>> -       if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
>>>> -               struct v4l2_mbus_framefmt *fmt =3D
>>>> -                       v4l2_subdev_get_try_format(sd, cfg, 0);
>>>> +       if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY)
>>>> +               fmt =3D v4l2_subdev_get_try_format(sd, cfg, 0);
>>>> +       else
>>>> +               fmt =3D &sensor->fmt;
>>>> -               *fmt =3D *mbus_fmt;
>>>> -               goto out;
>>>> -       }
>>>> +       *fmt =3D *mbus_fmt;
>>>>=20
>>>>         if (new_mode !=3D sensor->current_mode) {
>>>>                 sensor->current_mode =3D new_mode;
>>>>                 sensor->pending_mode_change =3D true;
>>>>         }
>>>>=20
>>>> -       if (mbus_fmt->code !=3D sensor->fmt.code) {
>>>> -               sensor->fmt =3D *mbus_fmt;
>>>> +       if (mbus_fmt->code !=3D sensor->fmt.code)
>>>>                 sensor->pending_fmt_change =3D true;
>>>> -       }
>>>>=20
>>>>  out:
>>>>         mutex_unlock(&sensor->lock);
>>>>         return ret;
>>>>=20
>>>>>  out:
>=20
> --=20
> Regards,
>=20
> Laurent Pinchart
>=20
>=20
>=20
