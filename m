Return-path: <mchehab@localhost>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3410 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965159Ab1GMJjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 05:39:18 -0400
Received: from tschai.lan (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id p6D9dGwp048541
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 13 Jul 2011 11:39:17 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH 0/6] Don't start streaming unless requested by the poll mask.
Date: Wed, 13 Jul 2011 11:38:58 +0200
Message-Id: <1310549944-23756-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

The patch adding core support for poll_requested_events() looks ready for v3.1,
so this patch series builds on it to fix the vivi and ivtv drivers.

It also uses it in videobuf. I think it makes sense to add it there as well,
even though no videobuf-drivers use events (yet).

If there are no comments, then I'd like to make a pull request for this by
the end of the week.

Regards,

	Hans

PS: Note that I'm having vacation until July 25th, so I won't be very active on
the mailinglist. These poll patches are the only thing that I'm working on since
I really want to get these merged for v3.1.

