Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:58225 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750888AbeBDNac (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Feb 2018 08:30:32 -0500
To: Gustavo Padovan <gustavo@padovan.org>,
        Alexandre Courbot <acourbot@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Compliance tests for new public API features
Message-ID: <fb69d8ed-6318-3970-0e2e-873749720689@xs4all.nl>
Date: Sun, 4 Feb 2018 14:30:27 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gustavo, Alexandre,

As you may have seen I have been extending the v4l2-compliance utility with tests
for v4l-subdevX and mediaX devices. In the process of doing that I promptly
found a bunch of bugs. Mostly little things that are easy to fix, but much
harder to find without proper tests.

You are both working on new API additions and I want to give a heads-up that
I want to have patches for v4l2-compliance that test the new additions to a
reasonable extent.

I say 'reasonable' because I suspect that e.g. in-fence support might be hard
to test. But out-fences can definitely be tested and for in-fences you can
at minimum test what happens when you give it an invalid file descriptor.

For the request API is it obviously too early to start writing tests, but
as the API crystallizes you may consider starting to work on it.

I've decided to be more strict about this based on my experiences. I'm more
than happy to assist and give advice, especially since this is a bit of a late
notice, particularly for Gustavo.

But every time we skip this step it bites us in the ass later on.

It is also highly recommended to add fence/request support to the vivid and
vim2m drivers. It makes it much easier to find regressions in the API due to
future changes since you don't need 'real' hardware for these drivers.

Again my apologies for the late notice, but it is better to make these tests
now while you are working on the new feature, rather than doing it much later
and finding all sorts of gremlins in the API.

Regards,

	Hans
