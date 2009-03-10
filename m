Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:51727 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbZCJJHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 05:07:49 -0400
Message-ID: <49B62DDA.4060307@maxwell.research.nokia.com>
Date: Tue, 10 Mar 2009 11:07:38 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	DongSoo Kim <dongsoo.kim@gmail.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	=?ISO-8859-1?Q?Koskip=E4=E4_Antti_Jussi_Petteri?=
	<antti.koskipaa@nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: OMAP3 ISP and camera drivers (update)
References: <A24693684029E5489D1D202277BE89442E40F5B2@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89442E40F5B2@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aguirre Rodriguez, Sergio Alberto wrote:
> Hi Sakari,

Hello, Sergio!

> Doing a pull like you suggested in past release:
>  
> $ git pull http://git.gitorious.org/omap3camera/mainline.git v4l \
>    iommu omap3camera base
> 
> Brings the same code than before...

Oops. Could you try again now?

> I see that omap3isp branch is updated on gitorious, but trying to pull that branch gives merge errors.

Are you pulling it on top of linux-omap?

I've replaced the whole patchset so git tries to apply the new patches 
on top of the old ones.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
