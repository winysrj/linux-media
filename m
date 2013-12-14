Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpdg1.aruba.it ([62.149.158.231]:38597 "EHLO smtpdg3.aruba.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753480Ab3LNRVm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 12:21:42 -0500
From: Luca Risolia <luca.risolia@linux-projects.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Reply-To: luca.risolia@linux-projects.org
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 1/2] sn9c102: prepare for removal by moving it to staging.
Date: Sat, 14 Dec 2013 18:13:45 +0100
Message-ID: <1628977.YDkQVgTYrx@laptop>
In-Reply-To: <1386850822-3487-2-git-send-email-hverkuil@xs4all.nl>
References: <1386850822-3487-1-git-send-email-hverkuil@xs4all.nl> <1386850822-3487-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> During the last media summit meeting it was decided to move this driver to
> staging as the first step to removing it altogether.
> 
> Most webcams covered by this driver are now supported by gspca. Nobody has
> the hardware to convert the remaining devices to gspca.

I have all the boards given by the manufacturer. Last time I tried the gspca 
driver it certainly did not work with most of the sn9c1xx-based models the 
gspca driver claims to be supporting (which were a subset of the devices 
actually supported by sn9c102).

> This driver needs a major overhaul to have it conform to the latest
> frameworks and compliancy tests.

What is not compliant? I will offer my help to update the driver in case but 
cannot give my help to fix or test all the boards again with the gspca, as it 
would be a considerable amount of extra work.

> Without hardware, however, this is next to impossible. Given the fact that
> this driver seems to be pretty much unused (it has been removed from Fedora
> several versions ago and nobody complained about that), we decided to drop
> this driver.

As no one has the hardware, what is the reason why the sn9c102 has been moved 
into gspca, although the sn9c102 driver has been already present in the kernel 
since years before?

In my opinion the fact that the module has been removed from Fedora does not 
imply that the driver is unused. For sure that does not mean the sn9c102 
driver is unuseful, since gspca does not work properly with all the devices, 
as I mentioned.

Regards
Luca

