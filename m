Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41033 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab2HINsR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 09:48:17 -0400
Received: by pbbrr13 with SMTP id rr13so939435pbb.19
        for <linux-media@vger.kernel.org>; Thu, 09 Aug 2012 06:48:17 -0700 (PDT)
References: <20120809125501.GD3824@b20223-02.ap.freescale.net> <201208091519.19254.hverkuil@xs4all.nl>
In-Reply-To: <201208091519.19254.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: __video_register_device: warning cannot be reached if warn_if_nr_in_use
From: Richard Zhao <linuxzsc@gmail.com>
Date: Thu, 09 Aug 2012 21:40:56 +0800
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Richard Zhao <richard.zhao@freescale.com>
CC: linux-media@vger.kernel.org
Message-ID: <277dc57d-9b9a-47a3-bda7-258445de9fec@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hans Verkuil <hverkuil@xs4all.nl> wrote:

>On Thu August 9 2012 14:55:02 Richard Zhao wrote:
>> In file drivers/media/video/v4l2-dev.c
>> 
>> int __video_register_device(struct video_device *vdev, int type, int
>nr,
>> 		int warn_if_nr_in_use, struct module *owner)
>> {
>> [...]
>> 	vdev->minor = i + minor_offset;
>> 878:	vdev->num = nr;
>> 
>> vdev->num is set to nr here. 
>> [...]
>> 	if (nr != -1 && nr != vdev->num && warn_if_nr_in_use)
>> 		printk(KERN_WARNING "%s: requested %s%d, got %s\n", __func__,
>> 			name_base, nr, video_device_node_name(vdev));
>> 
>> so nr != vdev->num is always false. The warning can never be printed.
>
>Hmm, true. The question is, should we just fix this, or drop the
>warning altogether?
>Clearly nobody missed that warning.
>
>I'm inclined to drop the warning altogether and so also the
>video_register_device_no_warn
>inline function.
>
>What do others think?
+1

Richard
>
>	Hans
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
>From android phone
