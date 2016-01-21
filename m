Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:36806 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093AbcAUKWt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2016 05:22:49 -0500
Date: Thu, 21 Jan 2016 11:22:46 +0100
From: Michal Hocko <mhocko@kernel.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] zoran: do not use kmalloc for memory mapped to
 userspace
Message-ID: <20160121102246.GE29520@dhcp22.suse.cz>
References: <1453364958-29983-1-git-send-email-mhocko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1453364958-29983-1-git-send-email-mhocko@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 21-01-16 09:29:18, Michal Hocko wrote:
> Hi,
> I am sending this offlist for the review because this has security

Ups, forgot to update this. This went offlist before but Hans has noted
that it can go public because the number of users of this old HW is so
limitted that any potential security concerns are basically moot.
-- 
Michal Hocko
SUSE Labs
