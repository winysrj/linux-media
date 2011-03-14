Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3469 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab1CNKQZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 06:16:25 -0400
Message-ID: <2392d6a7f50862a36201f8cbe7eaf18e.squirrel@webmail.xs4all.nl>
Date: Mon, 14 Mar 2011 11:16:12 +0100
Subject: Missing V4L2_PIX_FMT_JPGL
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hans de Goede" <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

I just copied the latest videobuf2.h to v4l-utils and tried to compile,
but it fails with:

make[2]: Entering directory
`/home/hve/work/src/v4l/v4l-utils/lib/libv4lconvert'
cc -Wp,-MMD,"libv4lconvert.d",-MQ,"libv4lconvert.o",-MP -c -I../include
-fvisibility=hidden -fPIC -DLIBDIR=\"/usr/local/lib\"
-DLIBSUBDIR=\"libv4l\" -I../../include -I../../lib/include -D_GNU_SOURCE
-DV4L_UTILS_VERSION='"0.8.4-test"' -g -O1 -Wall -Wpointer-arith
-Wstrict-prototypes -Wmissing-prototypes -o libv4lconvert.o
libv4lconvert.c
libv4lconvert.c:73: error: 'V4L2_PIX_FMT_JPGL' undeclared here (not in a
function)

It seems V4L2_PIX_FMT_JPGL was removed. I guess the support for this
format can be removed from libv4lconvert.c?

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

