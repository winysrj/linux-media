Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47096 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033Ab2F0Ok6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 10:40:58 -0400
Received: by obbuo13 with SMTP id uo13so1548529obb.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2012 07:40:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE8D38B.2090700@gmail.com>
References: <1340476571-10832-1-git-send-email-elezegarcia@gmail.com>
	<4FE8D38B.2090700@gmail.com>
Date: Wed, 27 Jun 2012 11:40:57 -0300
Message-ID: <CALF0-+VAqbYcGZ0X9ZxX4H8LsD2mt3Oi=WtW82k01hN2T3gh+w@mail.gmail.com>
Subject: Re: [RFC/PATCH v3] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 25, 2012 at 6:09 PM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Ezequiel,
>
> a few minor comments below...

Hi Sylwester,

I'm OK with every comment you made.

Except for the -ETIMEDOUT.
I'm still not 100% convinced, but I'll take your word for it.

Also, is there any other serious issue preventing us from replacing
staging/easycap
with stk1160?

Thank a lot for your review,
Ezequiel.
