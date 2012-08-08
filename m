Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57479 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932436Ab2HHIYN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Aug 2012 04:24:13 -0400
Date: Wed, 8 Aug 2012 11:24:08 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: James <bjlockie@lockie.ca>
Cc: Andy Walls <awalls@md.metrocast.net>,
	linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: boot slow down
Message-ID: <20120808082408.GE29636@valkosipuli.retiisi.org.uk>
References: <501D4535.8080404@lockie.ca>
 <f1bd5aea-00cd-4b3f-9562-d25153f8cef3@email.android.com>
 <501DA203.7070800@lockie.ca>
 <20120805212054.GA29636@valkosipuli.retiisi.org.uk>
 <501F4A5B.1000608@lockie.ca>
 <20120807112742.GB29636@valkosipuli.retiisi.org.uk>
 <6ef5338940a90b4c8000594d546bf479.squirrel@lockie.ca>
 <32d7859a-ceda-442d-be67-f4f682a6e3b9@email.android.com>
 <48430fdf908e6481ae55103bd11b7cfe.squirrel@lockie.ca>
 <50218BD8.8040207@lockie.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50218BD8.8040207@lockie.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James,

On Tue, Aug 07, 2012 at 05:42:48PM -0400, James wrote:
...
> This is what I tried before.
> It implies that I shouldn't need user space.
> 
>   ???????????????????????????????????? Include in-kernel firmware blobs in kernel binary ????????????????????????????????????
>   ??? CONFIG_FIRMWARE_IN_KERNEL:                                              ???  
>   ???                                                                         ???  
>   ??? The kernel source tree includes a number of firmware 'blobs'            ???  
>   ??? that are used by various drivers. The recommended way to                ???  
>   ??? use these is to run "make firmware_install", which, after               ???  
>   ??? converting ihex files to binary, copies all of the needed               ???  
>   ??? binary files in firmware/ to /lib/firmware/ on your system so           ???  
>   ??? that they can be loaded by userspace helpers on request.                ???  
>   ???                                                                         ???  
>   ??? Enabling this option will build each required firmware blob             ???  
>   ??? into the kernel directly, where request_firmware() will find            ???  
>   ??? them without having to call out to userspace. This may be               ???  
>   ??? useful if your root file system requires a device that uses             ???  
>   ??? such firmware and do not wish to use an initrd.                         ???  
>   ???                                                                         ???  
>   ??? This single option controls the inclusion of firmware for               ???  
>   ??? every driver that uses request_firmware() and ships its                 ???  
>   ??? firmware in the kernel source tree, which avoids a                      ???  
>   ??? proliferation of 'Include firmware for xxx device' options.             ???  
>   ???                                                                         ???  
>   ??? Say 'N' and let firmware be loaded from userspace.

I guess this only applies to firmware blobs which are part of the kernel.
Not all of them are.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
