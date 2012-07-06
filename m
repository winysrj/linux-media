Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33048 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab2GFOdj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 10:33:39 -0400
Received: by gglu4 with SMTP id u4so8639493ggl.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 07:33:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+X3=8kcyz30cqYAH7nunEZyKpvkq0gh70_TB-r-jbutig@mail.gmail.com>
References: <1339509222-2714-1-git-send-email-elezegarcia@gmail.com>
	<1339509222-2714-2-git-send-email-elezegarcia@gmail.com>
	<4FF5C77C.7030500@redhat.com>
	<CALF0-+XzNOiM+TA3rzY2NGSyXgFL8SuVU_yP0GTpcFMavQmNSg@mail.gmail.com>
	<CALF0-+X3=8kcyz30cqYAH7nunEZyKpvkq0gh70_TB-r-jbutig@mail.gmail.com>
Date: Fri, 6 Jul 2012 11:33:38 -0300
Message-ID: <CALF0-+UqVy8PzgkNzqH3bdML1QWye+XMTx_-YrmnKGE0s_XepQ@mail.gmail.com>
Subject: Re: [PATCH] em28xx: Remove useless runtime->private_data usage
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

On Thu, Jul 5, 2012 at 2:22 PM, Ezequiel Garcia >> Are you sure that
this can be removed? I think this is used internally
>> by the alsa API, but maybe something has changed and this is not
>> required anymore.
>
> Yes, I'm sure.
>

This should be: "I'm almost sure" :-)
Anyway, probably the patch should have a more verbose commit
message, right?

Do you want to do drop it entirely?

Regards,
Ezequiel.
