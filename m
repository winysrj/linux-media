Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55687 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab0DHMm0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 08:42:26 -0400
Received: by gyg13 with SMTP id 13so1151674gyg.19
        for <linux-media@vger.kernel.org>; Thu, 08 Apr 2010 05:42:25 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 8 Apr 2010 09:42:25 -0300
Message-ID: <h2m36be2c7a1004080542x89ca0c37gbfccffc78534b01e@mail.gmail.com>
Subject: Capturing errors when doing v4l2_read
From: Pablo Baena <pbaena@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm trying to detect when a user unplugs a camera while I'm doing
v4l2_read, but even when I get logs like this:

libv4l2: error queuing buf 0: No such device
libv4l2: error queuing buf 1: No such device
libv4l2: error queuing buf 2: No such device
libv4l2: error dequeuing buf: Input/output error

errno is not containing any errors, and I get a previously retrieved
buffer anyway.

Is this correct behaviour? Shouldn't it return an error? For the
moment, can I do something to workaround this?

-- 
"The Linux philosophy is 'Laugh in the face of danger'. Oops. Wrong
One. 'Do it yourself'. Yes, that's it."
