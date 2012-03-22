Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab2CVQtD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 12:49:03 -0400
Message-ID: <4F6B5876.8080607@redhat.com>
Date: Thu, 22 Mar 2012 17:51:02 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>
Subject: [GIT PATCHES FOR 3.4] poll: add poll_requested_events() and poll_does_not_wait()
 functions & related patches
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro et all,

As discussed here is a pull request for the long time pending
"poll: add poll_requested_events() and poll_does_not_wait() functions"
patch & related patches.

As already mentioned on irc when you ask Linus to pull this please
add a note that Al Viro is ok with this change for in kernel drivers,
but that he is worried that it might break out of tree drivers.

The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:

   Linux 3.3 (2012-03-18 16:15:34 -0700)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git poll_req_events

for you to fetch changes up to 858904e33a17953df6debd5907e991ee9e74ed21:

   pwc: poll(): Check that the device has not beem claimed for streaming already (2012-03-22 17:42:41 +0100)

----------------------------------------------------------------
Hans Verkuil (6):
       poll: add poll_requested_events() and poll_does_not_wait() functions
       ivtv: only start streaming in poll() if polling for input.
       videobuf2: only start streaming in poll() if so requested by the poll mask.
       videobuf: only start streaming in poll() if so requested by the poll mask.
       videobuf2-core: also test for pending events.
       vivi: let vb2_poll handle events.

Hans de Goede (1):
       pwc: poll(): Check that the device has not beem claimed for streaming already

  drivers/media/video/ivtv/ivtv-fileops.c |    6 ++--
  drivers/media/video/pwc/pwc-if.c        |    9 ++++++
  drivers/media/video/videobuf-core.c     |    3 +-
  drivers/media/video/videobuf2-core.c    |   48 +++++++++++++++++++++----------
  drivers/media/video/vivi.c              |    9 +-----
  fs/eventpoll.c                          |   18 ++++++++++--
  fs/select.c                             |   40 ++++++++++++--------------
  include/linux/poll.h                    |   37 ++++++++++++++++++++----
  include/net/sock.h                      |    2 +-
  net/unix/af_unix.c                      |    2 +-
  10 files changed, 115 insertions(+), 59 deletions(-)

Thanks & Regards,

Hans
