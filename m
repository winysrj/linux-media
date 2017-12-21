Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:32945 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750920AbdLUWes (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 17:34:48 -0500
Date: Fri, 22 Dec 2017 00:34:43 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Kristian Beilke <beilke@posteo.de>
Subject: Re: [PATCH v1 05/10] staging: atomisp: Remove non-ACPI leftovers
Message-ID: <20171221223443.4uvp7ahrnjv5ga6a@kekkonen.localdomain>
References: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
 <20171219205957.10933-5-andriy.shevchenko@linux.intel.com>
 <20171220045416.qbge74ntj4s4zlcm@mwanda>
 <CAHp75VcoYnvwrdVQnMmtPfuiRg0AFOSa5WwfhTk3HP0ww7x5VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcoYnvwrdVQnMmtPfuiRg0AFOSa5WwfhTk3HP0ww7x5VA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy and Dan,

On Wed, Dec 20, 2017 at 12:24:36PM +0200, Andy Shevchenko wrote:
> On Wed, Dec 20, 2017 at 6:54 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Tue, Dec 19, 2017 at 10:59:52PM +0200, Andy Shevchenko wrote:
> >> @@ -1147,10 +1145,8 @@ static int gc2235_probe(struct i2c_client *client)
> >>       if (ret)
> >>               gc2235_remove(client);
> >
> > This error handling is probably wrong...
> >
> 
> Thanks for pointing to this, but I'm not going to fix this by the
> following reasons:
> 1. I admit the driver's code is ugly
> 2. It's staging code
> 3. My patch does not touch those lines
> 4. My purpose is to get it working first.
> 
> Feel free to send a followup with a good clean up which I agree with.

Yeah, there's a lot of ugly stuff in this driver... I understand Andy's
patches address problems with functionality, let's make error handling
fixes separately.

So I'm applying these now.

Thanks!

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
