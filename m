Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33337 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbbLJBFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2015 20:05:01 -0500
Received: by mail-ig0-f170.google.com with SMTP id mv3so5597368igc.0
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2015 17:05:00 -0800 (PST)
Received: from [10.0.1.175] (dhcp-108-168-93-48.cable.user.start.ca. [108.168.93.48])
        by smtp.gmail.com with ESMTPSA id l41sm4256706iod.34.2015.12.09.17.04.58
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Wed, 09 Dec 2015 17:04:59 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Subject: dtv-scan-table has two ATSC files?
From: Maury Markowitz <maury.markowitz@gmail.com>
In-Reply-To: <56687B09.4050004@kapsi.fi>
Date: Wed, 9 Dec 2015 20:04:57 -0500
Content-Transfer-Encoding: 8BIT
Message-Id: <BF55C1DA-2E39-4ACA-92C0-4E512E10196F@gmail.com>
References: <201512081149525312370@gmail.com> <56687B09.4050004@kapsi.fi>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I’m making some updates to the ATSC dtv-scan-tables. Two questions:

1)
Why do we have "us-ATSC-center-frequencies-8VSB” *and* "us-NTSC-center-frequencies-8VSB”? They appear to be identical. The later could, theoretically, list NTSC encoded channels instead of 8VSB, but doesn’t actually do that. Suggest removing it?

2)
A number of the channel listings in those files have not been used for television use for several years now. Specifically channels 2 to 6 and everything from 51 and up were long ago sold off to cell phone use.

Additionally, channel 37 was *never* used, at least in the US and Canada, because it interfered with radio astronomy (IIRC it was sitting on one of the Lyman lines).

Since scanning through all of these channels will no longer work, perhaps it would be time to remove them? It reduces the total scan list from 80 channels to only 45, and would greatly improve scan times.