Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36003 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030325Ab2AFPBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 10:01:52 -0500
Received: by wibhm6 with SMTP id hm6so1122167wib.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 07:01:51 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 6 Jan 2012 10:01:50 -0500
Message-ID: <CALzAhNWsgMe-0uFJZzKnNx_9DWvvSvU9wZTPugkTT3vqDQ4qWQ@mail.gmail.com>
Subject: [PULL] git://git.kernellabs.com/stoth/cx23885-hvr1850-fixups.git
From: Steven Toth <stoth@kernellabs.com>
To: Linux-Media <linux-media@vger.kernel.org>
Cc: Mauro Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Some changes to allow the querying of the NO_SIGNAL status feature on
the cx25840 video decoder.

The following changes since commit 45447e1e18131590203dba83f9044d6c48448e54:
  [media] cx25840: Added g_std support to the video decoder driver
(2012-01-04 19:16:15 -0500)
are available in the git repository at:
git://git.kernellabs.com/stoth/cx23885-hvr1850-fixups.git
staging/for_v3.3
Steven Toth (2):      [media] cx25840: Add support for g_input_status
    [media] cx23885: Query the CX25840 during enum_input for status
 drivers/media/video/cx23885/cx23885-video.c |    9 +++++++++
drivers/media/video/cx25840/cx25840-core.c  |   16 ++++++++++++++++ 2
files changed, 25 insertions(+), 0 deletions(-)
Many thanks,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
