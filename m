Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43134 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753722AbaEHJFV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 8 May 2014 05:05:21 -0400
Date: Thu, 8 May 2014 12:04:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Antti Palosaari <crope@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: V4L control units
Message-ID: <20140508090446.GG8753@valkosipuli.retiisi.org.uk>
References: <536A2DA7.7050803@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536A2DA7.7050803@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Heippa!

On Wed, May 07, 2014 at 03:57:11PM +0300, Antti Palosaari wrote:
> What is preferred way implement controls that could have some known
> unit or unknown unit? For example for gain controls, I would like to
> offer gain in unit of dB (decibel) and also some unknown driver
> specific unit. Should I two controls, one for each unit?
> 
> Like that
> 
> V4L2_CID_RF_TUNER_LNA_GAIN_AUTO
> V4L2_CID_RF_TUNER_LNA_GAIN
> V4L2_CID_RF_TUNER_LNA_GAIN_dB

I suppose that on any single device there would be a single unit to control
a given... control. Some existing controls do document the unit as well but
I don't think that's scalable nor preferrable. This way we'd have many
different controls to control the same thing but just using a different
unit. The auto control is naturally different. Hans did have a patch to add
the unit to queryctrl (in the form of QUERY_EXT_CTRL).

<URL:http://www.spinics.net/lists/linux-media/msg73136.html>

I wish we can get these in relatively soon.

-- 
Terveisin,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
