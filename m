Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:52647 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab1GNLcH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 07:32:07 -0400
Received: from hillosipuli.localdomain (nblzone-211-213.nblnetworks.fi [83.145.211.213])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-68.nebula.fi (Postfix) with ESMTP id 7925A43F053C
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2011 14:32:05 +0300 (EEST)
Received: from valkosipuli.localdomain (valkosipuli.localdomain [192.168.4.2])
	by hillosipuli.localdomain (Postfix) with ESMTP id E86E160098
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2011 14:32:04 +0300 (EEST)
Date: Thu, 14 Jul 2011 14:32:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [RFC] Binning on sensors
Message-ID: <20110714113201.GD27451@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I was thinking about the sensor binning controls.

I have a sensor which can do binning both horizontally and vertically, but
the two are connected. So, the sensor supports e.g. 3x1 and 1x3 binning but
not 3x3.

However, most (I assume) sensors do not have dependencies between the two.
The interface which would be provided to the user still should be able to
tell what is supported, whether the two are independent or not.

I have a few ideas how to achieve this.

1. Implement dependent binning as a menu control. The user will have an easy
way to enumerate binning and select it. If horizontal and vertical binning
factors are independent, two integer controls are provided. The downside is
that there are two ways to do this, and integer to string and back
conversions involved.

2. Menu control is used all the time. The benefit is that the user gets a
single interface, but the downside is that if there are many possible
binning factors both horizontally and vertically, the size of the menu grows
large. Typically binning ends at 2 or 4, though.

3. Implement two integer controls. The user is responsible for selecting a
valid configuration. A way to enumerate possible values would have to be
implemented. One option would be an ioctl but I don't like the idea.

Comments are welcome as always.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
