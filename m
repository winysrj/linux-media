Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:50888 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab1IFN1U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 09:27:20 -0400
Date: Tue, 6 Sep 2011 16:27:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH 0/1] Ignore ctrl_class
Message-ID: <20110906132713.GK1393@valkosipuli.localdomain>
References: <20110906110742.GE1393@valkosipuli.localdomain>
 <201109061320.27093.hverkuil@xs4all.nl>
 <20110906114548.GG1393@valkosipuli.localdomain>
 <201109061455.39177.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109061455.39177.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 06, 2011 at 02:55:39PM +0200, Hans Verkuil wrote:
> On Tuesday, September 06, 2011 13:45:48 Sakari Ailus wrote:
> > Hi Hans,
> > 
> > On Tue, Sep 06, 2011 at 01:20:26PM +0200, Hans Verkuil wrote:
> > > On Tuesday, September 06, 2011 13:07:42 Sakari Ailus wrote:
> > > > Hi,
> > > > 
> > > > I remember being in a discussion a while ago regarding the requirement of
> > > > having all the controls belonging to the same class in
> > > > VIDIOC_{TRY,S,G}_EXT_CTRLS. The answer I remember was that there was a
> > > > historical reason for this and it no longer exists.
> > > 
> > > The original rule was that all controls have to belong to the same class. This was
> > > done to simplify drivers. Drivers that use the control framework can handle a class
> > > of 0, which means that the controls can be of any class.
> > > 
> > > But we still have drivers that implement S_EXT_CTRLS but do not use the control
> > > framework, and for those this restriction is still valid. Usually such drivers will only
> > > handle MPEG class controls through that API.
> > > 
> > > So I don't think this restriction can be lifted as long as there are drivers that do not
> > > use the control framework.
> > 
> > All the drivers which implement *_EXT_CTRLS and check for ctrl_class do the
> > check for a single class. All the references for ctrl_class in individual
> > drivers (which actually were only checks that the user has set the field
> > correctly) are removed by the patch I posted.
> > 
> > So I don't see a reason why we couldn't just say "please set this to zero
> > from now on".
> > 
> > 
> 
> From what I remember (and I may be wrong by now) the drivers that implement S_EXT_CTRLS
> by themselves typically only support ext_ctrls for controls of a specific class (MPEG usually).

That's what I also found out.

> Dropping the check means that: 1) applications may think they can use any
> control when they can't for a certain group of drivers, and 2)

Why? This doesn't change how VIDIOC_QUERYCTRL works. Or am I missing
something?

> applications can no longer detect up front whether a driver supports
> mixing of control classes or not.

I think we shouldn't accept new drivers which don't use the control
framework. The existing drivers only implement controls in a single class,
or ignore the ctrl_class field. The patch I sent removes the check which I
see has only been there to comply with the spec.

> The way you can do 2) is by setting the control class to 0 and calling G/S/TRY_EXT_CTRLS with
> 0 controls.
> 
> Once everything is converted I don't mind dropping this check, but until then I believe it should
> stay.

The patch does everything that is required for this as far as I see.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
