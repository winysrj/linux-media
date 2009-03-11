Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:29617 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZCKQOW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 12:14:22 -0400
Message-ID: <49B7E34F.6070906@maxwell.research.nokia.com>
Date: Wed, 11 Mar 2009 18:14:07 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
CC: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	=?ISO-8859-1?Q?Koskip=E4=E4_Antti_Jussi_Petteri?=
	<antti.koskipaa@nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: OMAP3 ISP and camera drivers (update)
References: <A24693684029E5489D1D202277BE89442E40F5B2@dlee02.ent.ti.com>	 <49B62DDA.4060307@maxwell.research.nokia.com> <5e9665e10903100308k7270db67w7947ee4b85eac120@mail.gmail.com>
In-Reply-To: <5e9665e10903100308k7270db67w7947ee4b85eac120@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dongsoo, Nathaniel Kim wrote:
> Hi Sakari,
> 
> I'm also having problem pulling your git now. I've pulled prior
> version of yours and this is second time of pulling your repository.
> 
> Here you are a part of git diff message of mine after pulling your
> TUESDAY MARCH 10 version. Looks like all about indent thing.
> 
> What should I do? If I want to pull your repository in my repository
> and merging automatically.
> 
> I don't have any clue ;-(

This branch branch now contains linux-omap plus the updated patchset. So 
the old patchset has been replaced by the new one. You're trying to pull 
the new patchset on top of the old one and merging very likely fails 
because of that.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
