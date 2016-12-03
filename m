Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34383 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750900AbcLCHHJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Dec 2016 02:07:09 -0500
MIME-Version: 1.0
In-Reply-To: <1480748521-8738-1-git-send-email-shilpapri@gmail.com>
References: <1480748521-8738-1-git-send-email-shilpapri@gmail.com>
From: Allen <allen.lkml@gmail.com>
Date: Sat, 3 Dec 2016 12:36:13 +0530
Message-ID: <CAOMdWSLbJ+p52i=X3NEhucm9g5OX76rvT31z+UP8FGib6+gw4Q@mail.gmail.com>
Subject: Re: [PATCH] staging: Replaced BUG_ON with warnings
To: Shilpa Puttegowda <shilpapri@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 3, 2016 at 12:32 PM, Shilpa Puttegowda <shilpapri@gmail.com> wrote:
> From: Shilpa P <shilpapri@gmail.com>
>
> Don't crash the Kernel for driver errors
>
> Signed-off-by: Shilpa P <shilpapri@gmail.com>
> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>

Acked-by: Allen Pais <allen.lkml@gmail.com>
