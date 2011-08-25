Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3093 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab1HYMvX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 08:51:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Manu Abraham <abraham.manu@gmail.com>
Subject: dst_ca.c warning: can ca_send_message be removed?
Date: Thu, 25 Aug 2011 14:51:18 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108251451.18970.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manu,

While going through the daily build compiler warnings I came across this one:

v4l-dvb-git/drivers/media/dvb/bt8xx/dst_ca.c: In function 'ca_send_message':
v4l-dvb-git/drivers/media/dvb/bt8xx/dst_ca.c:480:15: warning: variable 'ca_message_header_len' set but not used [-Wunused-but-set-variable]

This variable is indeed set once but unused afterwards. The assignment is:

ca_message_header_len = p_ca_message->length;   /* Restore it back when you are done */

Obviously it is not restored as the comment says.

Is this a bug or just old code that can be removed?

Regards,

	Hans
