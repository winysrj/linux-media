Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4226 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbZFQTFq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 15:05:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH 1/10 - v2] vpfe capture bridge driver for DM355 and DM6446
Date: Wed, 17 Jun 2009 21:05:44 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com> <200906170839.06421.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE40139DF9C0B@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40139DF9C0B@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906172105.45040.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 17 June 2009 17:02:01 Karicheri, Muralidharan wrote:
> >> <snip>
> >
> >Can you post your latest proposal for the s_bus op?
> >
> >I propose a few changes: the name of the struct should be something like
> >v4l2_bus_settings, the master/slave bit should be renamed to something
> >like 'host_is_master', and we should have two widths: subdev_width and
> >host_width.
> >
> >That way the same structure can be used for both host and subdev, unless
> >some of the polarities are inverted. In that case you need to make two
> >structs, one for host and one for the subdev.
> >
> >It is possible to add info on inverters to the struct, but unless
> > inverters are used a lot more frequently than I expect I am inclined
> > not to do that at this time.
>
> [MK]Today I am planning to send my v3 version of the vpfe capture patch
> and also tvp514x patch since Vaibhav is pre-occupied with some other
> activities. I have discussed the changes with Vaibhav for this driver.
>
> For s_bus, I will try if I can send a patch today. BTW, do you expect me
> to add one bool for active high, one for active low etc as done in SoC
> camera ?

Since I remain opposed to autonegotiation, there is IMO no need for this.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
