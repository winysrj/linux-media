Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E124C4360F
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 14:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 672472133F
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 14:12:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfCHOMe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:12:34 -0500
Received: from mga14.intel.com ([192.55.52.115]:8231 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbfCHOMe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 09:12:34 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Mar 2019 06:12:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,456,1544515200"; 
   d="scan'208";a="174110592"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga001.jf.intel.com with ESMTP; 08 Mar 2019 06:12:30 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 7B42720399; Fri,  8 Mar 2019 16:12:29 +0200 (EET)
Date:   Fri, 8 Mar 2019 16:12:29 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     niklas soderlund <niklas.soderlund@ragnatech.se>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 00/31] v4l: add support for multiplexed streams
Message-ID: <20190308141229.qflsxk2lhhdohn6a@paasikivi.fi.intel.com>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190307094725.5nrvzz7hn7gfmgxe@paasikivi.fi.intel.com>
 <20190308131903.daja4zzfp47pucsf@uno.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190308131903.daja4zzfp47pucsf@uno.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Mar 08, 2019 at 02:19:03PM +0100, Jacopo Mondi wrote:
> Hi Sakari and Niklas,
> 
> On Thu, Mar 07, 2019 at 11:47:26AM +0200, Sakari Ailus wrote:
> > Hi Jacopo,
> >
> > On Tue, Mar 05, 2019 at 07:51:19PM +0100, Jacopo Mondi wrote:
> > > Hello,
> > >    third version of multiplexed stream support patch series.
> > >
> > > V2 sent by Niklas is available at:
> > > https://patchwork.kernel.org/cover/10573817/
> > >
> > > As per v2, most of the core patches are work from Sakari and Laurent, with
> > > Niklas' support on top for adv748x and rcar-csi2.
> > >
> > > The use case of the series remains the same: support for virtual channel
> > > selection implemented on R-Car Gen3 and adv748x. Quoting the v2 cover letter:
> > >
> > > -------------------------------------------------------------------------------
> > > I have added driver support for the devices used on the Renesas Gen3
> > > platforms, a ADV7482 connected to the R-Car CSI-2 receiver. With these
> > > changes I can control which of the analog inputs of the ADV7482 the
> > > video source is captured from and on which CSI-2 virtual channel the
> > > video is transmitted on to the R-Car CSI-2 receiver.
> > >
> > > The series adds two new subdev IOCTLs [GS]_ROUTING which allows
> > > user-space to get and set routes inside a subdevice. I have added RFC
> > > support for these to v4l-utils [2] which can be used to test this
> > > series, example:
> > >
> > >     Check the internal routing of the adv748x csi-2 transmitter:
> > >     v4l2-ctl -d /dev/v4l-subdev24 --get-routing
> > >     0/0 -> 1/0 [ENABLED]
> > >     0/0 -> 1/1 []
> > >     0/0 -> 1/2 []
> > >     0/0 -> 1/3 []
> > >
> > >
> > >     Select that video should be outputed on VC 2 and check the result:
> > >     $ v4l2-ctl -d /dev/v4l-subdev24 --set-routing '0/0 -> 1/2 [1]'
> > >
> > >     $ v4l2-ctl -d /dev/v4l-subdev24 --get-routing
> > >     0/0 -> 1/0 []
> > >     0/0 -> 1/1 []
> > >     0/0 -> 1/2 [ENABLED]
> > >     0/0 -> 1/3 []
> > > -------------------------------------------------------------------------------
> > >
> > > Below is reported the media graph of the system used for testing [1].
> > >
> > > v4l2-ctl patches to handle the newly introduced IOCTLs are available from
> > > Niklas' repository at:
> > > git://git.ragnatech.se/v4l-utils routing
> >
> > Could you send the v4l2-ctl patches out as well, please?
> >
> 
> Niklas sent them on late 2017... time flies :)
> https://patchwork.kernel.org/patch/10113189/
> 
> Would you like to have them re-sent?

Oh, well, sure, if there are no changes, no need to resend. Thanks for the
pointer.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
