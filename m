Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42469 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab2BZMjR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 07:39:17 -0500
Received: by werb13 with SMTP id b13so2275139wer.19
        for <linux-media@vger.kernel.org>; Sun, 26 Feb 2012 04:39:16 -0800 (PST)
Message-ID: <4F4A27EB.8070807@gmail.com>
Date: Sun, 26 Feb 2012 12:39:07 +0000
From: Robert Gadsdon <rhgadsdon@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Problem with HVR4000 since 3.3-rc..
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My HVR4000 has been working correctly with kernel versions up to 3.2.7, 
but with 3.3-rc2/3/4/5 I get:

'' # kobject_add_internal failed for dvb with -EEXIST, don't try to 
register things with the same name in the same directory. ''

.. errors, repeated, and dev/dvb/..  does not exist.

Is this a known problem, or do I need to change my configuration in some 
way, to accommodate the 3.3 kernel changes?

Thanks..

Robert Gadsdon.

-- 
.............................
Robert Gadsdon
email: rhgadsdon<at>gmail.com
.............................

