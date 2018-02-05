Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:32912 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752925AbeBEQV5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Feb 2018 11:21:57 -0500
Received: by mail-wm0-f49.google.com with SMTP id x4-v6so13892387wmc.0
        for <linux-media@vger.kernel.org>; Mon, 05 Feb 2018 08:21:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <be1babc7-ed0b-8853-19e8-43b20a6f4c17@xs4all.nl>
References: <be1babc7-ed0b-8853-19e8-43b20a6f4c17@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Mon, 5 Feb 2018 08:21:54 -0800
Message-ID: <CAJ+vNU12FEWf6+FUdsYjJhjxZbiBmjR6RurNc4W-xC-ZsMTp+A@mail.gmail.com>
Subject: Re: Please help test the new v4l-subdev support in v4l2-compliance
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 3, 2018 at 7:56 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Tim, Jacopo,
>
> I have now finished writing the v4l2-compliance tests for the various v4l=
-subdev
> ioctls. I managed to test some with the vimc driver, but that doesn't imp=
lement all
> ioctls, so I could use some help testing my test code :-)
>
> To test you first need to apply these patches to your kernel:
>
> https://patchwork.linuxtv.org/patch/46817/
> https://patchwork.linuxtv.org/patch/46822/
>
> Otherwise the compliance test will fail a lot.
>
> Now run v4l2-compliance -u /dev/v4l-subdevX (or -uX as a shortcut) and se=
e what
> happens.
>
> I have tested the following ioctls with vimc, so they are likely to be co=
rrect:
>
> #define VIDIOC_SUBDEV_G_FMT                     _IOWR('V',  4, struct v4l=
2_subdev_format)
> #define VIDIOC_SUBDEV_S_FMT                     _IOWR('V',  5, struct v4l=
2_subdev_format)
> #define VIDIOC_SUBDEV_ENUM_MBUS_CODE            _IOWR('V',  2, struct v4l=
2_subdev_mbus_code_enum)
> #define VIDIOC_SUBDEV_ENUM_FRAME_SIZE           _IOWR('V', 74, struct v4l=
2_subdev_frame_size_enum)
>
> All others are untested:
>
> #define VIDIOC_SUBDEV_G_FRAME_INTERVAL          _IOWR('V', 21, struct v4l=
2_subdev_frame_interval)
> #define VIDIOC_SUBDEV_S_FRAME_INTERVAL          _IOWR('V', 22, struct v4l=
2_subdev_frame_interval)
> #define VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL       _IOWR('V', 75, struct v4l=
2_subdev_frame_interval_enum)
> #define VIDIOC_SUBDEV_G_CROP                    _IOWR('V', 59, struct v4l=
2_subdev_crop)
> #define VIDIOC_SUBDEV_S_CROP                    _IOWR('V', 60, struct v4l=
2_subdev_crop)
> #define VIDIOC_SUBDEV_G_SELECTION               _IOWR('V', 61, struct v4l=
2_subdev_selection)
> #define VIDIOC_SUBDEV_S_SELECTION               _IOWR('V', 62, struct v4l=
2_subdev_selection)
> #define VIDIOC_SUBDEV_G_EDID                    _IOWR('V', 40, struct v4l=
2_edid)
> #define VIDIOC_SUBDEV_S_EDID                    _IOWR('V', 41, struct v4l=
2_edid)
> #define VIDIOC_SUBDEV_S_DV_TIMINGS              _IOWR('V', 87, struct v4l=
2_dv_timings)
> #define VIDIOC_SUBDEV_G_DV_TIMINGS              _IOWR('V', 88, struct v4l=
2_dv_timings)
> #define VIDIOC_SUBDEV_ENUM_DV_TIMINGS           _IOWR('V', 98, struct v4l=
2_enum_dv_timings)
> #define VIDIOC_SUBDEV_QUERY_DV_TIMINGS          _IOR('V', 99, struct v4l2=
_dv_timings)
> #define VIDIOC_SUBDEV_DV_TIMINGS_CAP            _IOWR('V', 100, struct v4=
l2_dv_timings_cap)
>
> I did the best I could, but there may very well be bugs in the test code.
>
> I will also test the timings and edid ioctls myself later next week at wo=
rk.
>
> The v4l2-compliance utility can now also test media devices (-m option), =
although that's
> early days yet. Eventually I want to be able to walk the graph and test e=
ach device in
> turn.
>
> I have this idea of making v4l2-compliance, cec-compliance and media-comp=
liance
> frontends that can all share the actual test code. And perhaps that can i=
nclude a new
> dvb-compliance as well.
>
> However, that's future music, for now I just want to get proper ioctl tes=
t coverage
> so driver authors can at least have some confidence in their code by runn=
ing these
> tests.
>

Hans,

I'm failing compile (of master 4ee9911) with:

  CXX      v4l2_compliance-media-info.o
media-info.cpp: In function =E2=80=98media_type media_detect_type(const cha=
r*)=E2=80=99:
media-info.cpp:79:39: error: no matching function for call to
=E2=80=98std::basic_ifstream<char>::basic_ifstream(std::__cxx11::string&)=
=E2=80=99
  std::ifstream uevent_file(uevent_path);
                                       ^
