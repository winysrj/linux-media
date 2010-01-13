Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60401 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023Ab0AMRan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 12:30:43 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Michael Trimarchi <michael@panicking.kicks-ass.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 13 Jan 2010 11:33:11 -0600
Subject: RE: [RFC PATCH] Fix and invalid array indexing in
 isp_csi2_complexio_lanes_config
Message-ID: <A24693684029E5489D1D202277BE8944514ACF7F@dlee02.ent.ti.com>
References: <4B4CDA40.9030102@panicking.kicks-ass.org>
In-Reply-To: <4B4CDA40.9030102@panicking.kicks-ass.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nice catch!

Patch looks good to me.

I'm pushing it into my omap-devel branch, which I'll later rebase to latest Sakari's tree and send among other patches I have in my queue for him.

Regards,
Sergio

> -----Original Message-----
> From: Michael Trimarchi [mailto:michael@panicking.kicks-ass.org]
> Sent: Tuesday, January 12, 2010 2:23 PM
> To: Sakari Ailus; Aguirre, Sergio
> Cc: linux-media@vger.kernel.org
> Subject: [RFC PATCH] Fix and invalid array indexing in
> isp_csi2_complexio_lanes_config
> 

