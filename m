Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:41951 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834AbbHJIG7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 04:06:59 -0400
Message-ID: <55C85B85.1050506@xs4all.nl>
Date: Mon, 10 Aug 2015 10:06:29 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
CC: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v2 1/5] media: videobuf2: Rename videobuf2-core to
 videobuf2-v4l2
References: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com> <1438332277-6542-2-git-send-email-jh1009.sung@samsung.com>
In-Reply-To: <1438332277-6542-2-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Junghak,

On 07/31/2015 10:44 AM, Junghak Sung wrote:
> Rename file name - from videobuf2-core.[ch] to videobuf2-v4l2.[ch]
> This renaming patch should be accompanied by the modifications for all device
> drivers that include this header file. It can be done with just running this
> shell script.
> 
> replace()
> {
> str1=$1
> str2=$2
> dir=$3
> for file in $(find $dir -name *.h -o -name *.c -o -name Makefile)
> do
>     echo $file
>     sed "s/$str1/$str2/g" $file > $file.out
>     mv $file.out $file
> done
> }
> replace "videobuf2-core" "videobuf2-v4l2" "include/media/"
> replace "videobuf2-core" "videobuf2-v4l2" "drivers/media/"
> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>

Rather than moving videobuf2-core.c to videobuf2-v4l2.c I would recommend to just
create a videobuf2-v4l2.h header that includes videobuf2-core.h and nothing else.

So this patch will move all drivers over to include the new videobuf2-v4l2.h header,
leaving everything else unchanged.

Then in patch 3 you can move code from videobuf2-core.c/h to videobuf2-v4l2.c/h. This
will make patch 3 easier to read for me since I can clearly see in the diff what
has been moved from -core.c/h to -v4l2.c/h.

Right now patch 3 shows what moved from -v4l2.c/h to -core.c/h, which is the wrong
way around. And makes patch 3 much larger than it needs to be since (unsurprisingly)
most code from v4l2.c/h moves back to core.c/h.

Regards,

	Hans
