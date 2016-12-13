Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:36500 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932319AbcLMOxx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 09:53:53 -0500
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Subject: Re: [PATCH RFC] [media] s5k6aa: set usleep_range greater 0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <CGME20161213015743epcas3p19867fa74e5ffe2974364d317d9b494f6@epcas3p1.samsung.com>
 <1481594282-12801-1-git-send-email-hofrat@osadl.org>
 <ae02dfc1-39b9-f7f7-5168-d00e4ad75db7@samsung.com> <5277658.1FioEDcST1@avalon>
Cc: Nicholas Mc Guire <hofrat@osadl.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <fe6f6e06-be7a-9a66-7723-7b37a0ae1675@samsung.com>
Date: Tue, 13 Dec 2016 15:53:47 +0100
In-reply-to: <5277658.1FioEDcST1@avalon>
Content-transfer-encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/13/2016 03:10 PM, Laurent Pinchart wrote:
> As pointed out by Ian Arkver, the datasheet states the delay should be >50µs. 
> Would it make sense to reduce the sleep duration to (3000, 4000) for instance 
> (or possibly even lower), instead of increasing it ?

Theoretically it would make sense, I believe the delay call should really
be part of the set_power callback.  I think it is safe to decrease the
delay value now, the boards using that driver have been dropped with commit

commit ca9143501c30a2ce5886757961408488fac2bb4c
ARM: EXYNOS: Remove unused board files

As far as I am concerned you can do whatever you want with that delay
call, remove it or decrease value, whatever helps to stop triggering
warnings from the static analysis tools.

--
Thanks,
Sylwester
