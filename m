Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37570 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751619AbdFHHe5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 03:34:57 -0400
Subject: Re: [PATCH 8/8] omapdrm: hdmi4: hook up the HDMI CEC support
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-media@vger.kernel.org
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-9-hverkuil@xs4all.nl>
 <144b95df-8eb2-1307-1157-2eb2572c51aa@xs4all.nl>
 <7d3ab159-9284-bcc8-80f0-cbc621769203@ti.com>
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <50af289e-2601-2d57-71ce-1d0a205277cb@xs4all.nl>
Date: Thu, 8 Jun 2017 09:34:54 +0200
MIME-Version: 1.0
In-Reply-To: <7d3ab159-9284-bcc8-80f0-cbc621769203@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

On 08/05/17 12:26, Tomi Valkeinen wrote:
> On 06/05/17 14:58, Hans Verkuil wrote:
> 
>> My assumption was that hdmi_display_disable() was called when the hotplug would go
>> away. But I discovered that that isn't the case, or at least not when X is running.
>> It seems that the actual HPD check is done in hdmic_detect() in
>> omapdrm/displays/connector-hdmi.c.
> 
> For some HW it's done there (in the case there's no IP handling the
> HPD), but in some cases it's done in tpd12s015 driver (e.g. pandaboard),
> and in some cases it also could be done in the hdmi driver (if the HPD
> is handled by the HDMI IP, but at the moment we don't have this case
> supported in the SW).
> 
>> But there I have no access to hdmi.core (needed for the hdmi4_cec_set_phys_addr() call).
>>
>> Any idea how to solve this? I am not all that familiar with drm, let alone omapdrm,
>> so if you can point me in the right direction, then that would be very helpful.
> 
> Hmm, indeed, looks the the output is kept enabled even if HPD drops and
> the connector status is changed to disconnected.
> 
> I don't have a very good solution... I think we have to add a function
> to omapdss_hdmi_ops, which the connector-hdmi and tpd12s015 drivers can
> call when they detect a HPD change. That call would go to the HDMI IP
> driver.
> 
> Peter is about to send hotplug-interrupt-handling series, I think the
> HPD function work should be done on top of that, as otherwise it'll just
> conflict horribly.

Has that been merged yet? And if so, what git repo/branch should I base
my next version of this patch series on? If not, do you know when it is
expected?

Regards,

	Hans
