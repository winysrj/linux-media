Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34906 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751202AbdLUJK7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 04:10:59 -0500
Date: Thu, 21 Dec 2017 11:10:57 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH] media: ov9650: support VIDIOC_DBG_G/S_REGISTER ioctls
Message-ID: <20171221091057.w7ofjniwykqx4c7z@valkosipuli.retiisi.org.uk>
References: <1513180849-7913-1-git-send-email-akinobu.mita@gmail.com>
 <20171219103515.6eetdss4cmlbsxzk@valkosipuli.retiisi.org.uk>
 <CAC5umyiHxSfPRkP21-XJuMgiE8+1fLSMbYNXLYC19cPdXv_8JQ@mail.gmail.com>
 <c16aaa0e-51b5-4b6c-7540-6f6b3f20b15b@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c16aaa0e-51b5-4b6c-7540-6f6b3f20b15b@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Dec 19, 2017 at 04:50:19PM +0100, Hans Verkuil wrote:
> On 19/12/17 16:39, Akinobu Mita wrote:
> > Hi Sakari,
> > 
> > 2017-12-19 19:35 GMT+09:00 Sakari Ailus <sakari.ailus@iki.fi>:
> >> Hi Akinobu,
> >>
> >> On Thu, Dec 14, 2017 at 01:00:49AM +0900, Akinobu Mita wrote:
> >>> This adds support VIDIOC_DBG_G/S_REGISTER ioctls.
> >>>
> >>> There are many device control registers contained in the OV9650.  So
> >>> this helps debugging the lower level issues by getting and setting the
> >>> registers.
> >>>
> >>> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> >>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> >>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> >>
> >> Just wondering --- doesn't the I涎 user space interface offer essentially
> >> the same functionality?
> > 
> > You are right.  I thought /dev/i2c-X interface is not allowed for the
> > i2c device that is currently in use by a driver.  But I found that
> > there is I2C_SLAVE_FORCE ioctl to bypass the check and the i2cget and
> > i2cset with '-f' option use I2C_SLAVE_FORCE ioctls.
> > 
> > So I can live without the proposed patch.
> 
> Sakari, there are lots of drivers that use this. There is nothing wrong with
> it and it is easier to use than the i2c interface (although that's my opinion).
> It certainly is more consistent with other drivers.
> 
> It is also possible to use registernames instead of addresses if the necessary
> patch is applied to v4l2-dbg.

There are existing generic interfaces that provide the same functionality,
in this case without driver changes. With debugfs, you can also use
register names if needed. That's why I'm slightly reluctant in supporting
s_register and g_register.

Let's discuss this on #v4l when you're available.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
