Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:52626 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729021AbeKFSBS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 13:01:18 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC] Create test script(s?) for regression testing
Message-ID: <d0b6420c-e6b9-64c3-3577-fd0546790af3@xs4all.nl>
Date: Tue, 6 Nov 2018 09:37:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

After the media summit (heavy on test discussions) and the V4L2 event regression
we just found it is clear we need to do a better job with testing.

All the pieces are in place, so what is needed is to combine it and create a
script that anyone of us as core developers can run to check for regressions.
The same script can be run as part of the kernelci regression testing.

We have four virtual drivers: vivid, vim2m, vimc and vicodec. The last one
is IMHO not quite good enough yet for testing: it is not fully compliant to the
upcoming stateful codec spec. Work for that is planned as part of an Outreachy
project.

My idea is to create a script that is maintained as part of v4l-utils that
loads the drivers and runs v4l2-compliance and possibly other tests against
the virtual drivers.

It should be simple to use and require very little in the way of dependencies.
Ideally no dependencies other than what is in v4l-utils so it can easily be run
on an embedded system as well.

For a 64-bit kernel it should run the tests both with 32-bit and 64-bit
applications.

It should also test with both single and multiplanar modes where available.

Since vivid emulates CEC as well, it should run CEC tests too.

As core developers we should have an environment where we can easily test
our patches with this script (I use a VM for that).

I think maintaining the script (or perhaps scripts) in v4l-utils is best since
that keeps it in sync with the latest kernel and v4l-utils developments.

Comments? Ideas?

Regards,

	Hans
