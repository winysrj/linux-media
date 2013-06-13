Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2874 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3FMGcU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 02:32:20 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id r5D6W9U1091028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 13 Jun 2013 08:32:11 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 474F035E0047
	for <linux-media@vger.kernel.org>; Thu, 13 Jun 2013 08:32:07 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.11] Updates Part 2
Date: Thu, 13 Jun 2013 08:32:08 +0200
References: <201306130828.47780.hverkuil@xs4all.nl>
In-Reply-To: <201306130828.47780.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306130832.08384.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu June 13 2013 08:28:47 Hans Verkuil wrote:
> Mauro prefers to have the original large pull request split up in smaller pieces.
> 
> So this is the second patch set.

Oops, I forgot to mention that this pulls in this patch series:

DBG_G_CHIP_IDENT removal:
http://www.spinics.net/lists/linux-media/msg64081.html

Note: patches 7, 13, 20-23, 25 and 36 are kept back. There is a pending cx88
fix for 3.10 (http://git.linuxtv.org/media_tree.git/commit/609c4c12af79b1ba5fd2d31727a95dd3a319c0ae)
that conflicts with this patch series, so once that fix is merged back from
3.10 I can finalize this patch series.

Regards,

	Hans
