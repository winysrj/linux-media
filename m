Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:50401 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758679Ab0DPRNK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Apr 2010 13:13:10 -0400
Date: Fri, 16 Apr 2010 19:13:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Richard =?iso-8859-1?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 0/2] media, mfd: Add timberdale video-in driver
Message-ID: <20100416171335.GC28863@sortiz.org>
References: <1271435274.11641.44.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1271435274.11641.44.camel@debian>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Richard,

On Fri, Apr 16, 2010 at 06:27:54PM +0200, Richard Röjfors wrote:
> To follow are two patches.
> 
> The first one adds the timberdale video-in driver to the media tree.
> 
> The second one adds it to the timberdale MFD driver.
> 
> The Kconfig of the media patch selects TIMB_DMA which is introduced
> in the DMA tree, that's why I cc:d in Dan.
> 
> Samuel and Mauro hope you can support and solve the potential merge
> issue between your two trees.
Mauro, the mfd part of this patch depends on the video one. Do you mind if I
take both through my tree, after getting your Acked-by ?

Cheers,
Samuel.


> Thanks
> --Richard
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
