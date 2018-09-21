Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:50560 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727392AbeIUTbM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 15:31:12 -0400
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: Tomasz Figa <tfiga@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Subject: RE: [PATCH v6 06/12] intel-ipu3: css: Add support for firmware
 management
Date: Fri, 21 Sep 2018 13:42:13 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D3DAFBDFD@ORSMSX103.amr.corp.intel.com>
References: <1522376100-22098-1-git-send-email-yong.zhi@intel.com>
 <1522376100-22098-7-git-send-email-yong.zhi@intel.com>
 <CAAFQd5BdEvzEv63oXpC1PmPdut8kNmFzdL63nEVqhnLHets2ZA@mail.gmail.com>
 <C193D76D23A22742993887E6D207B54D3DAFB78C@ORSMSX103.amr.corp.intel.com>
 <20180921115154.5uscfe2eqt75ugsp@kekkonen.localdomain>
In-Reply-To: <20180921115154.5uscfe2eqt75ugsp@kekkonen.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sakari,

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> Sent: Friday, September 21, 2018 6:52 AM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: Tomasz Figa <tfiga@chromium.org>; Linux Media Mailing List <linux-
> media@vger.kernel.org>; Mani, Rajmohan <rajmohan.mani@intel.com>;
> Toivonen, Tuukka <tuukka.toivonen@intel.com>; Hu, Jerry W
> <jerry.w.hu@intel.com>; Zheng, Jian Xu <jian.xu.zheng@intel.com>
> Subject: Re: [PATCH v6 06/12] intel-ipu3: css: Add support for firmware
> management
> 
> Hi Yong,
> 
> On Wed, Sep 19, 2018 at 10:57:55PM +0000, Zhi, Yong wrote:
> ...
> > > > +struct imgu_abi_osys_frame_params {
> > > > +       /* Output pins */
> > > > +       __u32 enable;
> > > > +       __u32 format;           /* enum imgu_abi_osys_format */
> > > > +       __u32 flip;
> > > > +       __u32 mirror;
> > > > +       __u32 tiling;           /* enum imgu_abi_osys_tiling */
> > > > +       __u32 width;
> > > > +       __u32 height;
> > > > +       __u32 stride;
> > > > +       __u32 scaled;
> > > > +} __packed;
> > > [snip]
> > > > +/* Defect pixel correction */
> > > > +
> > > > +struct imgu_abi_dpc_config {
> > > > +       __u8 __reserved[240832];
> > > > +} __packed;
> > >
> > > Do we need this structure? One could just add a reserved field in
> > > the parent structure. Also, just to confirm, is 240832 really the right
> value here?
> > > Where does it come from? Please create a macro for it, possibly
> > > further breaking it down into the values used to compute this number.
> > >
> >
> > We can add a reserved field in the parent structure, the size is based
> > on original definition of dpc config which was removed since it's not
> > enabled/used.
> 
> What's your plan with the DPC? If you don't plan to add it now, you could
> as well drop the configuration for that block. If there's a need to add it later
> on, you can still do it by defining a new struct for the buffer. Or simply
> adding it at the end of the existing struct while allowing the use of the old
> size without the DPC configuration.
> 
> There would be a little extra work to do there by that time when DPC
> support would be added, but OTOH it seems silly to have quarter of a
> megabyte of extra stuff to pass around in a struct that's never used.
> 
> --
> Regards,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com

It's a very good point, but as I was informed, there is no plan to update the abi between the driver and firmware, so the size of imgu_abi_acc_param has not changed since v1 to maintain the compatibility.
