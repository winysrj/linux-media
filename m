Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:24455 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab2EHXqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 19:46:43 -0400
Date: Tue, 8 May 2012 16:46:41 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sergio Aguirre <saaguirre@ti.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 08/10] arm: omap4panda: Add support for omap4iss
 camera
Message-ID: <20120508234641.GV5088@atomide.com>
References: <1335971749-21258-1-git-send-email-saaguirre@ti.com>
 <1335971749-21258-9-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335971749-21258-9-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Sergio Aguirre <saaguirre@ti.com> [120502 08:21]:
> This adds support for camera interface with the support for
> following sensors:
> 
> - OV5640
> - OV5650

It seems that at this point we should initialize new things like this
with DT only. We don't quite yet have the muxing in place, but I'd
rather not add yet another big platform_data file for something that
does not even need to be there for DT booted devices.

Regards,

Tony
