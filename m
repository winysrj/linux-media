Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35973 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbcGOVRo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 17:17:44 -0400
Received: by mail-pf0-f194.google.com with SMTP id y134so2726304pfg.3
        for <linux-media@vger.kernel.org>; Fri, 15 Jul 2016 14:17:44 -0700 (PDT)
Date: Sat, 16 Jul 2016 06:17:22 +0900 (JST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Patrick-Evans <james@jmp-e.com>
cc: mchehab@redhat.com, crope@iki.fi, linux-media@vger.kernel.org,
	security@kernel.org
Subject: Re: [PATCH 1/1] subsystem:linux-media CVE-2016-5400
In-Reply-To: <20160715154004.GA840@ThinkPad-X200>
Message-ID: <alpine.LFD.2.20.1607160616160.12580@vaio.linux-foundation.org>
References: <20160715154004.GA840@ThinkPad-X200>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 15 Jul 2016, James Patrick-Evans wrote:
>
> The memory leak is caused by the probe function of the airspy driver
> mishandeling errors and not freeing the corresponding control structures when
> an error occours registering the device to v4l2 core.

The patch causes a warning about the now unused label.

I fixed that and cleaned up the commit message, and applied the end 
result.

          Linus
