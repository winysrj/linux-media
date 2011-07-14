Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:33088 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab1GNMaB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 08:30:01 -0400
Date: Thu, 14 Jul 2011 15:29:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: nitesh moundekar <niteshmoundekar@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC] Binning on sensors
Message-ID: <20110714122956.GG27451@valkosipuli.localdomain>
References: <20110714113201.GD27451@valkosipuli.localdomain>
 <CAF5T7dk0HN-aBj_uK37=bpGEnsTZ6dwraNNfAOvwFWbtpveBGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF5T7dk0HN-aBj_uK37=bpGEnsTZ6dwraNNfAOvwFWbtpveBGg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 14, 2011 at 05:46:21PM +0530, nitesh moundekar wrote:
> Hi all,
> 
> This is my first mail in linux mailing list and I hope I contribute
> something.
> 
> I worked at image sensor company and I had the idea that binning control are
> used by these companies to get optimum performance & power usage for their
> sensors at various resolutions in their drivers. I have not seen sensor
> binning usage at user level. Can we get some use cases ?

Hi Nitesh,

This is related to performing sensor configuration from user space. Binning
is just one of the settings the sensors have, and it should be exposed to
user space as such rather than be implicitly set by the sensor driver based
on other settings such as the output resolution.

Binning controls (or other interface) would most likely be available on
v4l2_subdev user space interface which is exposed by the sensor driver.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
