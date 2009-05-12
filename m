Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:56292 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540AbZELGLS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 02:11:18 -0400
Date: Tue, 12 May 2009 09:05:41 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] v4l2: video device: Add V4L2_CTRL_CLASS_FMTX
	controls
Message-ID: <20090512060541.GA4639@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1242034309-13448-1-git-send-email-eduardo.valentin@nokia.com> <1242034309-13448-2-git-send-email-eduardo.valentin@nokia.com> <1242103765.19944.41.camel@eenurkka-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242103765.19944.41.camel@eenurkka-desktop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Eero,

On Tue, May 12, 2009 at 06:49:25AM +0200, Nurkkala Eero.An (EXT-Offcode/Oulu) wrote:
> On Mon, 2009-05-11 at 11:31 +0200, Valentin Eduardo (Nokia-D/Helsinki) wrote:
> > +enum v4l2_fmtx_preemphasis {
> > +	V4L2_FMTX_PREEMPHASIS_75_uS		= 0,
> > +	V4L2_FMTX_PREEMPHASIS_50_uS		= 1,
> > +	V4L2_FMTX_PREEMPHASIS_DISABLED		= 2,
> > +};
> 
> Hello there,
> 
> Would it make more sense to make:
> "V4L2_FMTX_PREEMPHASIS_DISABLED" as "zero" (false). In my opinion,
> that would be more clear.

Indeed,

Something like:

enum v4l2_fmtx_preemphasis {
	V4L2_FMTX_PREEMPHASIS_DISABLED		= 0,
	V4L2_FMTX_PREEMPHASIS_50_uS		= 1,
	V4L2_FMTX_PREEMPHASIS_75_uS		= 2,
};

looks better?


> 
> - Eero

-- 
Eduardo Valentin

