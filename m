Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab0IMOZ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 10:25:58 -0400
Message-ID: <4C8E3460.3050504@redhat.com>
Date: Mon, 13 Sep 2010 11:25:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND][PATCH 0/2] media, mfd: Add timberdale video-in driver
References: <1283428572.23309.24.camel@debian> <4C87E67E.2040807@redhat.com> <20100913133951.GD2555@sortiz-mobl>
In-Reply-To: <20100913133951.GD2555@sortiz-mobl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 13-09-2010 10:39, Samuel Ortiz escreveu:
> Hi Mauro,
> 
> On Wed, Sep 08, 2010 at 04:39:42PM -0300, Mauro Carvalho Chehab wrote:
>> Em 02-09-2010 08:56, Richard Röjfors escreveu:
>>> To follow are two patches.
>>>
>>> The first adds the timberdale video-in driver to the media tree.
>>>
>>> The second adds it to the timberdale MFD driver.
>>>
>>> Samuel and Mauro hope you can support and solve the potential merge
>>> issue between your two trees.
>>
>> If the conflicts are trivial, I can handle when merging upstream.
> Since the mfd part of this patchset has a build time dependency on the media
> part, would you mind pushing both patches upstream through your tree ?
> I'll ACK the mfd part.

Sure. This is probably a way simpler than the reverse ;)

Cheers,
Mauro
