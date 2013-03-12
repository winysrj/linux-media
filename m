Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:47621 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab3CLPGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 11:06:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Darrick Burch" <darrick@tuffmail.com>
Subject: Re: [REVIEW PATCH 00/42] go7007: complete overhaul
Date: Tue, 12 Mar 2013 16:05:36 +0100
Cc: linux-media@vger.kernel.org
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl> <42459.207.87.255.226.1363099023.squirrel@webmail.tuffmail.net>
In-Reply-To: <42459.207.87.255.226.1363099023.squirrel@webmail.tuffmail.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303121605.36107.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 12 March 2013 15:37:03 Darrick Burch wrote:
> > This week I'll also receive a Plextor PX-M402U to test with and an ADS DVD
> > XPress DX2 is also on its way (I did some ebay shopping!).
> 
> As it happens I've been working with the DVD Xpress DX2.  I found a patch
> floating around the Internet, with the needed code to add support for it,
> but I was chagrined to discover (on 3.6.28) that v4l2 subdevice support
> was simply not implemented correctly and I couldn't get very far with it.
> 
> I have cloned your go7007 branch and I am in the process of trying to
> apply the changes again.  My only question about this device is that it
> uses a tw9906 and not a tw9903 (for which there is already an i2c module).
>  Do you know much about either decoder?  The tw9906 code in the patch
> looked very similar to what was in the tw9903 save for a few initial
> register differences.

I know little about those devices. But I did find datasheets for both with
some creative googling. I'll mail them to you.

Looking at the datasheets it seems to me that there are too many differences.
Especially if the drivers are going to be extended with additional features.
I would go with separate drivers for now.

Regards,

	Hans
