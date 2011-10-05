Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:42363 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934271Ab1JENmH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 09:42:07 -0400
Date: Wed, 5 Oct 2011 16:42:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Enrico <ebutera@users.berlios.de>
Cc: Paul Chiha <paul.chiha@greyinnovation.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: Help with omap3isp resizing
Message-ID: <20111005134202.GB8614@valkosipuli.localdomain>
References: <51A4F524D105AA4C93787F33E2C90E62EE5203@greysvr02.GreyInnovation.local>
 <201110041350.33441.laurent.pinchart@ideasonboard.com>
 <1317729252.8358.54.camel@iivanov-desktop>
 <201110041500.56885.laurent.pinchart@ideasonboard.com>
 <51A4F524D105AA4C93787F33E2C90E62EE5350@greysvr02.GreyInnovation.local>
 <20111005105438.GA8614@valkosipuli.localdomain>
 <CA+2YH7vRZ9XVT-DMowOnCd0mbTWR6b3drPHAfRjsNuq3m+Kudg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+2YH7vRZ9XVT-DMowOnCd0mbTWR6b3drPHAfRjsNuq3m+Kudg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 05, 2011 at 03:09:48PM +0200, Enrico wrote:
> On Wed, Oct 5, 2011 at 12:54 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > On Wed, Oct 05, 2011 at 01:51:29PM +1100, Paul Chiha wrote:
> >> Thanks for your help. I've updated ispccdc.c to support the _1X16 codes
> >> and the pipeline seems to work now. However, I needed to take out the
> >> memcpy in ccdc_try_format(), because otherwise pad 0 format was being
> >> copied to pad 1 or 2, regardless of what pad 1 or 2 were being set to. I'm
> >> not sure why it was done that way. I think it's better that the given code
> >> gets checked to see if it's in the list and if so use it. Do you know of
> >> any valid reason why this copy is done?
> >
> > If I remember corretly, it's because there's nothing the CCDC may do to the
> > size of the image --- the driver doesn't either support cropping on the
> > CCDC. The sink format used to be always the same as the source format, the
> > assumption which no longer is valid when YUYV8_2X8 etc. formats are
> > supported. This must be taken into account, i.e. YUYV8_2X8 must be converted
> > to YUYV8_1X16 instead of just copying the format as such.
> 
> Looking at omap trm (spruf98t, July 2011) figure 12-103 it seems
> possible to set some registers (start pixel horizontal/vertical and so
> on...) to crop the "final" image, but i never tested it.

Yeah; cropping should work fine on the CCDC as well but the driver doesn't
implement it.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
