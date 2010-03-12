Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab0CLKyj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 05:54:39 -0500
Message-ID: <4B9A1D95.60605@hhs.nl>
Date: Fri, 12 Mar 2010 11:55:17 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Announcing v4l-utils-0.7.91
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm happy to announce the second release of v4l-utils, nothing
special this time around just a few small bug fixes and cleanups
left and right.
New this release:

v4l-utils-0.7.91
----------------
* Utils changes:
   * Improve v4l-keytable to better support IR (mchehab)
   * Rename v4l-keytable to ir-keytable (mchehab)
* libv4l changes (hdegoede):
   * Add more laptop models to the upside down devices table
   * Ignore convert errors in the first few frames of a stream

Go get it here:
http://people.fedoraproject.org/~jwrdegoede/v4l-utils-0.7.91.tar.bz2

You can always find the latest developments here:
http://git.linuxtv.org/v4l-utils.git

Note, it would be good to have some place at linuxtv.org to host the
tarbals, if someone could help me set that up that would be great.

Regards,

Hans

