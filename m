Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:51728 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaDCPhb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 11:37:31 -0400
Received: by mail-oa0-f48.google.com with SMTP id m1so2118722oag.21
        for <linux-media@vger.kernel.org>; Thu, 03 Apr 2014 08:37:30 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 3 Apr 2014 08:37:30 -0700
Message-ID: <CABMudhSmmvMpEou8pwvUPma0sEiP1gjsx7+NYUM=6K-rS-TOsg@mail.gmail.com>
Subject: How to flush v4l2 drive
From: m silverstri <michael.j.silverstri@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I read this mail posting about flush operation.

https://www.mail-archive.com/linux-media@vger.kernel.org/msg41867.html

My user side application talks to v4l2 driver like this, as an
example, I put qbuf/dqbuf loop 10 times:

open
stream on

for (int i = 0; i < 10; i++)
    qbuf
    dqbuf
    // process the buffer

stream off
close

>From the message, it said  "close/streamoff() does an implicit immediate stop.
"

But how can I 'flush the stream before my last dqbuf() buffer (i.e.
when i is 9)? When close/streamoff() does an implict stop/flush, I
have already dequf my last buffer, so my application won't see the
'flushed' content.

How can I fix this?

Thank you.
