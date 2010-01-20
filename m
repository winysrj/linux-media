Return-path: <linux-media-owner@vger.kernel.org>
Received: from static.88-198-15-165.clients.your-server.de ([88.198.15.165]:45296
	"EHLO merzeus.obrandt.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab0ATRGS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 12:06:18 -0500
Date: Wed, 20 Jan 2010 17:56:27 +0100
From: Torsten Landschoff <t.landschoff@gmx.net>
To: linux-media@vger.kernel.org
Subject: em28xx based camera (Videology 21K142/USB) stops streaming after
 VIDIOC_S_FMT
Message-ID: <20100120165627.GB10892@merzeus.obrandt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi *,

I am trying to get the Videology 21K142 camera (which is based on the Empia
em28xx chipset) to work with our legacy display application. It works fine
up to a point.

However, when calling VIDIOC_S_FMT streaming does not work anymore. The
calling sequence is

STREAMOFF
S_FMT
REQBUFS
QUERYBUF
QBUF

with MMAP based buffers. Sometimes it works, but after playing with it
for a while (switching resolutions) it just stops delivering any images.
Changing the resolution again does not help, but reopening the device
seems to fix the problem (unless one is unlucky and our initial S_FMT
call causes the problem immediately).

Unfortunately, I don't know if there are any open source apps that can
reproduce the problem, I did not find any allowing a live picture and
resolution changes.

I am open to suggestions and questions.

Thanks for any help

Torsten
