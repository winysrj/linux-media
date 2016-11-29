Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44366
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756486AbcK2JPg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Nov 2016 04:15:36 -0500
Date: Tue, 29 Nov 2016 07:15:26 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mchehab@kernel.org, mkrufky@linuxtv.org, klock.android@gmail.com,
        elfring@users.sourceforge.net, max@duempel.org,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        chehabrafael@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] media protect enable and disable source handler
 paths
Message-ID: <20161129071526.5a004b75@vento.lan>
In-Reply-To: <cover.1480384155.git.shuahkh@osg.samsung.com>
References: <cover.1480384155.git.shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 28 Nov 2016 19:15:12 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> These two patches fix enable and disable source handler paths. These
> aren't dependent patches, grouped because they fix similar problems.

Those two patches should be fold, as applying just the first patch
would cause au0828 to try to double lock.

> 
> This work is triggered by a review comment from Mauro Chehab on a
> snd_usb_audio patch about protecting the enable and disabel handler
> path in it.
> 
> Ran tests to make sure enable and disable handler paths work. When
> digital stream is active, analog app finds the tuner busy and vice
> versa. Also ran the Sakari's unbind while video stream is active test.

Sorry, but your patches descriptions don't make things clear:

- It doesn't present any OOPS or logs that would help to
  understand what you're trying to fix;

- From what I understood, you're moving the lock out of
  enable/disable handlers, and letting their callers to do
  the locks themselves. Why? Are there any condition where it
  won't need to be locked?

- It is not touching documentation. If now the callbacks should
  not implement locks, this should be explicitly described.

Btw, I think it is a bad idea to let the callers to handle
the locks. The best would be, instead, to change the code in
some other way to avoid it, if possible. If not possible at all,
clearly describe why it is not possible and insert some comments
inside the code, to avoid some cleanup patch to mess up with this.

Regards

Thanks,
Mauro
