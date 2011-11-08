Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3512 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab1KHKce (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 05:32:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Daily build update
Date: Tue, 8 Nov 2011 11:32:23 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111081132.23365.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've managed to get the daily build working again with the for_v3.3 branch and
with the full range of kernels from 2.6.31 to 3.2-rc1.

There is one error remaining with the compilation of cpia2_usb.c on 3.2-rc1
(a missing module.h header). This should be resolved once the for_v3.3 branch
is synced with the 3.2-rc1 mainline branch. So I am not going to workaround
that error.

I'm sure it will break again after the next round of commits, though :-)

Regards,

	Hans
