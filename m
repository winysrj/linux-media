Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.62]:52246 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858AbaDKJJK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 05:09:10 -0400
Message-ID: <5347B132.6040206@sca-uk.com>
Date: Fri, 11 Apr 2014 10:09:06 +0100
From: Steve Cookson - IT <it@sca-uk.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Hauppauge ImpactVCB-e 01385
References: <534675E1.6050408@sca-uk.com>
In-Reply-To: <534675E1.6050408@sca-uk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So I'm back to the Hauppauge ImpactVCB-e 01385.

Apparently it's fully supported by the current Linux kernel:

Model                 Standard Interface     Supported     Comments
ImpactVCB-e     Video PCIe                 ✔ Yes                 No 
tuners, only video-in. S-Video Capture works with kernel 3.5.0 (Ubuntu 
12.10).

http://linuxtv.org/wiki/index.php/Hauppauge.

So is this a typo or have I just encountered an install problem?

> When I plug in my 01385 I get the same old stuff in dmseg, ie:
>
> cx23885 driver version 0.0.3 loaded
> [ 8.921390] cx23885[0]: Your board isn't known (yet) to the driver.
> [ 8.921390] cx23885[0]: Try to pick one of the existing card configs via
> [ 8.921390] cx23885[0]: card=<n> insmod option. Updating to the latest
> [ 8.921390] cx23885[0]: version might help as well.
> [ 8.921393] cx23885[0]: Here is a list of valid choices for the 
> card=<n> insmod option:
>
> Etc.
Would the daily build resolve this?  I haven't installed it on this test 
system, but I'm never clear when I should install it or whether I should 
just download a single driver from somewhere.

Regards

Steve
