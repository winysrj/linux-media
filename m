Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36084 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753379AbaGULPH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 07:15:07 -0400
Date: Mon, 21 Jul 2014 14:14:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Julien BERAUD <julien.beraud@parrot.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Configurable Video Controller Driver
Message-ID: <20140721111432.GQ16460@valkosipuli.retiisi.org.uk>
References: <53BEA0DA.9000706@parrot.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BEA0DA.9000706@parrot.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julien,

On Thu, Jul 10, 2014 at 04:19:06PM +0200, Julien BERAUD wrote:
> We are developing a driver for our video controller which has the
> particularity of being very reconfigurable.
> 
> We have reached a point at which the complexity and variety of the
> applications we need to implement forces us to
> design an api/library that allows us to configure the
> interconnection of the different video processing units(Camera
> interfaces,
> LCD interfaces, scalers, rotators, demosaicing, dead pixel
> correction, etc...) from userland.
> 
> The media controller api has the limitation of not being able to
> create links but just browsing and activating/deactivating them.
> If we just allowed a user to activate/deactivate links, then we
> would have to declare all the possible connections between
> the different blocks, which would make it very confusing from a
> userland point of view. Moreover, the interconnection constraints
> would have to be dealt with very generically, which would make it
> very difficult in the kernel too.

How many different blocks do you have? Can they be connected in arbitrary
ways? If not, what kind of limitations do you have?

The Media controller is originally intended for modelling complex devices
with hardware data paths between the sub-blocks. The question is: does your
device fit into that group, even if could be a little more complex than the
devices that are currently supported?

> The conclusion we have reached yet is that we have to design an API
> that allows us to create v4l2 subdevices that have certain
> capabilities(scaling,rotating, demosaicing, etc...) and then to
> create links between them from a userland library.

Can you create arbitrary devices at will, or do these devices exist on
hardware all the time?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