In file included from media-info.cpp:35:0:
/usr/include/c++/5/fstream:495:7: note: candidate:
std::basic_ifstream<_CharT, _Traits>::basic_ifstream(const char*,
std::ios_base::openmode) [with _CharT =3D char; _Traits =3D
std::char_traits<char>; std::ios_base::openmode =3D std::_Ios_Openmode]
       basic_ifstream(const char* __s, ios_base::openmode __mode =3D ios_ba=
se::in)
       ^
/usr/include/c++/5/fstream:495:7: note:   no known conversion for
argument 1 from =E2=80=98std::__cxx11::string {aka
std::__cxx11::basic_string<char>}=E2=80=99 to =E2=80=98const char*=E2=80=99
In file included from media-info.cpp:35:0:
/usr/include/c++/5/fstream:481:7: note: candidate:
std::basic_ifstream<_CharT, _Traits>::basic_ifstream() [with _CharT =3D
char; _Traits =3D std::char_traits<char>]
       basic_ifstream() : __istream_type(), _M_filebuf()
       ^
/usr/include/c++/5/fstream:481:7: note:   candidate expects 0
arguments, 1 provided
In file included from media-info.cpp:35:0:
/usr/include/c++/5/fstream:455:11: note: candidate:
std::basic_ifstream<char>::basic_ifstream(const
std::basic_ifstream<char>&)
     class basic_ifstream : public basic_istream<_CharT, _Traits>
           ^
/usr/include/c++/5/fstream:455:11: note:   no known conversion for
argument 1 from =E2=80=98std::__cxx11::string {aka
std::__cxx11::basic_string<char>}=E2=80=99 to =E2=80=98const
std::basic_ifstream<char>&=E2=80=99
media-info.cpp: In function =E2=80=98std::__cxx11::string
media_get_device(__u32, __u32)=E2=80=99:
media-info.cpp:120:39: error: no matching function for call to
=E2=80=98std::basic_ifstream<char>::basic_ifstream(std::__cxx11::string&)=
=E2=80=99
  std::ifstream uevent_file(uevent_path);
                                       ^
In file included from media-info.cpp:35:0:
/usr/include/c++/5/fstream:495:7: note: candidate:
std::basic_ifstream<_CharT, _Traits>::basic_ifstream(const char*,
std::ios_base::openmode) [with _CharT =3D char; _Traits =3D
std::char_traits<char>; std::ios_base::openmode =3D std::_Ios_Openmode]
       basic_ifstream(const char* __s, ios_base::openmode __mode =3D ios_ba=
se::in)
       ^
/usr/include/c++/5/fstream:495:7: note:   no known conversion for
argument 1 from =E2=80=98std::__cxx11::string {aka
std::__cxx11::basic_string<char>}=E2=80=99 to =E2=80=98const char*=E2=80=99
In file included from media-info.cpp:35:0:
/usr/include/c++/5/fstream:481:7: note: candidate:
std::basic_ifstream<_CharT, _Traits>::basic_ifstream() [with _CharT =3D
char; _Traits =3D std::char_traits<char>]
       basic_ifstream() : __istream_type(), _M_filebuf()
       ^
/usr/include/c++/5/fstream:481:7: note:   candidate expects 0
arguments, 1 provided
In file included from media-info.cpp:35:0:
/usr/include/c++/5/fstream:455:11: note: candidate:
std::basic_ifstream<char>::basic_ifstream(const
std::basic_ifstream<char>&)
     class basic_ifstream : public basic_istream<_CharT, _Traits>
           ^
/usr/include/c++/5/fstream:455:11: note:   no known conversion for
argument 1 from =E2=80=98std::__cxx11::string {aka
std::__cxx11::basic_string<char>}=E2=80=99 to =E2=80=98const
std::basic_ifstream<char>&=E2=80=99
Makefile:746: recipe for target 'v4l2_compliance-media-info.o' failed
make[3]: *** [v4l2_compliance-media-info.o] Error 1
make[3]: Leaving directory '/usr/src/v4l-utils/utils/v4l2-compliance'
Makefile:469: recipe for target 'all-recursive' failed
make[2]: *** [all-recursive] Error 1
make[2]: Leaving directory '/usr/src/v4l-utils/utils'
Makefile:582: recipe for target 'all-recursive' failed
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory '/usr/src/v4l-utils'
Makefile:509: recipe for target 'all' failed
make: *** [all] Error 2
tharvey@tharvey:/usr/src/v4l-utils$  git logshort | head
4ee9911 (HEAD -> master, origin/master, origin/HEAD) v4l2-ctl: improve
the fps calculation when streaming
b2f8f90 v4l2-compliance: add type/function/intf_type checks
ed953f6 v4l2-compliance: improve pad flags tests
91e63b2 v4l2-compliance: improve G/S_EDID test
0561fdb v4l2-compliance: add -M option to test all /dev/mediaX interfaces
0b0cb31 v4l2-compliance/v4l2-ctl: more device detection improvements
a2c1b75 v4l2-compliance: move the main test code into a separate function
a209f23 v4l2-info: move mi_is_subdevice() to v4l2-info.cpp
824fa2d v4l2-compliance: refactor device handling
0aedeab cec: renamed cec-common to cec-info

I ran a 'make distclean; ./bootstrap.sh && ./configure && make'

last version I built successfully was '1bb8c70 v4l2-ctl: mention that
--set-subdev-fps is for testing only'

I haven't dug into the failure at all. Are you using something new
with c++ requiring a new lib or specific version of something that
needs to be added to configure?

Regards,

Tim
