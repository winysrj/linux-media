Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47943 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab0GTJqF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jul 2010 05:46:05 -0400
Received: by bwz1 with SMTP id 1so2735000bwz.19
        for <linux-media@vger.kernel.org>; Tue, 20 Jul 2010 02:46:04 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 20 Jul 2010 11:46:03 +0200
Message-ID: <AANLkTincseG_CGu9BjvXdkKLnD6ZVgSAwSIC-fO1oDzH@mail.gmail.com>
Subject: CAM Support for Terratec Cinergy S2 HD or Technisat SkyStar HD2
From: code unknown <restlessbrain@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am using a Terratec Cinergy S2 HD with Mantis driver and so far the
card runs without problems.

The only thing is that CAM seems not to be supported - it is defined
out from the source code:

#if 0
  err = mantis_ca_init(mantis);
  if (err < 0) {
           dprintk(MANTIS_ERROR, 1, "ERROR: Mantis CA initialization
failed <%d>", err);
  }
#endif


My questions are:

1. Is anybody currently working on CAM support? Will it be supported soon?

2. Is there another DVB-S2 HD card which has CAM supported?


Thanks,

rinf
