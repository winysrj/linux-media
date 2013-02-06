Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mlbassoc.com ([65.100.170.105]:42842 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab3BFTgp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 14:36:45 -0500
Message-ID: <5112AF1A.9050808@mlbassoc.com>
Date: Wed, 06 Feb 2013 12:29:30 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: media controller interface
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Any idea why /dev/media0 is not available to "media" users,
in particular those in group 'video'?  On my system I see:

   $ ls -l /dev/vid*
   crw-rw---- 1 root video 81, 0 Feb  6 18:45 /dev/video0
   crw-rw---- 1 root video 81, 1 Feb  6 18:45 /dev/video1
   crw-rw---- 1 root video 81, 2 Feb  6 18:45 /dev/video2
   crw-rw---- 1 root video 81, 3 Feb  6 18:45 /dev/video3
   $ ls -l /dev/media0
   crw------- 1 root root 253, 0 Feb  6 18:45 /dev/media0

So my actual media files are usable by my 'video' user, but
not the media controller interface.

Also, where are these devices created?  I'm running udev 182

Thanks for any pointers

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
