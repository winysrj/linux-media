Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:50489 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751946Ab1KIMes (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Nov 2011 07:34:48 -0500
Subject: Re: Daily build update
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Wed, 09 Nov 2011 07:37:02 -0500
In-Reply-To: <201111081132.23365.hverkuil@xs4all.nl>
References: <201111081132.23365.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1320842223.2271.2.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-11-08 at 11:32 +0100, Hans Verkuil wrote:
> Hi all,
> 
> I've managed to get the daily build working again with the for_v3.3 branch and
> with the full range of kernels from 2.6.31 to 3.2-rc1.

Thank you!  

(The personal time devoted to clean-up should never be thankless.)

Regards,
Andy

> There is one error remaining with the compilation of cpia2_usb.c on 3.2-rc1
> (a missing module.h header). This should be resolved once the for_v3.3 branch
> is synced with the 3.2-rc1 mainline branch. So I am not going to workaround
> that error.
> 
> I'm sure it will break again after the next round of commits, though :-)
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


