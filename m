Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:52039 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752590AbcKJHtt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 02:49:49 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: dib0700_core.c: uninitialized variable warning, not sure how to fix
Message-ID: <aa490920-cb2e-bb3d-a031-f18e6f0ded9b@xs4all.nl>
Date: Thu, 10 Nov 2016 08:49:43 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The daily build produces this compiler warning:

dib0700_core.c: In function 'dib0700_rc_urb_completion':
dib0700_core.c:787:2: warning: 'protocol' may be used uninitialized in this function [-Wmaybe-uninitialized]
  rc_keydown(d->rc_dev, protocol, keycode, toggle);
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is indeed correct as there is a path in that function where protocol is
uninitialized, but I lack the knowledge how this should be fixed.

Mauro, can you take a look?

It goes wrong in the switch in case RC_BIT_NEC if the first 'if' is true.
Note that keycode is also uninitialized, but it is declared as uninitialized_var(),
although why you would want to do that instead of just initializing it to 0 or
something like that is a mystery to me.

Regards,

	Hans
