Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:14762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab1GDGWA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2011 02:22:00 -0400
Message-ID: <4E115C4E.804@redhat.com>
Date: Mon, 04 Jul 2011 08:23:10 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>
Subject: New ctrl framework also enumerates classes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi All,

One last thing before I really leave on vacation which just popped
in my mind as something which I had not mentioned yet.

The new ctrl framework also enumerates classes when enumerating
ctrls with the next flag. I wonder if this is intentional?

IOW if this is a feature or a bug?

Either way this confuses various userspace apps, gtk-v4l prints
warnings about an unknown control type, and v4l2ucp gets a very
messed up UI because of this change. Thus unless there are
really strong reasons to do this, I suggest we skip classes
when enumerating controls.

Regards,

Hans
