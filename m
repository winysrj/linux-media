Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:60862 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755898AbcKCMrm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Nov 2016 08:47:42 -0400
Subject: Re: [PATCH next 1/2] media: mtk-mdp: fix video_device_release
 argument
To: =?UTF-8?Q?Vincent_Stehl=c3=a9?= <vincent.stehle@laposte.net>
References: <1473340146-6598-4-git-send-email-minghsiu.tsai@mediatek.com>
 <20161027202325.20680-1-vincent.stehle@laposte.net>
 <20161028075253.gdy2bbugih6oqncw@romuald.bergerie>
Cc: linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dbaa8b70-ea72-7d9b-176c-6c0a816aaae8@xs4all.nl>
Date: Thu, 3 Nov 2016 13:47:35 +0100
MIME-Version: 1.0
In-Reply-To: <20161028075253.gdy2bbugih6oqncw@romuald.bergerie>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vincent,

On 28/10/16 09:52, Vincent Stehlé wrote:
> On Thu, Oct 27, 2016 at 10:23:24PM +0200, Vincent Stehlé wrote:
>> video_device_release() takes a pointer to struct video_device as argument.
>> Fix two call sites where the address of the pointer is passed instead.
>
> Sorry, I messed up: please ignore that "fix". The 0day robot made me
> realize this is indeed not a proper fix.
>
> The issue remains, though: we cannot call video_device_release() on the
> vdev structure member, as this will in turn call kfree(). Most probably,
> vdev needs to be dynamically allocated, or the call to
> video_device_release() dropped completely.

I prefer that vdev is dynamically allocated. There are known problems with
embedded video_device structs, so allocating it is preferred.

Minghsiu, can you do that?

Regards,

	Hans

>
> Sorry for the bad patch.
>
> Best regards,
>
> Vincent.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
