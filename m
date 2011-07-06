Return-path: <mchehab@localhost>
Received: from comal.ext.ti.com ([198.47.26.152]:35811 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab1GFJ7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 05:59:24 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	LMML <linux-media@vger.kernel.org>
Date: Wed, 6 Jul 2011 15:29:10 +0530
Subject: RE: [PATCH 1/1] davinci: dm646x: move vpif related code to driver
	core	header from platform
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024D91ABC6@dbde02.ent.ti.com>
References: <1305899929-2509-1-git-send-email-manjunath.hadli@ti.com>
	<B85A65D85D7EB246BE421B3FB0FBB593024D2D28E3@dbde02.ent.ti.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024D6262FF@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024D6262FF@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi Mauro,

On Wed, Jun 22, 2011 at 09:35:58, Nori, Sekhar wrote:
> On Thu, Jun 02, 2011 at 22:51:58, Nori, Sekhar wrote:
> > Hi Mauro,
> > 
> > On Fri, May 20, 2011 at 19:28:49, Hadli, Manjunath wrote:
> > > move vpif related code for capture and display drivers
> > > from dm646x platform header file to vpif.h as these definitions
> > > are related to driver code more than the platform or board.
> > > 
> > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > 
> > Will you be taking this patch through your tree?
> > 
> > If not, with your ack, I can queue it for inclusion
> > through the ARM tree.
> > 
> 
> Ping :)

Can you please provide your ack so that I can
queue this for v3.1?

Thanks,
Sekhar

