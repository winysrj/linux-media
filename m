Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:34682 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752925AbeBEQtL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Feb 2018 11:49:11 -0500
Received: by mail-wm0-f54.google.com with SMTP id j21-v6so14044534wmh.1
        for <linux-media@vger.kernel.org>; Mon, 05 Feb 2018 08:49:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ea5892a3-9fe3-953f-c16c-55329d5d2f76@xs4all.nl>
References: <be1babc7-ed0b-8853-19e8-43b20a6f4c17@xs4all.nl>
 <CAJ+vNU12FEWf6+FUdsYjJhjxZbiBmjR6RurNc4W-xC-ZsMTp+A@mail.gmail.com> <ea5892a3-9fe3-953f-c16c-55329d5d2f76@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Mon, 5 Feb 2018 08:49:09 -0800
Message-ID: <CAJ+vNU3tA=FtO6f-1UK+dNkL4q5kOAZMWrcQzY-U1dOzgHpDPw@mail.gmail.com>
Subject: Re: Please help test the new v4l-subdev support in v4l2-compliance
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 5, 2018 at 8:27 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 02/05/2018 05:21 PM, Tim Harvey wrote:
>
> <snip>
>
>>
>> I ran a 'make distclean; ./bootstrap.sh && ./configure && make'
>>
>> last version I built successfully was '1bb8c70 v4l2-ctl: mention that
>> --set-subdev-fps is for testing only'
>
> That's a lot of revisions ago. I've been busy last weekend :-)

right... I was up to date Thursday morning! ;)

>
> Do a new git pull and try again. I remember hitting something similar during
> the weekend where I was missing a C++ include.
>

Yes, I tried that on my x86 dev host - same failure as from my target.

>>
>> I haven't dug into the failure at all. Are you using something new
>> with c++ requiring a new lib or specific version of something that
>> needs to be added to configure?
>
> Nope, bog standard C++. Real C++ pros are probably appalled by the code.
>

Google to the rescue: The ifstream constructor expects a const char*,
so you need to do ifstream file(filename.c_str()); to make it work.

the following patch fixes it:

diff --git a/utils/common/media-info.cpp b/utils/common/media-info.cpp
index eef743e..39da9b8 100644
--- a/utils/common/media-info.cpp
+++ b/utils/common/media-info.cpp
@@ -76,7 +76,7 @@ media_type media_detect_type(const char *device)
        uevent_path += num2s(major(sb.st_rdev), false) + ":" +
                num2s(minor(sb.st_rdev), false) + "/uevent";

-       std::ifstream uevent_file(uevent_path);
+       std::ifstream uevent_file(uevent_path.c_str());
        if (uevent_file.fail())
                return MEDIA_TYPE_UNKNOWN;

@@ -117,7 +117,7 @@ std::string media_get_device(__u32 major, __u32 minor)
        sprintf(fmt, "%d:%d", major, minor);
        uevent_path += std::string(fmt) + "/uevent";

-       std::ifstream uevent_file(uevent_path);
+       std::ifstream uevent_file(uevent_path.c_str());
        if (uevent_file.fail())
                return "";

Tim
