Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:38734 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750755AbdFFHoQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Jun 2017 03:44:16 -0400
Subject: Re: Question about Large Custom Coefficients for V4L2 sub-device
 drivers
To: Rohit Athavale <rohit.athavale@xilinx.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <866603A3C4C8F547969034C425C3995F494A3336@XSJ-PSEXMBX01.xlnx.xilinx.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <15c9f603-1fa9-da67-7779-ba8dfaf03822@xs4all.nl>
Date: Tue, 6 Jun 2017 09:44:13 +0200
MIME-Version: 1.0
In-Reply-To: <866603A3C4C8F547969034C425C3995F494A3336@XSJ-PSEXMBX01.xlnx.xilinx.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/06/17 18:32, Rohit Athavale wrote:
> Hello Media Community,
> 
> I am working on a scaler and gamma correction V4L2 sub-device based drivers. A common theme to both of them is that
> the kernel driver is expected bring-up these devices in a working (good) configuration. As it turns out these coefficients are tailor-made
> or are fairly complex to generate dynamically at run-time.
> 
> This implies the driver has to store at least one set of coefficients for each supported configuration. This could easily become 10-20 KB of data stored as a large static array of shorts or integers.
> 
> I have a couple of questions to ask all here :
> 
> 1. What is the best practice for embedding large coefficients ( > 10 KB) into V4L2 sub-device based drivers ?

Typically it is just a static const array. For large arrays it is best to put them in a separate
source so it doesn't overwhelm the actual driver code.

> 2. How can user applications feed coefficients to the sub-device based V4L2 drivers ? I'm wondering if there is standard ioctl, write or mmap file op that can be performed to achieve this ?

In most cases you can make an extended control (array or compound) for this. If the hardware
supports some sort of DMA hardware to load the coefficients quickly into memory, then a video
node can be created. But based on what you write that doesn't appear to be necessary.

Regards,

	Hans

> 
> All inputs will be greatly appreciated :)
> 
> Best Regards,
> Rohit
> 
> 
> 
> This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
> 
