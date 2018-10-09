Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45487 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbeJIIYP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 04:24:15 -0400
Subject: Re: [PATCH v4 11/11] media: imx.rst: Update doc to reflect fixes to
 interlaced capture
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20181004185401.15751-1-slongerbeam@gmail.com>
 <20181004185401.15751-12-slongerbeam@gmail.com>
 <1538736767.3545.20.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <539cd27c-5c7c-7ea9-af1b-143ac97f9a15@gmail.com>
Date: Mon, 8 Oct 2018 18:09:47 -0700
MIME-Version: 1.0
In-Reply-To: <1538736767.3545.20.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/05/2018 03:52 AM, Philipp Zabel wrote:
> Hi Steve,
>
> On Thu, 2018-10-04 at 11:54 -0700, Steve Longerbeam wrote:
> <snip>
>> +or bottom-top or alternate, and the capture interface field type is set
>> +to interlaced (t-b, b-t, or unqualified interlaced). The capture interface
>> +will enforce the same field order if the source pad field type is seq-bt
>> +or seq-tb. However if the source pad's field type is alternate, any
>> +interlaced type at the capture interface will be accepted.
> This part is fine, though, as are the following changes. I'd just like
> to avoid giving the wrong impression that the CSI does line interweaving
> or pixel reordering into the output pixel format.

Agreed, I made the wording more clear.

Steve
