Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:43157 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751011AbdLSPxm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 10:53:42 -0500
Date: Tue, 19 Dec 2017 17:53:38 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        hverkuil@xs4all.nl
Subject: Re: [PATCH] media: ov9650: support VIDIOC_DBG_G/S_REGISTER ioctls
Message-ID: <20171219155338.hwqqnhevn5kf246d@paasikivi.fi.intel.com>
References: <1513180849-7913-1-git-send-email-akinobu.mita@gmail.com>
 <20171219103515.6eetdss4cmlbsxzk@valkosipuli.retiisi.org.uk>
 <CAC5umyiHxSfPRkP21-XJuMgiE8+1fLSMbYNXLYC19cPdXv_8JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC5umyiHxSfPRkP21-XJuMgiE8+1fLSMbYNXLYC19cPdXv_8JQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akinobu,

On Wed, Dec 20, 2017 at 12:39:51AM +0900, Akinobu Mita wrote:
> Hi Sakari,
> 
> 2017-12-19 19:35 GMT+09:00 Sakari Ailus <sakari.ailus@iki.fi>:
> > Hi Akinobu,
> >
> > On Thu, Dec 14, 2017 at 01:00:49AM +0900, Akinobu Mita wrote:
> >> This adds support VIDIOC_DBG_G/S_REGISTER ioctls.
> >>
> >> There are many device control registers contained in the OV9650.  So
> >> this helps debugging the lower level issues by getting and setting the
> >> registers.
> >>
> >> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> >> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> >> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> >
> > Just wondering --- doesn't the I涎 user space interface offer essentially
> > the same functionality?
> 
> You are right.  I thought /dev/i2c-X interface is not allowed for the
> i2c device that is currently in use by a driver.  But I found that
> there is I2C_SLAVE_FORCE ioctl to bypass the check and the i2cget and
> i2cset with '-f' option use I2C_SLAVE_FORCE ioctls.
> 
> So I can live without the proposed patch.

Thanks for checking. It's indeed better to use an existing interface.

There's also debugfs. That might be even better but it requires driver code
to make use of it. Anyway non-I²C devices can use it, too.

I'll mark the patch as rejected.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
