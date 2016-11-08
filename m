Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36802
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752944AbcKHRAe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2016 12:00:34 -0500
Date: Tue, 8 Nov 2016 15:00:27 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC v4 01/21] Revert "[media] media: fix media devnode
 ioctl/syscall and unregister race"
Message-ID: <20161108150027.26833577@vento.lan>
In-Reply-To: <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
        <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue,  8 Nov 2016 15:55:10 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> This reverts commit 6f0dd24a084a ("[media] media: fix media devnode
> ioctl/syscall and unregister race"). The commit was part of an original
> patchset to avoid crashes when an unregistering device is in use.

As I said before: I will only look on such patch series if you don't
randomly revert patches that aren't broken.

Also, if this series require changes on drivers, it is up to you
to do such changes in a way that won't break patch bisectability,
so, each change should be self-contained and touch all drivers that
are affected by the kAPI change.

Thanks,
Mauro
