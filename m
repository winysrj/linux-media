Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39081 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab2ADO15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 09:27:57 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Sergei Shtylyov'" <sshtylyov@mvista.com>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: RE: [PATCH v8 1/2] davinci: vpif: remove machine specific header
 file inclusion from the driver
Date: Wed, 4 Jan 2012 14:27:38 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F75019F95@DBDE01.ent.ti.com>
References: <1325661469-4411-1-git-send-email-manjunath.hadli@ti.com>
 <1325661469-4411-2-git-send-email-manjunath.hadli@ti.com>
 <4F044D21.1030204@mvista.com>
In-Reply-To: <4F044D21.1030204@mvista.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sergei,
On Wed, Jan 04, 2012 at 18:29:13, Sergei Shtylyov wrote:
> Hello.
> 
> On 04-01-2012 11:17, Manjunath Hadli wrote:
> 
> > remove unnecessary inclusion of machine specific header files 
> > mach/dm646x.h, mach/hardware.h from vpif.h  and aslo mach/dm646x.h 
> > from vpif_display.c driver which comes in the way of platform code consolidation.
> > Add linux/i2c.h header file in vpif_types.h which is required for 
> > building.
> 
>     This last modification should be in a separate patch. Don;t mix changes having the different purpose.
It is part of the same modification of removing the machine specific header.
When the header file was removed, it needed the i2c to be included due to 
a dependency and hence the inclusion.

Thx,
-Manju
> 
> > Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> > Cc: Mauro Carvalho Chehab<mchehab@infradead.org>
> > Cc: LMML<linux-media@vger.kernel.org>
> 
> WBR, Sergei
> 

