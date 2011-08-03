Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:34575 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab1HCSwG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2011 14:52:06 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
CC: LAK <linux-arm-kernel@lists.infradead.org>
Date: Thu, 4 Aug 2011 00:21:56 +0530
Subject: RE: [PATCH 1/1] davinci: dm646x: move vpif related code to driver
 core	header from platform
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024DF05EB0@dbde02.ent.ti.com>
References: <1305899929-2509-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1305899929-2509-1-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manju,

On Fri, May 20, 2011 at 19:28:49, Hadli, Manjunath wrote:
> move vpif related code for capture and display drivers
> from dm646x platform header file to vpif.h as these definitions
> are related to driver code more than the platform or board.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>

Can you rebase this patch to latest on my tree and repost
this time CCing Mauro?

Lets try and get his ack for the v3.2 merge.

Thanks,
Sekhar

