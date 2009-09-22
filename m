Return-path: <linux-media-owner@vger.kernel.org>
Received: from av12-1-sn2.hy.skanova.net ([81.228.8.185]:43073 "EHLO
	av12-1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbZIVJFS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 05:05:18 -0400
Message-ID: <4AB8934E.3030807@mocean-labs.com>
Date: Tue, 22 Sep 2009 11:05:18 +0200
From: =?ISO-8859-1?Q?Richard_R=F6jfors?=
	<richard.rojfors@mocean-labs.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: [PATCH 0/4] adv7180 updates
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To follow is a series of patches against the adv7180 in the linux-media tree.

1. support for getting input status.

2. support for setting video standard

3. support for interrupt driven update of the video standard

4. usage of the __devinit and __devexit macros

--Richard
