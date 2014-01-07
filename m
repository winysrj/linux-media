Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50384 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbaAGIQY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jan 2014 03:16:24 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1W0Rpl-0004FJ-El
	for linux-media@vger.kernel.org; Tue, 07 Jan 2014 09:16:21 +0100
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 07 Jan 2014 09:16:21 +0100
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 07 Jan 2014 09:16:21 +0100
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: Re: Add private controls to =?utf-8?b?Y3RybF9oYW5kbGVy?=
Date: Tue, 7 Jan 2014 08:15:58 +0000 (UTC)
Message-ID: <loom.20140107T091511-641@post.gmane.org>
References: <loom.20140106T152825-137@post.gmane.org> <52CAC006.7080907@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil <at> xs4all.nl> writes:

> 
> Don't use V4L2_CID_PRIVATE_BASE, that doesn't work with the control framework
> (for good but somewhat obscure reasons).
> 
> Instead use (V4L2_CID_USER_BASE | 0x1000) as the base for your private
controls.
> If you want to upstream the code, then you should define a range for the
private
> controls of this driver in v4l2-controls.h. Search for e.g.
V4L2_CID_USER_S2255_BASE
> in that header to see how it is done.
> 
> Regards,
> 
> 	Hans
> 

thanks for your help. It worked for me with "(V4L2_CID_USER_BASE | 0x1000)"
base and the "v4l2_ctrl_new_custom" function.

Regards, Tom

