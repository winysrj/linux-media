Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60057 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbAHQuT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jan 2015 11:50:19 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NHV00KB5AYP4J60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Jan 2015 16:54:25 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sean Young' <sean@mess.org>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, 'Hans Verkuil' <hansverk@cisco.com>
References: <1419345142-3364-1-git-send-email-k.debski@samsung.com>
 <1419345142-3364-2-git-send-email-k.debski@samsung.com>
 <20141230133249.GA1566@gofer.mess.org>
In-reply-to: <20141230133249.GA1566@gofer.mess.org>
Subject: RE: [RFC 1/6] cec: add new driver for cec support.
Date: Thu, 08 Jan 2015 17:50:15 +0100
Message-id: <00b201d02b63$2e3471d0$8a9d5570$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

> -----Original Message-----
> From: Sean Young [mailto:sean@mess.org]
> Sent: Tuesday, December 30, 2014 2:33 PM
> To: Kamil Debski
> Cc: dri-devel@lists.freedesktop.org; linux-media@vger.kernel.org;
> m.szyprowski@samsung.com; mchehab@osg.samsung.com; hverkuil@xs4all.nl;
> kyungmin.park@samsung.com; Hans Verkuil
> Subject: Re: [RFC 1/6] cec: add new driver for cec support.
> 
> On Tue, Dec 23, 2014 at 03:32:17PM +0100, Kamil Debski wrote:
> > +There are still a few todo's, the main one being the remote control
> > +support feature of CEC. I need to research if that should be
> > +implemented via the standard kernel remote control support.
> 
> I guess a new rc driver type RC_DRIVER_CEC should be introduced
> (existing types are RC_DRIVER_IR_RAW and RC_DRIVER_SCANCODE).
> rc_register_device() should not register the sysfs attributes specific
> for IR, but register sysfs attributes for cec like a link to the device.
> 
> In addition there should be a new rc_type protocol RC_TYPE_CEC; now
> rc_keydown_notimeout() can be called for each key press.
> 
> I guess a new keymap should exist too.
> 

Thank you for your suggestions. They are surely helpful and I agree with
them.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

