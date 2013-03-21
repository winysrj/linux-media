Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:5538 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab3CUKTX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 06:19:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: em28xx: commit aab3125c43d8fecc7134e5f1e729fabf4dd196da broke HVR 900
Date: Thu, 21 Mar 2013 11:19:21 +0100
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201303210933.41537.hverkuil@xs4all.nl> <20130321070327.772c6301@redhat.com>
In-Reply-To: <20130321070327.772c6301@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303211119.21485.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 21 March 2013 11:03:27 Mauro Carvalho Chehab wrote:
> Em Thu, 21 Mar 2013 09:33:41 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > I tried to use my HVR 900 stick today and discovered that it no longer worked.
> > I traced it to commit aab3125c43d8fecc7134e5f1e729fabf4dd196da: "em28xx: add
> > support for registering multiple i2c buses".
> > 
> > The kernel messages for when it fails are:
> ...
> > Mar 21 09:26:57 telek kernel: [ 1396.542517] xc2028 12-0061: attaching existing instance
> > Mar 21 09:26:57 telek kernel: [ 1396.542521] xc2028 12-0061: type set to XCeive xc2028/xc3028 tuner
> > Mar 21 09:26:57 telek kernel: [ 1396.542523] em2882/3 #0: em2882/3 #0/2: xc3028 attached
> ...
> > Mar 21 09:26:57 telek kernel: [ 1396.547833] xc2028 12-0061: Error on line 1293: -19
> 
> Probably, the I2C speed is wrong. I noticed a small bug on this patch.
> The following patch should fix it. Could you please test?
> 
> 

I'll try to test this later today, otherwise it will be tomorrow.

Regards,

	Hans
