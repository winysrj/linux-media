Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:42118 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbeHIV6J (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 17:58:09 -0400
Received: by mail-io0-f196.google.com with SMTP id n18-v6so5708637ioa.9
        for <linux-media@vger.kernel.org>; Thu, 09 Aug 2018 12:31:52 -0700 (PDT)
MIME-Version: 1.0
References: <20180809181103.15437-1-matwey@sai.msu.ru>
In-Reply-To: <20180809181103.15437-1-matwey@sai.msu.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Aug 2018 12:31:40 -0700
Message-ID: <CAADWXX-bXeVdWPrn3BeA=wF3d4rn1S69BYhf398_=T=NF2t44A@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
To: matwey@sai.msu.ru
Cc: linux-media@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        matwey.kornilov@gmail.com, tfiga@chromium.org,
        laurent.pinchart@ideasonboard.com, stern@rowland.harvard.edu,
        ezequiel@collabora.com, hdegoede@redhat.com, hverkuil@xs4all.nl,
        mchehab@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        mingo@redhat.com, isely@pobox.com, bhumirks@gmail.com,
        Colin Ian King <colin.king@canonical.com>,
        kieran.bingham@ideasonboard.com, keiichiw@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Matwey,
 your DKIM signature is garbage, and it causes your emails to be
marked as spam when they go through a mailing list.

The reason is this:

  DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;

where the problem is that the "sender" field is included in the DKIM
hash calculation.

That is completely incorrect, since a mailing list will - by
definition - change the sender to the list, not the original sender.

This is not a mailing list bug. This is a bug in your DKIM setup on
the sending side.

I'm leaving everybody cc'd., because this problem is starting to be
annoyingly common. We had two people with chromium.org addresses with
the same misconfiguration, and I want people to be aware of this.

I get too much email, and too much spam, and so when people have
misc-onfigured email sending that causes problems for spam systems, it
needs to get fixed.

Your situation *may* be the same as the Chromium guys. Quoting Doug:

 "Looks like it's all fixed.  Both Kees and I setup our chromium.org
  accounts a long time ago.  IIRC during that time the suggested way to
  do things was that you'd use your @google.com SMTP settings even when
  you were sending as your @chroumium.org account.  These days it
  doesn't appear that there's even any UI in gmail to configure things
  that way, so presumably nobody else will be stuck in the same hole
  that Kees and I were in"

and he may have been wrong about that "presumably nobody else will be
stuck in the same hole" guess.

So you might want to check what the SMTP settings are for your setup.

               Linus
