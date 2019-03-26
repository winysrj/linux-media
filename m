Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF1FEC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 11:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B72222070B
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 11:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731423AbfCZLhc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 07:37:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:13907 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730722AbfCZLhb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 07:37:31 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Mar 2019 04:37:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,271,1549958400"; 
   d="scan'208";a="310505879"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga005.jf.intel.com with ESMTP; 26 Mar 2019 04:37:26 -0700
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id F36C6207E2; Tue, 26 Mar 2019 13:37:25 +0200 (EET)
Date:   Tue, 26 Mar 2019 13:37:25 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Mickael GUENE <mickael.guene@st.com>
Cc:     Sakari Ailus <sakari.ailus@iki.fi>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Kao <ben.kao@intel.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Jason Chen <jasonx.z.chen@intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Tianshu Qiu <tian.shu.qiu@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>
Subject: Re: [PATCH v1 2/3] media:st-mipid02: MIPID02 CSI-2 to PARALLEL
 bridge driver
Message-ID: <20190326113725.mx3ixvy4tunb44xw@paasikivi.fi.intel.com>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1552373045-134493-3-git-send-email-mickael.guene@st.com>
 <20190316221437.e3ukdpgyn2yq72tu@valkosipuli.retiisi.org.uk>
 <024de1c6-3e40-ac5a-586e-d9878947ff18@st.com>
 <20190325111746.h26isglf4d765mtg@kekkonen.localdomain>
 <80f98c19-6045-9f7c-d549-f559ae8eb9d9@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80f98c19-6045-9f7c-d549-f559ae8eb9d9@st.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Mar 25, 2019 at 12:14:05PM +0000, Mickael GUENE wrote:
> Hi Sakari,
> 
> On 3/25/19 12:17, Sakari Ailus wrote:
> > Hi Mickael,
> > 
> > On Mon, Mar 18, 2019 at 09:57:44AM +0000, Mickael GUENE wrote:
> >> Hi Sakari,
> >>
> >> Thanks for your review. Find my comments below.
> >>
> >> On 3/16/19 23:14, Sakari Ailus wrote:
> > ...
> >>>> +static struct v4l2_subdev *mipid02_find_sensor(struct mipid02_dev *bridge)
> >>>> +{
> >>>> +	struct media_device *mdev = bridge->sd.v4l2_dev->mdev;
> >>>> +	struct media_entity *entity;
> >>>> +
> >>>> +	if (!mdev)
> >>>> +		return NULL;
> >>>> +
> >>>> +	media_device_for_each_entity(entity, mdev)
> >>>> +		if (entity->function == MEDIA_ENT_F_CAM_SENSOR)
> >>>> +			return media_entity_to_v4l2_subdev(entity);
> >>>
> >>> Hmm. Could you instead use the link state to determine which of the
> >>> receivers is active? You'll need one more pad, and then you'd had 1:1
> >>> mapping between ports and pads.
> >>>
> >>  Goal here is not to detect which of the receivers is active but to find
> >> sensor in case there are others sub-dev in chain (for example a 
> >> serializer/deserializer as found in cars).
> > 
> > You shouldn't make assumptions on the rest of the pipeline beyond the
> > device that's directly connected. You might not even have a camera there.
> > 
>  I have also seen your answer to '[PATCH v2 2/2] media:st-mipid02: MIPID02 CSI-2 to PARALLEL bridge driver'
> concerning support of set_fmt, get_fmt and link_validate.
>  My initial idea was to avoid to avoid to implement them and to avoid media ctrl configuration. According
> to your remark is seems a bad idea. Right ?

Yes, you'll need them. This is how the media controller pipeline works: a
driver for a given device is generally only aware of its direct links and
generally only communicate with drivers for devices directly connected to
them.

>  In that case I have to also implement enum_mbus_code ?

Yes, please.

>  I will drop this code and use connected device only to get link speed.

Ack.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
