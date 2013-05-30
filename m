Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:45243 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967670Ab3E3HH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 May 2013 03:07:59 -0400
Received: by mail-we0-f179.google.com with SMTP id m46so6931795wev.38
        for <linux-media@vger.kernel.org>; Thu, 30 May 2013 00:07:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369837147-8747-8-git-send-email-hverkuil@xs4all.nl>
References: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl> <1369837147-8747-8-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 30 May 2013 12:37:38 +0530
Message-ID: <CA+V-a8vdBLLUiLucac3NmJGf+4kAV2dRu3pPOv5qGRDKsD+21A@mail.gmail.com>
Subject: Re: [RFC PATCH 07/14] tvp514x: fix querystd
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Wed, May 29, 2013 at 7:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Return V4L2_STD_UNKNOWN if no signal is detected.
> Otherwise AND the standard mask with the detected standards.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
