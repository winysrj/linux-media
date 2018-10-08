Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:42784 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbeJICTs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Oct 2018 22:19:48 -0400
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>
CC: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Li, Chao C" <chao.c.li@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>
Subject: RE: [PATCH v1 2/2] v4l: Document Intel IPU3 meta data uAPI
Date: Mon, 8 Oct 2018 19:06:30 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A5981514BDE@fmsmsx122.amr.corp.intel.com>
References: <1529033373-15724-1-git-send-email-yong.zhi@intel.com>
 <1529033373-15724-3-git-send-email-yong.zhi@intel.com>
 <749a58a4-24f7-672f-70a9-cfd584af0171@xs4all.nl>
 <20180813174950.6fd3915f@coco.lan>
 <6F87890CF0F5204F892DEA1EF0D77A5981514022@fmsmsx122.amr.corp.intel.com>
 <20181004070841.cxfjsc5d5ul6l7pe@paasikivi.fi.intel.com>
In-Reply-To: <20181004070841.cxfjsc5d5ul6l7pe@paasikivi.fi.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

> -----Original Message-----
> From: sakari.ailus@linux.intel.com [mailto:sakari.ailus@linux.intel.com]
> Sent: Thursday, October 04, 2018 12:09 AM
> To: Mani, Rajmohan <rajmohan.mani@intel.com>
> Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>; Hans Verkuil
> <hverkuil@xs4all.nl>; Zhi, Yong <yong.zhi@intel.com>; linux-
> media@vger.kernel.org; tfiga@chromium.org; mchehab@kernel.org;
> hans.verkuil@cisco.com; laurent.pinchart@ideasonboard.com; Zheng, Jian Xu
> <jian.xu.zheng@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>; Li, Chao C
> <chao.c.li@intel.com>; Qiu, Tian Shu <tian.shu.qiu@intel.com>
> Subject: Re: [PATCH v1 2/2] v4l: Document Intel IPU3 meta data uAPI
> 
> Hi Raj,
> 
> On Wed, Oct 03, 2018 at 10:56:19PM +0000, Mani, Rajmohan wrote:
> ...
> > > From some comment you had later,
> > > I guess you're meaning that only 3 or 7 are the valid values.
> > >
> > > Yet, you're listing from 2^3 to 2^7, and that's confusing. Perhaps
> > > you want to say, instead, that the valid values are at the 3..7 range?
> > > If so, please use something like "values at the [3..7] range".
> > >
> >
> > As Sakari pointed / preferred in the other thread, we will use the
> > format [3, 7] to represent all integers between 3 and 7, including 3 and 7.
> 
> Feel free to add a reference to this in the format documentation:
> 
> <URL:https://en.wikipedia.org/wiki/Interval_(mathematics)>
> 
> I guess the right place would be the top parameter format ReST document.
> 

Ack

> ...
> 
> > > > > + * All above has precision u0.4, range [0..0xF].
> > >
> > > again, what do you mean by u0.4?
> >
> > unsigned integer with 0 bits used for representing whole number, with
> > 4 least significant bits used to represent the fractional part.
> 
> You could refer to this:
> 
> <URL:https://en.wikipedia.org/wiki/Q_(number_format)>
> 
> The ux.y notation is more common in the context of software but I couldn't
> find any decent document to refer to.
> 

Ack.
Will stick with ux.y notation with the relevant documentation (unless there
Is a preference for Q format).

> --
> Regards,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com
