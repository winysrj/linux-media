Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:60472 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbZFQPCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 11:02:04 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Wed, 17 Jun 2009 10:02:01 -0500
Subject: RE: [PATCH 1/10 - v2] vpfe capture bridge driver for DM355 and
 DM6446
Message-ID: <A69FA2915331DC488A831521EAE36FE40139DF9C0B@dlee06.ent.ti.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com>
 <200906160029.01328.hverkuil@xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE40139DF96ED@dlee06.ent.ti.com>
 <200906170839.06421.hverkuil@xs4all.nl>
In-Reply-To: <200906170839.06421.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>
>> <snip>
>
>Can you post your latest proposal for the s_bus op?
>
>I propose a few changes: the name of the struct should be something like
>v4l2_bus_settings, the master/slave bit should be renamed to something
>like 'host_is_master', and we should have two widths: subdev_width and
>host_width.
>
>That way the same structure can be used for both host and subdev, unless
>some of the polarities are inverted. In that case you need to make two
>structs, one for host and one for the subdev.
>
>It is possible to add info on inverters to the struct, but unless inverters
>are used a lot more frequently than I expect I am inclined not to do that
>at this time.
>
[MK]Today I am planning to send my v3 version of the vpfe capture patch and also tvp514x patch since Vaibhav is pre-occupied with some other activities. I have discussed the changes with Vaibhav for this driver.

For s_bus, I will try if I can send a patch today. BTW, do you expect me to add one bool for active high, one for active low etc as done in SoC camera ?

Murali 
