Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36472 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758788AbdCVKFI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Mar 2017 06:05:08 -0400
Received: by mail-pg0-f67.google.com with SMTP id 81so21678600pgh.3
        for <linux-media@vger.kernel.org>; Wed, 22 Mar 2017 03:04:29 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Subject: Re: [PATCH v2 00/15] Exynos MFC v6+ - remove the need for the
 reserved memory
From: Marian Mihailescu <mihailescu2m@gmail.com>
In-Reply-To: <124477f9-05ed-f38e-3b29-c0629b403fd3@samsung.com>
Date: Wed, 22 Mar 2017 20:34:23 +1030
Cc: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F8B0F130-F931-4E6D-8768-0073F7D3B4B5@gmail.com>
References: <CAM3PiRyZ6y5=D-O2z39qoqNAXkkEROwZ3_g9gctrVqF-Gd+Ysg@mail.gmail.com>
 <CGME20170317120635eucas1p1d13c446f1418de46a49516e95bf9075d@eucas1p1.samsung.com>
 <04742b05-76bc-a0ec-f5e8-fe3a50115c44@samsung.com>
 <E30E2706-5AAF-4235-A515-B73F80D401D4@gmail.com>
 <124477f9-05ed-f38e-3b29-c0629b403fd3@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek,

I have been using gstreamer 1.11.2 with the following patches applied to =
gst-plugins-good (to add the encoder element): =
https://gist.github.com/mihailescu2m/f52a8f4df67a3d796247337ff67211a9
Also gst-plugins-good was compiled --without-libv4l2

This is a pipeline I used to test encoding (mfc-dec on /dev/video10 and =
mfc-enc on /dev/video11):

gst-launch-1.0 filesrc location=3D~/sintel_trailer-720p.mp4 ! qtdemux ! =
h264parse ! v4l2video10dec !  v4l2video11h264enc =
extra-controls=3D"encode,h264_level=3D10,h264_profile=3D4,frame_level_rate=
_control_enable=3D1,video_bitrate=3D4097152" ! h264parse ! matroskamux ! =
filesink location=3D~/sintel-encoded.mkv

I believe this uses all the default MFC encoder options, except:
H264 profile, set to High
H264 level, set to 3.2
max bitrate set to ~4M (default is unlimited, which results in =
~100MB/min files).

Cheers,
Marian


> On 22 Mar. 2017, at 8:10 pm, Marek Szyprowski =
<m.szyprowski@samsung.com> wrote:
>=20
> Hi Marian,
>=20
> On 2017-03-22 10:33, Marian Mihailescu wrote:
>> Hi,
>>=20
>> I was testing with the linux-next kernel + the v2 patches
>> HW: odroid xu4
>> decoding (working): tested with gstreamer
>> encoding: tested with gstreamer && mfc-patched ffmpeg
>> before patches: encoding worked
>> after patches: encoding didn=E2=80=99t work.
>>=20
>> I moved on from linux-next in the meantime and I cannot give you =
logs, BUT I=E2=80=99ve seen Hardkernel applied these patches (and all =
the linux-next MFC patches) on top of their 4.9 tree, and the result is =
very similar to mine on linux-next: =
https://github.com/hardkernel/linux/issues/284
>>=20
>> Mar 21 13:04:54 odroid kernel: [   37.165153] =
s5p_mfc_alloc_priv_buf:78: Allocating private buffer of size 23243744 =
failed
>> Mar 21 13:04:54 odroid kernel: [   37.171865] =
s5p_mfc_alloc_codec_buffers_v6:244: Failed to allocate Bank1 memory
>> Mar 21 13:04:54 odroid kernel: [   37.179143] vidioc_reqbufs:1174: =
Failed to allocate encoding buffers
>>=20
>>=20
>> A user reported even adding s5p_mfc.mem=3D64M did not make the =
encoder work.
>> Any thoughts?
>=20
> Thanks for the report. Could you provide a bit more information about =
the encoder configuration (selected format, frame size, etc). 23MiB for =
the temporary buffer seems to be a bit large value, but I would like to =
reproduce it here and check what can be done to avoid allocating it from =
the preallocated buffer.
>=20
>=20
>=20
>=20
>> Thanks,
>> M.
>>=20
>> (resent in plain text format)
>>=20
>>> On 17 Mar. 2017, at 10:36 pm, Andrzej Hajda <a.hajda@samsung.com> =
wrote:
>>>=20
>>> Hi Marian,
>>>=20
>>> On 15.03.2017 12:36, Marian Mihailescu wrote:
>>>> Hi,
>>>>=20
>>>> After testing these patches, encoding using MFC fails when =
requesting
>>>> buffers for capture (it works for output) with ENOMEM (it complains =
it
>>>> cannot allocate memory on bank1).
>>>> Did anyone else test encoding?
>>> I have tested encoding and it works on my test target. Could you =
provide
>>> more details of your setup:
>>> - which kernel and patches,
>>> - which hw,
>>> - which test app.
>>>=20
>>> Regards
>>> Andrzej
>>>=20
>>>=20
>>>> Thanks,
>>>> Marian
>>>>=20
>>>> Either I've been missing something or nothing has been going on. =
(K. E. Gordon)
>>>>=20
>>=20
>>=20
>=20
> Best regards
> --=20
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
