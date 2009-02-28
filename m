Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3779 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZB1XBb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Feb 2009 18:01:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "William M. Brack" <wbrack@mmm.com.hk>
Subject: Re: Recommendation for good example i2c driver code
Date: Sun, 1 Mar 2009 00:01:11 +0100
Cc: "Linux Media" <linux-media@vger.kernel.org>
References: <be2acbfe1fc9d8501a1ec47397077168.squirrel@delightful.com.hk>
In-Reply-To: <be2acbfe1fc9d8501a1ec47397077168.squirrel@delightful.com.hk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903010001.12081.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 28 February 2009 23:18:54 William M. Brack wrote:
> When writing a new driver, which existing driver would be a good model
> to use for handing the i2c bus?

Hi Bill,

I recommend reading Documents/video4linux/v4l2-framework.txt. It's not clear 
from your question whether you want an example driver for an i2c device, or 
an example for how to use i2c devices in an PCI or USB driver.

A simple, but decent example source for the first would be wm8739.c and for 
the second we have saa7134 or cx18.

It's a bit in flux at the moment since we are moving all drivers over to the 
v4l2_device/v4l2_subdev structure, but some still use the old model.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
