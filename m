Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:48893 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab3HEIXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 04:23:50 -0400
Received: by mail-wg0-f54.google.com with SMTP id e12so1078301wgh.33
        for <linux-media@vger.kernel.org>; Mon, 05 Aug 2013 01:23:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375101661-6493-8-git-send-email-hverkuil@xs4all.nl>
References: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl> <1375101661-6493-8-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 5 Aug 2013 13:53:28 +0530
Message-ID: <CA+V-a8t5VK4EO3Qn3uM7e_125Od8ppZf1EVGvCHX0aC2gufrWA@mail.gmail.com>
Subject: Re: [RFC PATCH 7/8] v4l2: use new V4L2_DV_BT_BLANKING/FRAME defines
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Mon, Jul 29, 2013 at 6:11 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Use the new blanking and frame size defines. This also fixed a bug in
> these drivers: they assumed that the height for interlaced formats was
> the field height, however height is the frame height. So the height
> for a field is actually bt->height / 2.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
