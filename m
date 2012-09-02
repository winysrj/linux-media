Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40382 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab2IBDDf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Sep 2012 23:03:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Rob Landley <rob@landley.net>,
	LMML <linux-media@vger.kernel.org>, hverkuil@xs4all.nl
Subject: Re: [PATCH] [media] davinci: vpfe: Add documentation
Date: Sun, 02 Sep 2012 05:03:58 +0200
Message-ID: <1459671.FPoEVypYcA@avalon>
In-Reply-To: <20120901161156.GB6638@valkosipuli.retiisi.org.uk>
References: <1342021166-6092-1-git-send-email-manjunath.hadli@ti.com> <CA+V-a8sg+MR8TasN0p9kL0yQU1KtJEZZUQsknC6hrRysWA52UQ@mail.gmail.com> <20120901161156.GB6638@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 01 September 2012 19:11:56 Sakari Ailus wrote:
> Hi Prabhakar,
> 
> On Sat, Sep 01, 2012 at 08:23:58PM +0530, Prabhakar Lad wrote:
> > On Sat, Sep 1, 2012 at 7:52 PM, Laurent Pinchart
> > 
> > <laurent.pinchart@ideasonboard.com> wrote:
> > > Hi Sakari,
> > > 
> > > On Saturday 01 September 2012 12:57:07 Sakari Ailus wrote:
> > >> On Wed, Aug 29, 2012 at 08:11:50PM +0530, Prabhakar Lad wrote:
> > > [snip]
> > > 
> > >> > For test pattern you meant control to enable/disable it ?
> > >> 
> > >> There are two approaches I can think of.
> > >> 
> > >> One is a menu control which can be used to choose the test pattern (or
> > >> disable it). The control could be standardised but the menu items would
> > >> have to be hardware-specific since the test patterns themselves are
> > >> not standardised.
> > > 
> > > Agreed. The test patterns themselves are highly hardware-specific.
> > > 
> > > From personal experience with sensors, most devices implement a small,
> > > fixed set of test patterns that can be exposed through a menu control.
> > > However, some devices also implement more "configurable" test patterns.
> > > For instance the MT9V032 can generate horizontal, vertical or diagonal
> > > test patterns, or a uniform grey test pattern with a user-configurable
> > > value. This would then require two controls.
> > 
> > two controls I didn't get it ? When we have menu itself with a list of
> > standard patterns why would two controls be required ?
> 
> Two are not required. A single menu control will do.

That's correct, in this case a single menu control will do. We would only need 
multiple controls if the device exposes test pattern parameters, as in the 
MT9V032 sensor example.

-- 
Regards,

Laurent Pinchart

