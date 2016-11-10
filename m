Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55018 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934560AbcKJXtn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 18:49:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        shuahkh@osg.samsung.com
Subject: Re: [RFC v4 01/21] Revert "[media] media: fix media devnode ioctl/syscall and unregister race"
Date: Fri, 11 Nov 2016 01:49:46 +0200
Message-ID: <1729934.PgkcjptSmn@avalon>
In-Reply-To: <20161108150027.26833577@vento.lan>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk> <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com> <20161108150027.26833577@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tuesday 08 Nov 2016 15:00:27 Mauro Carvalho Chehab wrote:
> Em Tue,  8 Nov 2016 15:55:10 +0200 Sakari Ailus escreveu:
> > This reverts commit 6f0dd24a084a ("[media] media: fix media devnode
> > ioctl/syscall and unregister race"). The commit was part of an original
> > patchset to avoid crashes when an unregistering device is in use.
> 
> As I said before: I will only look on such patch series if you don't
> randomly revert patches that aren't broken.

That's not always an option. What you're essentially saying is that if taking 
a step forward improves the situation, we can only improve it more by taking 
more steps forward. Sometimes the step forward leads to a dead end, making a U 
turn unavoidable to avoid running into a wall :-)

Sure, we could squash the reverts as part of a large patch to would be too big 
to review, but I hardly see that as an improvement.

This being said, I haven't checked whether it would be possible to shuffle 
patches around and revert the first three on top of the rest of the series, 
but at first glance it seems very difficult. I don't think we should use the 
fact that the three patches were merged despite known issues a strong argument 
to prevent them from being reverted. Fixes are being reverted all the time in 
the kernel when they cause more harm than good, there's nothing special here.

> Also, if this series require changes on drivers, it is up to you
> to do such changes in a way that won't break patch bisectability,
> so, each change should be self-contained and touch all drivers that
> are affected by the kAPI change.

-- 
Regards,

Laurent Pinchart

