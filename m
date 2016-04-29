Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33808 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbcD2WsD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 18:48:03 -0400
Subject: Re: camera application for testing (was Re: v4l subdevs without big
 device)
To: =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
	Pavel Machek <pavel@ucw.cz>
References: <20160428084546.GA9957@amd> <57230DE7.3020701@xs4all.nl>
 <20160429221359.GA29297@amd> <201604300020.58559@pali>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	sakari.ailus@iki.fi, tuukkat76@gmail.com, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <5723E49D.1030104@gmail.com>
Date: Sat, 30 Apr 2016 01:47:57 +0300
MIME-Version: 1.0
In-Reply-To: <201604300020.58559@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 30.04.2016 01:20, Pali Rohár wrote:
> On Saturday 30 April 2016 00:13:59 Pavel Machek wrote:
>> Any other application I should look at? Thanks,
>
> Maybe camera-ui, which is part of CSSU?
>
> https://github.com/community-ssu/camera-ui
>

This is based on gdigicam, are you sure it is compatible with recent 
kernel/userspace? Also, iirc gdigicam needs omap3camd working, but we 
still don't have the needed compat layer.

Ivo
