Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:37707 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726415AbeIML5Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 07:57:24 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: "Jasmin J." <jasmin@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: RFC: stop support for 2.6 kernel in the daily build
Message-ID: <9e0a811d-f403-ae89-38fa-947356f2c026@xs4all.nl>
Date: Thu, 13 Sep 2018 08:49:13 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SUSE Linux Enterprise Server 12 is on kernel 3.12, and version 11 SP2 or up
is on kernel 3.0.

Red Hat's RHEL 7 is on kernel 3.10.

I'm inclined to drop support for 2.6 altogether. If nothing else it
simplifies the kernel version handling in media_build.

Whether we should also drop support for 3.0-3.9 is another matter.
I wouldn't mind, 3.10 seems to be a reasonable minimum to me, but
I might be too optimistic here.

Comments?

Regards,

	Hans
