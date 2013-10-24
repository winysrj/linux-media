Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:47858 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab3JXO0D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Oct 2013 10:26:03 -0400
Received: by mail-lb0-f179.google.com with SMTP id w6so349862lbh.10
        for <linux-media@vger.kernel.org>; Thu, 24 Oct 2013 07:26:02 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 24 Oct 2013 16:26:02 +0200
Message-ID: <CAAZmLNdKzHb-hqcjeE7=YZ=0Y3OW67BGrbMMS59LQAaRmfRz9Q@mail.gmail.com>
Subject: Terratec H5 (analog support)
From: Tobias Bengtsson <tjolle@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I'm trying this question again. DVB-C works perfectly with the
V4L-driver, but I'm a bit curious if the analog tuner is supposed to
be supported? A video0 device gets created but starting tvheadend it
complains about it missing a tuner and the device is skipped. Is this
an issue with tvheadend or a constraint of the driver?

Thanks in advance.

-- 
Tobias Bengtsson (tjolle@gmail.com)
