Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:54621 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbaCRXSk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 19:18:40 -0400
Received: by mail-ob0-f170.google.com with SMTP id uz6so7588980obc.1
        for <linux-media@vger.kernel.org>; Tue, 18 Mar 2014 16:18:39 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 18 Mar 2014 16:18:39 -0700
Message-ID: <CABMudhQzWS7P6uSq=tQQY85JLkj+qdZEg+AbCSwVYFevp6gy-w@mail.gmail.com>
Subject: How can I feed more data to a stream after I stream on?
From: m silverstri <michael.j.silverstri@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am using v4l2 m2m framework to develop a resize driver. I have an
image , pass it to the driver and it generated a resize output image.

My v4l2 sequence is
1. qbuf OUTPUT, CAPTURE
2. stream on OUTPUT, CAPTURE
3. dqbuf OUTPUT, CAPTURE
4. stream off OUTPUT, CAPTURE

this works if i have a full frame of image before i start streaming.

But what I only have partial buffers when I start streaming, how can I
qbuf more buffer after I 'stream on' OUTPUT,

I try this, but this fail
1. qbuf OUTPUT, CAPTURE (I qbuf only partial OUTPUT)
2. stream on OUTPUT, CAPTURE

// do this in a loop:
3. dqbuf OUTPUT (I want to queue more OUTPUT as they become available)
4. qbuf OUTPUT

// now I am done, I want to dqbuf my output
5. dqbuf CAPTURE
6. stream off OUTPUT, CAPTURE

I try to do dqbuf/qbuf OUTPUT in step #3, #4 above, but it just stuck
in dqbuf OUTPUT.

How can I queue more of my input data after I stream on?

Thank you.
