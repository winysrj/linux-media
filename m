Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36929 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbaDQNl1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 09:41:27 -0400
Message-id: <534FDA03.20901@samsung.com>
Date: Thu, 17 Apr 2014 15:41:23 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v2 46/48] adv7604: Add DT support
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <534FB40A.20506@samsung.com> <1810096.BfEfAl25kc@avalon>
 <2010144.jYKNNgF1x7@avalon>
In-reply-to: <2010144.jYKNNgF1x7@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/04/14 15:08, Laurent Pinchart wrote:
>>>>  static struct i2c_driver adv7604_driver = {
>>>> > > >  
>>>> > > >  	.driver = {
>>>> > > >  	
>>>> > > >  		.owner = THIS_MODULE,
>>>> > > >  		.name = "adv7604",
>>>> > > > 
>>>> > > > +		.of_match_table = of_match_ptr(adv7604_of_id),
>>> > > 
>>> > > of_match_ptr() isn't necessary here.
>> > 
>> > Thanks, will fix in v3.
>
> On second thought, as the driver has non-DT users, keeping of_match_ptr() and 
> marking the table as __maybe_unused will optimize the table out if neither 
> CONFIG_OF nor CONFIG_MODULE is set. I'd thus prefer keeping of_match_ptr().

Yes, itsounds like a good idea to me. This way we avoid unpleasant #ifdefs
and do not increase size of the module for non-dt users.

--
Regards,
Sylwester
