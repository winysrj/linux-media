Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:45720 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbeHJK6F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 06:58:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAADWXX-bXeVdWPrn3BeA=wF3d4rn1S69BYhf398_=T=NF2t44A@mail.gmail.com>
References: <20180809181103.15437-1-matwey@sai.msu.ru> <CAADWXX-bXeVdWPrn3BeA=wF3d4rn1S69BYhf398_=T=NF2t44A@mail.gmail.com>
From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Date: Fri, 10 Aug 2018 11:28:53 +0300
Message-ID: <CAJs94EamyYZQo+AYZtBGYP4qk-82QqOQa-qW7UiRCFqmmBzGsA@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        keiichiw@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Thanks for pointing it out, I'll try to do my best to avoid this in future.

As I see now, in my case, the 'sender' in DKIM is triggered when using
GMail with alien domain in "Send From:".
I would not say that it is configuration "bug" (at least I can imagine
why do they do that), but it definitely must be avoided for maillists.
It is also interesting that if I use alien "From" email address with
google-apps (g suite) domain, then GMail generated two DKIM-Signature
headers, both for gmail.com and for the google-apps domain.


2018-08-09 22:31 GMT+03:00 Linus Torvalds <torvalds@linux-foundation.org>:
> Matwey,
>  your DKIM signature is garbage, and it causes your emails to be
> marked as spam when they go through a mailing list.
>
> The reason is this:
>
>   DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
>         d=gmail.com; s=20161025;
>         h=sender:from:to:cc:subject:date:message-id;
>
> where the problem is that the "sender" field is included in the DKIM
> hash calculation.
>
> That is completely incorrect, since a mailing list will - by
> definition - change the sender to the list, not the original sender.
>
> This is not a mailing list bug. This is a bug in your DKIM setup on
> the sending side.
>
> I'm leaving everybody cc'd., because this problem is starting to be
> annoyingly common. We had two people with chromium.org addresses with
> the same misconfiguration, and I want people to be aware of this.
>
> I get too much email, and too much spam, and so when people have
> misc-onfigured email sending that causes problems for spam systems, it
> needs to get fixed.
>
> Your situation *may* be the same as the Chromium guys. Quoting Doug:
>
>  "Looks like it's all fixed.  Both Kees and I setup our chromium.org
>   accounts a long time ago.  IIRC during that time the suggested way to
>   do things was that you'd use your @google.com SMTP settings even when
>   you were sending as your @chroumium.org account.  These days it
>   doesn't appear that there's even any UI in gmail to configure things
>   that way, so presumably nobody else will be stuck in the same hole
>   that Kees and I were in"
>
> and he may have been wrong about that "presumably nobody else will be
> stuck in the same hole" guess.
>
> So you might want to check what the SMTP settings are for your setup.
>
>                Linus

-- 
With best regards,
Matwey V. Kornilov
