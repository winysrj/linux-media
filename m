Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36630 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725756AbeKOFuA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 00:50:00 -0500
Received: by mail-lf1-f67.google.com with SMTP id h192so12423756lfg.3
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 11:45:26 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Wed, 14 Nov 2018 20:45:23 +0100
To: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 30/30] rcar-csi2: expose the subdevice internal routing
Message-ID: <20181114194523.GE6901@bigcity.dyn.berto.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-31-niklas.soderlund+renesas@ragnatech.se>
 <aae0c45f-4c22-d463-1f1f-36e368d96bc5@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aae0c45f-4c22-d463-1f1f-36e368d96bc5@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nikita,

Thanks for your feedback.

On 2018-11-14 16:10:37 +0300, Nikita Yushchenko wrote:
> > +	for (i = 0; i < fd.num_entries; i++) {
> > +		struct v4l2_mbus_frame_desc_entry *entry = &fd.entry[i];
> > +		int source_pad;
> > +
> > +		source_pad = rcsi2_vc_to_pad(entry->bus.csi2.channel);
> > +		if (source_pad < 0) {
> > +			dev_err(priv->dev, "Virtual Channel out of range: %u\n",
> > +				entry->bus.csi2.channel);
> > +			return -ENOSPC;
> 
> Why -ENOSPC here?
> 
> AFAIU negative source_pad here means driver internal error (frame desc
> returned from rcsi2_get_remote_frame_desc() is invalid).  Then I think
> error return should be -EIO.

Wops, I agree with you this should not be -ENOSPC. Looking at the code 
this seems I just reused the same error code as if there is no space in 
the routes array check above this chunk, my bad. I will fix this for the 
next version.

-- 
Regards,
Niklas Söderlund
