Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:62795 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbcCHQW3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2016 11:22:29 -0500
Received: from minime.bse ([77.20.40.102]) by mail.gmx.com (mrgmx001) with
 ESMTPSA (Nemesis) id 0MHXXo-1aa11C49fQ-003Kh9 for
 <linux-media@vger.kernel.org>; Tue, 08 Mar 2016 17:22:27 +0100
Date: Tue, 8 Mar 2016 17:23:09 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Dennis Wassenberg <dennis.wassenberg@secunet.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Question regarding internal webcams of tablet devices
Message-ID: <20160308162308.GA30031@minime.bse>
References: <56DEEDDD.3030401@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56DEEDDD.3030401@secunet.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, Mar 08, 2016 at 04:21:01PM +0100, Dennis Wassenberg wrote:
> However, at first there is the need to get a driver for the camera IO
> host controller PCI device. Is there anybody how knows a driver for that
> pci device or known if there will be a driver for that in the future? Is
> this the right way to support this kind of cameras or is there an other
> way to get such cameras working with linux?

I know that Intel wrote a GPLv2 driver for the CSI host controller in
Merrifield, Baytrail, Anniedale and Cherrytrail. It is part of their
Android kernel. You might have luck searching for an Android kernel
for a Skylake tablet. But be careful, the driver I know only supports
a fixed set of configurations. It seems like Intel expects every
manufacturer to just copy their reference design down to the GPIO
numbers used to reset the camera sensors.

Best regards,

  Daniel
