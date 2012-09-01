Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37235 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752043Ab2IAQMC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Sep 2012 12:12:02 -0400
Date: Sat, 1 Sep 2012 19:11:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Rob Landley <rob@landley.net>,
	LMML <linux-media@vger.kernel.org>, hverkuil@xs4all.nl
Subject: Re: [PATCH] [media] davinci: vpfe: Add documentation
Message-ID: <20120901161156.GB6638@valkosipuli.retiisi.org.uk>
References: <1342021166-6092-1-git-send-email-manjunath.hadli@ti.com>
 <CA+V-a8tNnevox8OcXc_jxDzHdrxdF9Z-Nf2Rn0QaBsnM=n5CfA@mail.gmail.com>
 <20120901095707.GB6348@valkosipuli.retiisi.org.uk>
 <8524664.XGp3WDre5y@avalon>
 <CA+V-a8sg+MR8TasN0p9kL0yQU1KtJEZZUQsknC6hrRysWA52UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+V-a8sg+MR8TasN0p9kL0yQU1KtJEZZUQsknC6hrRysWA52UQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On Sat, Sep 01, 2012 at 08:23:58PM +0530, Prabhakar Lad wrote:
> On Sat, Sep 1, 2012 at 7:52 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> > Hi Sakari,
> >
> > On Saturday 01 September 2012 12:57:07 Sakari Ailus wrote:
> >> On Wed, Aug 29, 2012 at 08:11:50PM +0530, Prabhakar Lad wrote:
> >
> > [snip]
> >
> >> > For test pattern you meant control to enable/disable it ?
> >>
> >> There are two approaches I can think of.
> >>
> >> One is a menu control which can be used to choose the test pattern (or
> >> disable it). The control could be standardised but the menu items would have
> >> to be hardware-specific since the test patterns themselves are not
> >> standardised.
> >
> > Agreed. The test patterns themselves are highly hardware-specific.
> >
> > From personal experience with sensors, most devices implement a small, fixed
> > set of test patterns that can be exposed through a menu control. However, some
> > devices also implement more "configurable" test patterns. For instance the
> > MT9V032 can generate horizontal, vertical or diagonal test patterns, or a
> > uniform grey test pattern with a user-configurable value. This would then
> > require two controls.
> >
> two controls I didn't get it ? When we have menu itself with a list of standard
> patterns why would two controls be required ?

Two are not required. A single menu control will do.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
