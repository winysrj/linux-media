Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48118 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab1BJE4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 23:56:37 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so997018wwa.1
        for <linux-media@vger.kernel.org>; Wed, 09 Feb 2011 20:56:36 -0800 (PST)
MIME-Version: 1.0
From: Pawel Osciak <pawel@osciak.com>
Date: Wed, 9 Feb 2011 20:56:16 -0800
Message-ID: <AANLkTi=anEpevAYyufzj11-rE2DJqYWpRpDP-kK2XjHe@mail.gmail.com>
Subject: [GIT PATCHES for 2.6.39] Remove compatibility layer from multi-planar
 API documentation
To: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,
This removes compatibility layer documentation from DocBook
documentation of multi-planar extensions, as we discussed and decided
to drop it from 2.6.39.

The following changes since commit ffd14aab03dbb8bb1bac5284603835f94d833bd6:

  [media] au0828: fix VBI handling when in V4L2 streaming mode
(2011-02-02 12:06:14 -0200)

are available in the git repository at:
  ssh://linuxtv.org/git/posciak/media_tree.git staging/for_v2.6.39

Pawel Osciak (1):
      [media] Remove compatibility layer from multi-planar API documentation

 Documentation/DocBook/v4l/planar-apis.xml     |   35 +++++-------------------
 Documentation/DocBook/v4l/vidioc-querycap.xml |   22 +++++++--------
 2 files changed, 18 insertions(+), 39 deletions(-)

-- 
Best regards,
Pawel Osciak
