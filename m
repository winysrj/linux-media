Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback-out2.mxes.net ([216.86.168.191]:20404 "EHLO
	fallback-in2.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754027Ab3CLOsg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 10:48:36 -0400
Received: from mxout-08.mxes.net (mxout-08.mxes.net [216.86.168.183])
	by fallback-in1.mxes.net (Postfix) with ESMTP id EA8642FDBF2
	for <linux-media@vger.kernel.org>; Tue, 12 Mar 2013 10:38:34 -0400 (EDT)
Message-ID: <42459.207.87.255.226.1363099023.squirrel@webmail.tuffmail.net>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
Date: Tue, 12 Mar 2013 10:37:03 -0400 (EDT)
Subject: Re: [REVIEW PATCH 00/42] go7007: complete overhaul
From: "Darrick Burch" <darrick@tuffmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> This week I'll also receive a Plextor PX-M402U to test with and an ADS DVD
> XPress DX2 is also on its way (I did some ebay shopping!).

As it happens I've been working with the DVD Xpress DX2.  I found a patch
floating around the Internet, with the needed code to add support for it,
but I was chagrined to discover (on 3.6.28) that v4l2 subdevice support
was simply not implemented correctly and I couldn't get very far with it.

I have cloned your go7007 branch and I am in the process of trying to
apply the changes again.  My only question about this device is that it
uses a tw9906 and not a tw9903 (for which there is already an i2c module).
 Do you know much about either decoder?  The tw9906 code in the patch
looked very similar to what was in the tw9903 save for a few initial
register differences.

