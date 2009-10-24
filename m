Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59195 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZJXQoe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2009 12:44:34 -0400
Message-ID: <4AE32EF2.2040508@googlemail.com>
Date: Sat, 24 Oct 2009 18:44:34 +0200
From: Gonsolo <gonsolo@gmail.com>
MIME-Version: 1.0
To: mchehab@infradead.org, pboettcher@dibcom.fr
CC: linux-media@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
Subject: DVB-T dib0700 one minute hang when resuming
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

The following script fixes an annoying 62 second hang when resuming 
while my Nova-T stick is connected to my notebook.

echo /etc/pm/sleep.d/50_dvb_usb_dib0700_quirk:

#!/bin/sh

case "$1" in
  hibernate|suspend)
   rmmod dvb_usb_dib0700
   ;;
  thaw|resume)
   modprobe dvb_usb_dib0700
   ;;
  *) exit $NA
   ;;
esac

Is the right fix to use request_firmware_nowait?

Thank you.
