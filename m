Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3770 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaEIM5j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 08:57:39 -0400
Message-ID: <536CD0A9.4020904@xs4all.nl>
Date: Fri, 09 May 2014 14:57:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, Antti Palosaari <crope@iki.fi>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: V4L control units
References: <536A2DA7.7050803@iki.fi> <20140508090446.GG8753@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140508090446.GG8753@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/08/2014 11:04 AM, Sakari Ailus wrote:
> Heippa!
> 
> On Wed, May 07, 2014 at 03:57:11PM +0300, Antti Palosaari wrote:
>> What is preferred way implement controls that could have some known
>> unit or unknown unit? For example for gain controls, I would like to
>> offer gain in unit of dB (decibel) and also some unknown driver
>> specific unit. Should I two controls, one for each unit?
>>
>> Like that
>>
>> V4L2_CID_RF_TUNER_LNA_GAIN_AUTO
>> V4L2_CID_RF_TUNER_LNA_GAIN
>> V4L2_CID_RF_TUNER_LNA_GAIN_dB
> 
> I suppose that on any single device there would be a single unit to control
> a given... control. Some existing controls do document the unit as well but
> I don't think that's scalable nor preferrable. This way we'd have many
> different controls to control the same thing but just using a different
> unit. The auto control is naturally different. Hans did have a patch to add
> the unit to queryctrl (in the form of QUERY_EXT_CTRL).

Well, that's going to be dropped again. There were too many comments about
that during the mini-summit and it was not critical for me.

> 
> <URL:http://www.spinics.net/lists/linux-media/msg73136.html>
> 
> I wish we can get these in relatively soon.

Sakari, I think you will have to push this if you want this done.

One interesting thing to look at: the AVB IEEE 1722.1 standard has extensive
support for all sorts of units. I don't know if you have access to the standard
document, but it might be interesting to look at what they do there.

Regards,

	Hans
