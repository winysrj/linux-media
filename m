Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.aswsp.com ([193.34.35.150]:47391 "EHLO mail.aswsp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaGJOYu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jul 2014 10:24:50 -0400
Message-ID: <53BEA0DA.9000706@parrot.com>
Date: Thu, 10 Jul 2014 16:19:06 +0200
From: Julien BERAUD <julien.beraud@parrot.com>
MIME-Version: 1.0
To: <linux-media@vger.kernel.org>
Subject: Configurable Video Controller Driver
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

We are developing a driver for our video controller which has the 
particularity of being very reconfigurable.

We have reached a point at which the complexity and variety of the 
applications we need to implement forces us to
design an api/library that allows us to configure the interconnection of 
the different video processing units(Camera interfaces,
LCD interfaces, scalers, rotators, demosaicing, dead pixel correction, 
etc...) from userland.

The media controller api has the limitation of not being able to create 
links but just browsing and activating/deactivating them.
If we just allowed a user to activate/deactivate links, then we would 
have to declare all the possible connections between
the different blocks, which would make it very confusing from a userland 
point of view. Moreover, the interconnection constraints
would have to be dealt with very generically, which would make it very 
difficult in the kernel too.

The conclusion we have reached yet is that we have to design an API that 
allows us to create v4l2 subdevices that have certain 
capabilities(scaling,rotating, demosaicing, etc...) and then to create 
links between them from a userland library.
I would like to know if anything like this has been implemented yet or 
if someone has been thinking about such an
architecture before.

Thanks for your inputs,
Julien BERAUD

