Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932464Ab0JVR7X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 13:59:23 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9MHxMrh016629
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 22 Oct 2010 13:59:23 -0400
Date: Fri, 22 Oct 2010 13:59:22 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] mceusb: allow per-model data
Message-ID: <20101022175922.GA30199@redhat.com>
References: <20101022112529.36638e7e@pedra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022112529.36638e7e@pedra>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Oct 22, 2010 at 11:25:29AM -0200, Mauro Carvalho Chehab wrote:
> This is a series of patches to allow per-device data on mceusb. It basically
> removes the duplicate USB ID's from the driver, and adds a per-model
> struct, where quirks may be specified, and extra data, like per-model
> rc_map tables can be stored.
> 
> Unfortunately, I don't have any branded cx231xx device using mceusb,
> but, as I wanted to have an example on how to do the association,
> and knowing that the Conexant Polaris EVK Kit is not a device that users
> will tipically find, I've associated it to the Hauppauge Grey rc map.
> 
> Mauro Carvalho Chehab (3):
>   mceusb: add a per-model structure
>   mceusb: allow a per-model RC map
>   mceusb: Allow a per-model device name

Whole series looks good to me. Going to commit this, along with some
additonal work on top of it in my tree, then have you pull from there...

-- 
Jarod Wilson
jarod@redhat.com

