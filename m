Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:36622 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932180AbcIFPQX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 11:16:23 -0400
Received: by mail-yw0-f173.google.com with SMTP id s85so29495841ywg.3
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2016 08:16:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160906064108.5bd84045@vento.lan>
References: <1470822739-29519-1-git-send-email-markus.heiser@darmarit.de>
 <1470822739-29519-3-git-send-email-markus.heiser@darmarit.de>
 <20160824114927.3c6ab0d6@vento.lan> <20160824115241.7e2c90ca@vento.lan>
 <28A9DFEA-1E94-4EE0-A2BB-B22D029683B9@darmarit.de> <20160905102511.6de3dbe4@vento.lan>
 <eaa7b609-2c27-9943-5197-d9bec71b2db7@gmail.com> <20160906064108.5bd84045@vento.lan>
From: VDR User <user.vdr@gmail.com>
Date: Tue, 6 Sep 2016 08:16:22 -0700
Message-ID: <CAA7C2qj5ap3PoK2uenF+kqpCrqjO9znR4y5Y7h2UoaENDcT8XA@mail.gmail.com>
Subject: Re: [PATCH 2/2] v4l-utils: fixed dvbv5 vdr format
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Chris Mayo <aklhfex@gmail.com>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I can tell you that people do still use VDR-1.6.0-3. It would be
unwise (and unnecessary) to break backwards compatible, which would be
grounds for NACK if you ask me. Knowingly causing breakage has always
been an unpopular thing in the VDR community, and this sounds like
it's going beyond fixing a small issue to fixing it til it breaks.
