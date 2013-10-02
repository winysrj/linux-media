Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:41906 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3JBMqL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 08:46:11 -0400
Received: by mail-oa0-f41.google.com with SMTP id n10so695357oag.28
        for <linux-media@vger.kernel.org>; Wed, 02 Oct 2013 05:46:11 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 2 Oct 2013 14:46:10 +0200
Message-ID: <CAAZmLNf+hucgc3fW0opvE4u7VtxaM14dvnskGcXWYfPv0AAF8Q@mail.gmail.com>
Subject: Regarding Terratec H5 and analog support
From: Tobias Bengtsson <tjolle@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I recently purchased an old Terratec H5 for my mediacenter (running
OpenELEC) and while the DVB-C is working like a charm I'm curious if
the analog tuner is supposed to be working in the driver or not? The
video0 device seems to be created on driver load but the backend I'm
using complains about missing a tuner for the device. I've tried to
make some thorough Google-searches before writing to this list but I
haven't come up with anything really conclusive... As I understand it,
the tuner on the card (TDA18271) is supported but maybe there's some
special interfacing-magic that just hasn't been implemented?

Anyhow, I'm satisfied living without my analog channels but I figured
maybe someone in-the-know could silence my curiosity if I sent out
this question.

With regards.

PS. I'm grateful and impressed with the amount of work that seems to
go in to this project. I'd nominate you all for an award for great
service to humanity if I could. :-)

-- 
Tobias Bengtsson (tjolle@gmail.com)
