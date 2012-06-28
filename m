Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47131 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2F1ECI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 00:02:08 -0400
Received: by obbuo13 with SMTP id uo13so2440059obb.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2012 21:02:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340835544-12053-1-git-send-email-peter.senna@gmail.com>
References: <1340835544-12053-1-git-send-email-peter.senna@gmail.com>
Date: Thu, 28 Jun 2012 01:02:07 -0300
Message-ID: <CALF0-+XZybEFqndCEo4nGGH-achE5CuYOsC+EXiH-k06GSB5vA@mail.gmail.com>
Subject: Re: [PATCH] [V2] stv090x: variable 'no_signal' set but not used
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guy Martin <gmsoft@tuxicoman.be>,
	Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Peter,

On Wed, Jun 27, 2012 at 7:18 PM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> -                       no_signal = stv090x_chk_signal(state);
> +                       (void) stv090x_chk_signal(state);

Why are you casting return to void? I can't see there is a reason to it.

Regards,
Ezequiel.
