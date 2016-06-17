Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:46397 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754868AbcFQHSh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 03:18:37 -0400
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Can you look at this apps build warning?
Message-ID: <5763A448.1010003@xs4all.nl>
Date: Fri, 17 Jun 2016 09:18:32 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

>From the daily build:

apps: WARNINGS
dvb-sat.c:188:14: warning: unused variable 's' [-Wunused-variable]

The fix is easy of course (delete static char s[1024];), but it is a bit surprising and I just
want to make sure there isn't something else going on.

Regards,

	Hans
