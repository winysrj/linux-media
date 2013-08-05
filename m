Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52478 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab3HEGvp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 02:51:45 -0400
Received: by mail-wg0-f42.google.com with SMTP id j13so1076337wgh.3
        for <linux-media@vger.kernel.org>; Sun, 04 Aug 2013 23:51:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375101661-6493-3-git-send-email-hverkuil@xs4all.nl>
References: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl> <1375101661-6493-3-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 5 Aug 2013 12:21:24 +0530
Message-ID: <CA+V-a8vvSQrA4s-80adJfvaOYvLU=mOZ65Zmkn6eyMGs36Parw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/8] v4l2-dv-timings: add new helper module.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch, this will still simplify driver writing :-)

On Mon, Jul 29, 2013 at 6:10 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This module makes it easy to filter valid timings from the full list of
> CEA and DMT timings based on the timings capabilities.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
