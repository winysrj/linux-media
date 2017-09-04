Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54621
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753477AbdIDMPi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Sep 2017 08:15:38 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?q?Honza=20Petrou=C5=A1?= <jpetrous@gmail.com>
Subject: [PATCH 0/2] Documents the two remaining CA ioctls
Date: Mon,  4 Sep 2017 09:15:30 -0300
Message-Id: <cover.1504526763.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks to some discussions I had with Honza, I got some ideas about how to
document the last three undocumented ioctls from ca.h, together with the
two data structures.

With this series (and the previous one), everything at CA, Net, Demux 
and DVBv5 Frontend DVB APIs are now documented. That's IMHO
a very good reason to celebrate! Yay!

Please notice that are still gaps at the DVB API documentation, but
those are related to legacy stuff that aren't touched for ages
(DVBv3 frontend API, audio.h, osd.h and video.h). The legacy
 DVBv3 frontend API was completely replaced by DVBv5 API.
The other ones are used only by a single driver (av7110).

Mauro Carvalho Chehab (2):
  media: ca docs: document CA_SET_DESCR ioctl and structs
  media: ca.h: document ca_msg and the corresponding ioctls

 Documentation/media/uapi/dvb/ca-get-msg.rst   | 19 ++++++-------------
 Documentation/media/uapi/dvb/ca-send-msg.rst  |  6 +++++-
 Documentation/media/uapi/dvb/ca-set-descr.rst | 15 ++-------------
 include/uapi/linux/dvb/ca.h                   | 20 ++++++++++++++++++--
 4 files changed, 31 insertions(+), 29 deletions(-)

-- 
2.13.5
