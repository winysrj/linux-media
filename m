Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57940 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751636AbdJIJe3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 05:34:29 -0400
Date: Mon, 9 Oct 2017 12:34:26 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, hansverk@cisco.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH] [media] ov5645: I2C address change
Message-ID: <20171009093425.ftxgckycj2nuumle@valkosipuli.retiisi.org.uk>
References: <1506950925-13924-1-git-send-email-todor.tomov@linaro.org>
 <20171004103008.g7azpn4a3hfj4fs2@valkosipuli.retiisi.org.uk>
 <3073637.dhNDna4gKQ@avalon>
 <edc2f078-0896-d9c7-f52a-e5d0604fdeea@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <edc2f078-0896-d9c7-f52a-e5d0604fdeea@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Mon, Oct 09, 2017 at 11:36:01AM +0300, Todor Tomov wrote:
> Hi Sakari,
> 
> On  4.10.2017 13:47, Laurent Pinchart wrote:
> > CC'ing the I2C mainling list and the I2C maintainer.
> > 
> > On Wednesday, 4 October 2017 13:30:08 EEST Sakari Ailus wrote:
> >> Hi Todor,
> >>
> >> On Mon, Oct 02, 2017 at 04:28:45PM +0300, Todor Tomov wrote:
> >>> As soon as the sensor is powered on, change the I2C address to the one
> >>> specified in DT. This allows to use multiple physical sensors connected
> >>> to the same I2C bus.
> >>>
> >>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> >>
> >> The smiapp driver does something similar and I understand Laurent might be
> >> interested in such functionality as well.
> >>
> >> It'd be nice to handle this through the I²C framework instead and to define
> >> how the information is specified through DT. That way it could be made
> >> generic, to work with more devices than just this one.
> >>
> >> What do you think?
> 
> Thank you for this suggestion.
> 
> The way I have done it is to put the new I2C address in the DT and the driver
> programs the change using the original I2C address. The original I2C address
> is hardcoded in the driver. So maybe we can extend the DT binding and the I2C
> framework so that both addresses come from the DT and avoid hiding the
> original I2C address in the driver. This sounds good to me.

Agreed.

In this case the address is known but in general that's not the case it's
not that simple. There are register compatible devices that have different
addresses even if they're the same devices.

It might be a good idea to make this explicit.

> 
> Then changing the address could be device specific and also this must be done
> right after power on so that there are no address conflicts. So I don't think
> that we can support this through the I2C framework only, the drivers that we
> want to do that will have to be expanded with this functionality. Or do you
> have any other idea?

Yes, how the address is changed is always hardware specific. This would be
most conveniently done in driver's probe or PM runtime_resume functions.

It could be as simple as providing an adapter specific mutex to serialise
address changes on the bus so that no two address changes are taking place
at the same time. Which is essentially the impliementation you had, only
the mutex would be for the I²C adapter, not the driver. An helper functions
for acquiring and releasing the mutex.

I wonder what others think.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
