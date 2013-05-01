Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759472Ab3EAKKX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 May 2013 06:10:23 -0400
Message-ID: <5180EAF4.2050601@redhat.com>
Date: Wed, 01 May 2013 12:14:12 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Patrizio Bassi <patrizio.bassi@gmail.com>
Subject: [GIT PULL FOR 3.10]: 2 small USB webcam driver fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree for 2 small  USB webcam driver fixes
for 3.10. I know I'm a bit late, but I only got confirmation on the
second one from the reporter this morning.

The pwc fix is purely cosmetic, the sonixb bugfix is not, and
since it is a 100% bugfix it would be good to at least get
that one into 3.10, and then from there into older kernels
(I've added a Cc stable@).

The following changes since commit 02615ed5e1b2283db2495af3cf8f4ee172c77d80:

   [media] cx88: make core less verbose (2013-04-28 12:40:52 -0300)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.10

for you to fetch changes up to 7e3e5497cf971ab58d54b446e9e037a3637dbe4d:

   gspca-sonixb: Adjust hstart on sn9c103 + pas202 (2013-05-01 12:11:06 +0200)

----------------------------------------------------------------
Hans de Goede (2):
       pwc: Fix comment wrt lock ordering
       gspca-sonixb: Adjust hstart on sn9c103 + pas202

  drivers/media/usb/gspca/sonixb.c | 7 +++++++
  drivers/media/usb/pwc/pwc.h      | 2 +-
  2 files changed, 8 insertions(+), 1 deletion(-)

Thanks & Regards,

Hans
