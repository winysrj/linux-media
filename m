Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:6760 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727394AbeJDWyb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 18:54:31 -0400
Date: Thu, 4 Oct 2018 18:57:50 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: "Chen, Ping-chung" <ping-chung.chen@intel.com>
Cc: "Yeh, Andy" <andy.yeh@intel.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "sylwester.nawrocki@gmail.com" <sylwester.nawrocki@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        "Lai, Jim" <jim.lai@intel.com>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Subject: Re: [PATCH v5] media: imx208: Add imx208 camera sensor driver
Message-ID: <20181004155748.n2mppg5nnbzrkhx7@kekkonen.localdomain>
References: <1961986.b6erRuqaPp@avalon>
 <CAPybu_2pCy4EJnih+1pmr43gdh5J0BS_Z0Owb5qpJVkYcDHtyQ@mail.gmail.com>
 <5E40A82D0551C84FA2888225EDABBE093FACCF63@PGSMSX105.gar.corp.intel.com>
 <20180925092527.4apdggynxleigvbv@paasikivi.fi.intel.com>
 <5E40A82D0551C84FA2888225EDABBE093FACD5E5@PGSMSX105.gar.corp.intel.com>
 <20180925215442.dugem7hcywaopl6s@kekkonen.localdomain>
 <5E40A82D0551C84FA2888225EDABBE093FACD6AF@PGSMSX105.gar.corp.intel.com>
 <20180926101132.iydcsn6o3qbi32u4@kekkonen.localdomain>
 <8E0971CCB6EA9D41AF58191A2D3978B61D7A567A@PGSMSX111.gar.corp.intel.com>
 <5E40A82D0551C84FA2888225EDABBE093FACDA2D@PGSMSX105.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5E40A82D0551C84FA2888225EDABBE093FACDA2D@PGSMSX105.gar.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ping-chung,

On Thu, Sep 27, 2018 at 03:19:07AM +0000, Chen, Ping-chung wrote:
> Hi,
> 
> >-----Original Message-----
> >From: Yeh, Andy 
> >Sent: Wednesday, September 26, 2018 11:19 PM
> >To: Sakari Ailus <sakari.ailus@linux.intel.com>; Chen, Ping-chung <ping-chung.chen@intel.com>
> 
> >Hi Sakari, PC,
> 
> >sensors that do need >digital gain applied, too --- assuming it'd be 
> >combined with the TRY_EXT_CTRLS rounding flags.
> >>
> >> There might be many kinds of discrete DG formats. For imx208, DG=2^n, 
> >> but for other sensors, DG could be 2*n, 5*n, or other styles. If HAL 
> >> needs to
> >
> >I guess the most common is multiplication and a bit shift (by e.g. 8), e.g.
> >multiplying the value by a 16-bit number with a 8-bit fractional part. 
> >The
> >imx208 apparently lacks the multiplication and only has the bit shift.
> >
> >Usually there's some sort of technical reason for the choice of the 
> >digital gain implementation and therefore I expect at least the vast 
> >majority of the implementations to be either of the two.
> 
> >We shall ensure the expansibility of this architecture to include other kind of styles in the future. Is this API design architecture-wise ok?
> 
> Indeed. Seems it is hard to cover all rules and HAL needs complex flow to
> judge the DG value. Hi Sakari, could you provide an example that how HAL
> uses the modified interface to set available digital gain?

It'll require more user space code no matter how you'd implement this.

Thinking this again, I don't think you'd be doing harm by resorting to an
integer menu here. It'll take some more time to get a decent API to provide
information on the units etc. to the user space.

> >> cover all cases, kernel will have to update more information to this 
> >> control. Another problem is should HAL take over the SMIA calculation?
> >> If so, kernel will also need to update SMIA parameters to user space 
> >> (or create an addition filed for SMIA in the configuration XML file).
> >
> >The parameters for the analogue gain model should come from the driver, yes.
> >We do not have controls for that purpose but they can (and should) be added.
> >
> 
> >How about still follow PC's proposal to implement in XML? It was in IQ tuning file before which is in userspace. Even I proposed to PC to study with ICG SW team whether this info could be retrieved from 3A algorithm.
> 
> Hi Andy, because we has to use total gain instead of AG in 3A for the WA, our tuning data of imx208 will not include SMIA of AG anymore. 
> So HAL has no way to retrieve correct SMIA parameters of AG from 3A.

Ideally the driver would be able to provide enough information here to the
user space to work with it. This needs improvement going forward, but in a
way that is generic enough.

-- 
Kind regards.

Sakari Ailus
sakari.ailus@linux.intel.com
