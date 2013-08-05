Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:53253 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab3HEG67 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 02:58:59 -0400
Received: by mail-we0-f173.google.com with SMTP id x55so2150212wes.32
        for <linux-media@vger.kernel.org>; Sun, 04 Aug 2013 23:58:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375101661-6493-4-git-send-email-hverkuil@xs4all.nl>
References: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl> <1375101661-6493-4-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 5 Aug 2013 12:28:37 +0530
Message-ID: <CA+V-a8ssiuH_cG_Bj2wjOY4zN=8th8qgT42hd93ThnAxnrbWjg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/8] v4l2: move dv-timings related code to v4l2-dv-timings.c
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
> v4l2-common.c contained a bunch of dv-timings related functions.
> Move that to the new v4l2-dv-timings.c which is a more appropriate
> place for them.
>
> There aren't many drivers that do HDTV, so it is a good idea to separate
> common code related to that into a module of its own.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
