Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:53845 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbbCKIKi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 04:10:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net
Subject: [PATCHv2 00/21] marvell-ccic: drop and fix formats
Date: Wed, 11 Mar 2015 09:10:24 +0100
Message-Id: <1426061428-47019-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This v2 patch series replaces patch 18 from the first series.

After some more testing I realized that the 422P format produced
wrong colors and I couldn't get it to work. Since it never worked and
nobody complained about it (and it is a fairly obscure format as well)
I've dropped it.

I also tested RGB444 format for the first time, and that had wrong colors
as well, but that was easy to fix. Finally there was a Bayer format
reported, but it was never implemented. So that too was dropped.

I double checked all remaining formats, and they all work fine.

Regards,

	Hans

