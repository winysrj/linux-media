Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:63778 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab1CYPTN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 11:19:13 -0400
Received: from maxwell.research.nokia.com (maxwell.research.nokia.com [172.21.50.162])
	by mgw-sa02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id p2PFJBtB030756
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 25 Mar 2011 17:19:12 +0200
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by maxwell.research.nokia.com (Postfix) with ESMTP id B489537FCDA
	for <linux-media@vger.kernel.org>; Fri, 25 Mar 2011 17:19:11 +0200 (EET)
Message-ID: <4D8CB26F.1040201@nokia.com>
Date: Fri, 25 Mar 2011 17:19:11 +0200
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] omap iommu: Check existence of arch_iommu
References: <4D8CB106.7030608@maxwell.research.nokia.com> <1301066005-7882-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1301066005-7882-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sakari Ailus wrote:
> Check that the arch_iommu has been installed before trying to use it. This
> will lead to kernel oops if the arch_iommu isn't there.

This was intended to go to linux-omap. Sorry for the noise.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
