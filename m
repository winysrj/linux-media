Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:60311 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab3HEHDk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 03:03:40 -0400
Received: by mail-wg0-f48.google.com with SMTP id f12so2103935wgh.27
        for <linux-media@vger.kernel.org>; Mon, 05 Aug 2013 00:03:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375101661-6493-6-git-send-email-hverkuil@xs4all.nl>
References: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl> <1375101661-6493-6-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 5 Aug 2013 12:33:18 +0530
Message-ID: <CA+V-a8tC-MUUW4RLf7EFzrxaLZW5jKyYKvWtbKy8s9qc5xYmGw@mail.gmail.com>
Subject: Re: [RFC PATCH 5/8] videodev2.h: defines to calculate blanking and
 frame sizes
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Mon, Jul 29, 2013 at 6:10 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> It is very common to have to calculate the total width and height of the
> blanking and the full frame, so add a few defines that deal with that.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
