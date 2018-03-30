Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:36206 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750725AbeC3GnH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Mar 2018 02:43:07 -0400
Subject: Re: V4l2 Sensor driver and V4l2 ctrls
To: asadpt iqroot <asadptiqroot@gmail.com>, linux-media@vger.kernel.org
References: <CA+gCWtL1HiZjNaZ87RRET+tHrdzSaqor=-vQUssnaGN+6iFOdg@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2c04f13c-48dc-a745-02fc-7bd8cd57e568@xs4all.nl>
Date: Fri, 30 Mar 2018 08:43:05 +0200
MIME-Version: 1.0
In-Reply-To: <CA+gCWtL1HiZjNaZ87RRET+tHrdzSaqor=-vQUssnaGN+6iFOdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30/03/18 08:16, asadpt iqroot wrote:
> Hi All,
> 
> In reference sensor drivers, they used the
> V4L2_CID_DV_RX_POWER_PRESENT v4l2 ctrl.
> It is a standard ctrl and created using v4l2_ctrl_new_std().
> 
> The doubts are:
> 
> 1. Whether in our sensor driver, we need to create this Control Id or
> not. How to take the decision on this. Since this is the standard
> ctrl. When we need to use these standard ctrls??

No. This control is for HDMI receivers, not for sensors.

Regards,

	Hans

> 
> 2. In Sensor driver, the ctrls creation is anything depends on the
> bridge driver.
> Based on bridge driver, whether we need to create any ctrls in Sensor driver.
> 
> This question belongs to design of the sensor driver.
> 
> 
> 
> Thanks & Regards
> 
