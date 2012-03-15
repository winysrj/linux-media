Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63742 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032342Ab2COVmL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 17:42:11 -0400
Received: by ghrr11 with SMTP id r11so3574790ghr.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 14:42:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120315213542.GB25362@redhat.com>
References: <1331844829-1166-1-git-send-email-elezegarcia@gmail.com>
	<20120315213542.GB25362@redhat.com>
Date: Thu, 15 Mar 2012 18:42:09 -0300
Message-ID: <CALF0-+Wcdvi35R9C36ZdU8yU0Dgsq6O5MexhfD9FqJEC765Xwg@mail.gmail.com>
Subject: Re: [PATCH v2] media: rc: Pospone ir raw decoders loading until
 really needed
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jarod,

On Thu, Mar 15, 2012 at 6:35 PM, Jarod Wilson <jarod@redhat.com> wrote:
>
> So yeah, ok, I'm fine with this. Haven't tested it with actual raw IR
> hardware, but I don't see any reason it wouldn't work.
>
> Acked-by: Jarod Wilson <jarod@redhat.com>

Thanks for the feedback.
I have a paranoid question: Is it ok to solve this with a static variable?
I don't like static (as I fear globals), but in this case I saw no
cleaner solution.

Thanks again,
Ezequiel.
