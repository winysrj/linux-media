Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:46203 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab1CWGkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 02:40:03 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Arnd Bergmann <arnd@arndb.de>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
CC: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Hilman, Kevin" <khilman@ti.com>
Date: Wed, 23 Mar 2011 12:09:34 +0530
Subject: RE: [PATCH v17 08/13] davinci: eliminate use of IO_ADDRESS() on
 sysmod
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C47DBA6@dbde02.ent.ti.com>
References: <1300197523-4574-1-git-send-email-manjunath.hadli@ti.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024C47D7B5@dbde02.ent.ti.com>
 <201103221415.03904.arnd@arndb.de>
In-Reply-To: <201103221415.03904.arnd@arndb.de>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 22, 2011 at 18:45:03, Arnd Bergmann wrote:
> On Tuesday 22 March 2011, Nori, Sekhar wrote:
> > .. but forgot to fix this. There is nothing wrong with
> > using writel, but it doesn't fit into what the subject
> > of this patch is.
> 
> Well, to be more exact, the __raw_writel was actually
> wrong here and it should be writel(), but it's certainly
> better to mention the reason in the changelog, or to
> make a separate patch for it.

I wouldn't necessarily classify the use of __raw_writel as wrong
(as in a bug) - since the specific code is question is only run
on ARMv5 based SoCs. 

A lot of DaVinci code uses __raw_* variants, and perhaps should
be changed to use readl/writel instead - at least it will help
copying that code over for other uses.

That should be the subject of separate (series of) patches.

Thanks,
Sekhar

