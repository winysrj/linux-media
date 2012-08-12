Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58512 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2HLQjB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 12:39:01 -0400
Received: by lbbgj3 with SMTP id gj3so970538lbb.19
        for <linux-media@vger.kernel.org>; Sun, 12 Aug 2012 09:39:00 -0700 (PDT)
Message-ID: <5027DC16.8050604@iki.fi>
Date: Sun, 12 Aug 2012 19:38:46 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: suitable IOCTL error code when device is in state IOCTL cannot performed
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Subject says it all. Which one error value is most suitable / generic ?

Here are few ones I found which could be possible:

#define EPERM        1  /* Operation not permitted */
#define EAGAIN      11  /* Try again */
#define EACCES      13  /* Permission denied */
#define EBUSY       16  /* Device or resource busy */
#define ENODATA     61  /* No data available */
#define ECANCELED   125 /* Operation Canceled */

regards
Antti

-- 
http://palosaari.fi/
