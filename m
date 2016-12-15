Return-path: <linux-media-owner@vger.kernel.org>
Received: from 92-243-34-74.adsl.nanet.at ([92.243.34.74]:52085 "EHLO
        mail.osadl.at" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1757228AbcLOBXZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 20:23:25 -0500
Date: Thu, 15 Dec 2016 01:14:05 +0000
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Nicholas Mc Guire <hofrat@osadl.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] [media] s5k6aa: set usleep_range greater 0
Message-ID: <20161215011405.GB22190@osadl.at>
References: <CGME20161213015743epcas3p19867fa74e5ffe2974364d317d9b494f6@epcas3p1.samsung.com>
 <1481594282-12801-1-git-send-email-hofrat@osadl.org>
 <ae02dfc1-39b9-f7f7-5168-d00e4ad75db7@samsung.com>
 <5277658.1FioEDcST1@avalon>
 <fe6f6e06-be7a-9a66-7723-7b37a0ae1675@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fe6f6e06-be7a-9a66-7723-7b37a0ae1675@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 13, 2016 at 03:53:47PM +0100, Sylwester Nawrocki wrote:
> Hi Laurent,
> 
> On 12/13/2016 03:10 PM, Laurent Pinchart wrote:
> > As pointed out by Ian Arkver, the datasheet states the delay should be >50µs. 
> > Would it make sense to reduce the sleep duration to (3000, 4000) for instance 
> > (or possibly even lower), instead of increasing it ?
> 
> Theoretically it would make sense, I believe the delay call should really
> be part of the set_power callback.  I think it is safe to decrease the
> delay value now, the boards using that driver have been dropped with commit
> 
> commit ca9143501c30a2ce5886757961408488fac2bb4c
> ARM: EXYNOS: Remove unused board files
> 
> As far as I am concerned you can do whatever you want with that delay
> call, remove it or decrease value, whatever helps to stop triggering
> warnings from the static analysis tools.
>
if its actually unused then it might be best to completely drop the code
raher than fixing up dead-code. Is the EXYNOS the only system that had
this device in use ? If it shold stay in then setting it to the above
proposed 3000, 4000 would seem the most resonable to me as I asume this
change would stay untested.

thx!
hofrat
 
