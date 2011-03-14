Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab1CNKYB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 06:24:01 -0400
Message-ID: <4D7DED36.6040109@redhat.com>
Date: Mon, 14 Mar 2011 11:25:58 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: Missing V4L2_PIX_FMT_JPGL
References: <2392d6a7f50862a36201f8cbe7eaf18e.squirrel@webmail.xs4all.nl>
In-Reply-To: <2392d6a7f50862a36201f8cbe7eaf18e.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 03/14/2011 11:16 AM, Hans Verkuil wrote:
> Hi Hans,
>
> I just copied the latest videobuf2.h to v4l-utils and tried to compile,
> but it fails with:
>
> make[2]: Entering directory
> `/home/hve/work/src/v4l/v4l-utils/lib/libv4lconvert'
> cc -Wp,-MMD,"libv4lconvert.d",-MQ,"libv4lconvert.o",-MP -c -I../include
> -fvisibility=hidden -fPIC -DLIBDIR=\"/usr/local/lib\"
> -DLIBSUBDIR=\"libv4l\" -I../../include -I../../lib/include -D_GNU_SOURCE
> -DV4L_UTILS_VERSION='"0.8.4-test"' -g -O1 -Wall -Wpointer-arith
> -Wstrict-prototypes -Wmissing-prototypes -o libv4lconvert.o
> libv4lconvert.c
> libv4lconvert.c:73: error: 'V4L2_PIX_FMT_JPGL' undeclared here (not in a
> function)
>
> It seems V4L2_PIX_FMT_JPGL was removed. I guess the support for this
> format can be removed from libv4lconvert.c?
>

Actually it is not removed, it is not yet added. This is a new format
for devices using the (ancient) nw80x chipset. Jean Francois Moine has
been working on adding support for those to the gspca driver. I expect
a pull request from him soon, to add this driver to 2.6.39, and thus
the define to videodev2.h . In the mean time please leave the define
in v4l-utils's videodev2.h copy (insert it manually after syncing).

Regards,

Hans
