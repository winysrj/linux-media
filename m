Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:39487 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab3GRMdl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 08:33:41 -0400
Received: by mail-ob0-f177.google.com with SMTP id ta17so3587812obb.22
        for <linux-media@vger.kernel.org>; Thu, 18 Jul 2013 05:33:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF0Ff2mycZXUK_3OHE9L59eRyYsKNbRmq-je_ieKm=BbMyXpMA@mail.gmail.com>
References: <1374111202-23288-1-git-send-email-ljalvs@gmail.com>
	<CAF0Ff2mycZXUK_3OHE9L59eRyYsKNbRmq-je_ieKm=BbMyXpMA@mail.gmail.com>
Date: Thu, 18 Jul 2013 13:33:40 +0100
Message-ID: <CAGj5WxC+y-pNOE2WJ6==Tnkwx0gYCjqDr5Usfo6bYd7OW0tP+g@mail.gmail.com>
Subject: Re: [PATCH] cx23885: Fix interrupt storm that happens in some cards
 when IR is enabled.
From: Luis Alves <ljalvs@gmail.com>
To: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Konstantin,

It was not my intention to send this piece of code as a patch to be
upstreamed. My apologies for that misunderstanding.
My intention was just to send something for people to try and see if
it solves the interrupt spam in their cards.
I should have sent it just as a normal email to the list.

You are right that I don't fully understand what those registers
control because unfortunately there is no public documentation
available (even for end of life products). But Andy Walls seem to have
a very good explanation.

I just disagree about knowing the author of this code... I had no clue
it was you, all I knew is that it came from tbs under GPL.
But if you say you are, I believe you and give you all the credit...

To be honest I just want my tbs card to work as it should.

Regards,
Luis
