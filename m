Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:51279 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967755Ab3E3HVb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 May 2013 03:21:31 -0400
Received: by mail-we0-f173.google.com with SMTP id p57so7092954wes.32
        for <linux-media@vger.kernel.org>; Thu, 30 May 2013 00:21:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369825211-29770-29-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl> <1369825211-29770-29-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 30 May 2013 12:51:09 +0530
Message-ID: <CA+V-a8vVs09SJmY5DD0pBc+OR3YeNCB-JD44psXVWSjDS6opXQ@mail.gmail.com>
Subject: Re: [PATCHv1 28/38] vpbe_display: drop g/s_register ioctls.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Wed, May 29, 2013 at 4:30 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> These are no longer needed: register access to subdevices no longer needs
> the bridge driver to forward them.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
