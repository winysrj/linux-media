Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZH1GgH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 02:36:07 -0400
Message-ID: <4A977BB6.5040101@redhat.com>
Date: Fri, 28 Aug 2009 08:39:50 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Brandon Philips <brandon@ifup.org>
Subject: RFC: video device (stream) sharing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This has been discussed before and this is something Brandon and I would like
to discuss further at plumbers, so here is a first braindump, note that this
braindump is purely mine and not Brandon's in any way.

The basic idea is to have some sort of userspace proxy process which allows
sharing for example a webcam between 2 devices. For me there are 2 major
criteria which need to be matched to be able to do this:

1) No (as in 0) functionality regressions for the single use case, iow when
    only one app opens the device everything should work as before

2) No significant performance regressions for the single use case. Sure this
    may be a bit slower, but not much!

2) Will require some trickery with shared memory, etc. But the real hard problem
here is 1), so I will purely focus on 1) now.


My initial idea to solve 1) is that as soon as an application does anything
remotely stream (capture) related even something such as enum_fmt, it becomes the
stream owner. The stream owner is allowed to do everything. Any second application
which also wants to capture will only be shown the resolution and format currently
selected by the stream owner.

And here we immediately hit a problem. Imagine the following:
1) The user starts cheese at 640x480
2) The user starts application foo, which only sees 640x480 to and thus
    starts capturing at 640x480
3) The user changes the resolution in cheese to 320x240

Now we've got a problem, because cheese is allowed to do this, but we need 640x480
for application foo -> fail. And I'm not even talking about possible races when
cheese has become the stream owner, but has not yet choosen its format to stream in,
etc.


So the whole stream owner concept does not work. Instead, what would probably work, is
the following:
-limit the amount of reported supported formats (enum fmt) to formats which we can create
  by conversion from native formats
-report the full list of supported resolutions to all applications
-capture at the highest resolution requested by any of the applications
-downsample for applications which want a lower resolution


So this is how I suggest to handle this.

Regards,

Hans
