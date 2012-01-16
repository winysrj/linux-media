Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3684 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2APNKS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 08:10:18 -0500
Received: from alastor.dyndns.org (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id q0GDADtm066722
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 16 Jan 2012 14:10:17 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.lan (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 2EB7535C0001
	for <linux-media@vger.kernel.org>; Mon, 16 Jan 2012 14:10:07 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 00/10] Updating ISA Radio drivers :-)
Date: Mon, 16 Jan 2012 14:09:56 +0100
Message-Id: <1326719406-4538-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

One of the things I've wanted to do for some time is to start upgrading
all drivers to the latest V4L2 frameworks and ensuring that they pass
the v4l2-compliance tests.

So I started out with some of the oldest drivers around: the ISA radio
drivers :-)

Partially because they are easy to convert, partially because it is fun to
work with old hardware like that every so often.

I have tested this with actual hardware for the aimslab, aztech and gemtek
drivers. With a bit of luck I can get my hands on a zoltrix as well.

Since you can load ISA drivers even if there is no actual hardware, I was
able to run the other drivers through v4l2-compliance as well. I couldn't
test whether it actually works, of course, but at least it doesn't crash...

Regards,

	Hans

