Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45042 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab1DBJjE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2011 05:39:04 -0400
Date: Sat, 2 Apr 2011 04:38:56 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Huber Andreas <hobrom@corax.at>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, andrew.walker27@ntlworld.com,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [RFC/PATCH 0/3] locking fixes for cx88
Message-ID: <20110402093856.GA17015@elie>
References: <20110327150610.4029.95961.reportbug@xen.corax.at>
 <20110327152810.GA32106@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110327152810.GA32106@elie>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Huber Andreas wrote[1]:

> Processes that try to open a cx88-blackbird driven MPEG device will hang up.

Here's a possible fix based on a patch by Ben Hutchings and
corrections from Andi Huber.  Warning: probably full of mistakes (my
fault) since I'm not familiar with any of this stuff.  Untested.
Review and testing would be welcome.

Ben Hutchings (2):
  [media] cx88: fix locking of sub-driver operations
  [media] cx88: use a mutex to protect cx8802_devlist

Jonathan Nieder (1):
  [media] cx88: protect per-device driver list with device lock

 drivers/media/video/cx88/cx88-blackbird.c |    3 +-
 drivers/media/video/cx88/cx88-dvb.c       |    2 +
 drivers/media/video/cx88/cx88-mpeg.c      |   35 +++++++++++++++++++---------
 drivers/media/video/cx88/cx88.h           |   10 +++++++-
 4 files changed, 37 insertions(+), 13 deletions(-)
