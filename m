Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4364 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab0CIHs1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Mar 2010 02:48:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: v4l-utils: i2c-id.h and alevt
Date: Tue, 9 Mar 2010 08:48:29 +0100
Cc: hdegoede@redhat.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003090848.29301.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's nice to see this new tree, that should be make it easier to develop
utilities!

After a quick check I noticed that the i2c-id.h header was copied from the
kernel. This is not necessary. The only utility that includes this is v4l2-dbg
and that one no longer needs it. Hans, can you remove this?

The second question is whether anyone would object if alevt is moved from
dvb-apps to v4l-utils? It is much more appropriate to have that tool in
v4l-utils.

Does anyone know of other unmaintained but useful tools that we might merge
into v4l-utils? E.g. xawtv perhaps?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
