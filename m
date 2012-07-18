Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57255 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab2GRW0n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 18:26:43 -0400
Received: by vbbff1 with SMTP id ff1so1478716vbb.19
        for <linux-media@vger.kernel.org>; Wed, 18 Jul 2012 15:26:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340308332-1118-10-git-send-email-elezegarcia@gmail.com>
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
	<1340308332-1118-10-git-send-email-elezegarcia@gmail.com>
Date: Wed, 18 Jul 2012 19:26:41 -0300
Message-ID: <CADThq4+29av-MeYZR8KfBiBQkFPx+OpWhe40Kk+WX1yUD=4dOA@mail.gmail.com>
Subject: Re: [PATCH 10/10] staging: solo6x10: Avoid extern declaration by
 reworking module parameter
From: Ismael Luceno <ismael.luceno@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 21, 2012 at 4:52 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> This patch moves video_nr module parameter to core.c
> and then passes that parameter as an argument to functions
> that need it.
> This way we avoid the extern declaration and parameter
> dependencies are better exposed.
<...>

NACK.

The changes to video_nr are supposed to be preserved.
