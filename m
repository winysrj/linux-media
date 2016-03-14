Return-path: <linux-media-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:58049 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbcCNLSW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 07:18:22 -0400
Subject: Re: Question regarding internal webcams of tablet devices
References: <56DEEDDD.3030401@secunet.com> <20160308162308.GA30031@minime.bse>
CC: <linux-media@vger.kernel.org>
To: =?UTF-8?Q?Daniel_Gl=c3=b6ckner?= <daniel-gl@gmx.net>
From: Dennis Wassenberg <dennis.wassenberg@secunet.com>
Message-ID: <56E69DA7.3070501@secunet.com>
Date: Mon, 14 Mar 2016 12:16:55 +0100
MIME-Version: 1.0
In-Reply-To: <20160308162308.GA30031@minime.bse>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

do you know where I can get the source code of these drivers for
Baytrail, Anniedale or Cherrytrail? I am not familiar with the Android
kernel. I checked git://git.code.sf.net/p/android-x86/kernel but could
not find any PCI CSI2 host controller driver. At
https://android.googlesource.com/kernel/x86_64.git I found some MIPI
stuff at drivers/external_drivers/intel_media/ but no CSI-2 driver.

Thank you & best regards,

Dennis

On 08.03.2016 17:23, Daniel Glöckner wrote:
> Hi,
> 
> On Tue, Mar 08, 2016 at 04:21:01PM +0100, Dennis Wassenberg wrote:
>> However, at first there is the need to get a driver for the camera IO
>> host controller PCI device. Is there anybody how knows a driver for that
>> pci device or known if there will be a driver for that in the future? Is
>> this the right way to support this kind of cameras or is there an other
>> way to get such cameras working with linux?
> 
> I know that Intel wrote a GPLv2 driver for the CSI host controller in
> Merrifield, Baytrail, Anniedale and Cherrytrail. It is part of their
> Android kernel. You might have luck searching for an Android kernel
> for a Skylake tablet. But be careful, the driver I know only supports
> a fixed set of configurations. It seems like Intel expects every
> manufacturer to just copy their reference design down to the GPIO
> numbers used to reset the camera sensors.
> 
> Best regards,
> 
>   Daniel
> 
