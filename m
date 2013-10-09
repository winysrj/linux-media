Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3165 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab3JIGm6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Oct 2013 02:42:58 -0400
Received: from tschai.lan (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id r996gsVd077491
	for <linux-media@vger.kernel.org>; Wed, 9 Oct 2013 08:42:56 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 6A89E2A04DF
	for <linux-media@vger.kernel.org>; Wed,  9 Oct 2013 08:42:48 +0200 (CEST)
Message-ID: <5254FAE8.3090203@xs4all.nl>
Date: Wed, 09 Oct 2013 08:42:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Working on videobuf2-dvb.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Just to prevent multiple people working on the same thing: I'm working on
a vb2 variant of videobuf-dvb.c.

I need the same mechanism for an alsa driver, and it was easy to extend it
to a videobuf2-dvb.c.

I hope to post an RFC patch series soon.

Regards,

	Hans
