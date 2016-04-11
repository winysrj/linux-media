Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60242 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304AbcDKUWH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2016 16:22:07 -0400
Received: from minime.bse ([77.22.132.34]) by mail.gmx.com (mrgmx001) with
 ESMTPSA (Nemesis) id 0LlDb4-1bOUfN2zVW-00b0Gu for
 <linux-media@vger.kernel.org>; Mon, 11 Apr 2016 22:22:03 +0200
Date: Mon, 11 Apr 2016 22:22:02 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Dennis Wassenberg <dennis.wassenberg@secunet.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Question regarding internal webcams of tablet devices
Message-ID: <20160411202202.GA13600@minime.bse>
References: <56DEEDDD.3030401@secunet.com>
 <20160308162308.GA30031@minime.bse>
 <56E69DA7.3070501@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56E69DA7.3070501@secunet.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 14, 2016 at 12:16:55PM +0100, Dennis Wassenberg wrote:
> do you know where I can get the source code of these drivers for
> Baytrail, Anniedale or Cherrytrail? I am not familiar with the Android
> kernel. I checked git://git.code.sf.net/p/android-x86/kernel but could
> not find any PCI CSI2 host controller driver. At
> https://android.googlesource.com/kernel/x86_64.git I found some MIPI
> stuff at drivers/external_drivers/intel_media/ but no CSI-2 driver.

Sorry, didn't see your mail.

Search for atomisp2 and you will find it.

Best regards,

  Daniel
