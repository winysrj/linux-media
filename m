Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:55378 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab1G0Wyg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 18:54:36 -0400
Date: Thu, 28 Jul 2011 01:54:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, javier.martin@vista-silicon.com,
	shotty317@gmail.com
Subject: Re: [PATCH] mt9p031: Aptina (Micron) MT9P031 5MP sensor driver
Message-ID: <20110727225431.GJ32629@valkosipuli.localdomain>
References: <CACKLOr1veNZ_6E3V_m1Tf+mxxUAKiRKDbboW-fMbRGUrLns_XA@mail.gmail.com>
 <1311757981-6968-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <20110727101305.GI32629@valkosipuli.localdomain>
 <201107271951.37601.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107271951.37601.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 27, 2011 at 07:51:36PM +0200, Laurent Pinchart wrote:
> Hi Sakari,

Hi Laurent,

> On Wednesday 27 July 2011 12:13:05 Sakari Ailus wrote:
> > Hi Laurent,
> > 
> > Thanks for the patch. I have a few comments below.
> 
> Thanks for the review. Please see my answers to your comments below. Javier, 
> there's one question for you as well.

In my opinion the patch looks very good and clean in general. All my
comments were small issues and I agree with the resolutions. I think
implementing dynamic pll calculation and digital gain control may be
postponed if you wish. Especially the latter would be nice since I think
many sensors have that feature (plus colour component gains) but no driver
expose any proper interface for it.

-- 
Sakari Ailus
sakari.ailus@iki.fi
