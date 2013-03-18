Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1066 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3CROYY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 10:24:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 0/6] s5p-tv: replace dv_preset by dv_timings
Date: Mon, 18 Mar 2013 15:24:12 +0100
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1362402126-13149-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1362402126-13149-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303181524.12891.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon March 4 2013 14:02:00 Hans Verkuil wrote:
> Hi Tomasz,
> 
> Here is what I hope is the final patch series for this. I've incorporated
> your suggestions and it's split off from the davinci/blackfin changes into
> its own patch series to keep things better organized.
> 
> The changes since the previous version are:
> 
> - changed the order of the first three patches as per your suggestion.
> - the patch named "[RFC PATCH 08/18] s5p-tv: add dv_timings support for
>   mixer_video." had two changes that rightfully belonged to the 'add
>   dv_timings support for mixer_video.' patch. Moved them accordingly.
> - hdmiphy now also supports dv_timings_cap and sets the pixelclock range
>   accordingly. The hdmi driver chains hdmiphy to get those values.
> - updating the minimum width to 720.
> 
> I didn't add a comment to clarify the pixclk handling hdmiphy_s_dv_preset
> because 1) I forgot, 2) it's not a bug, and 3) that whole function is
> removed anyway a few patches later :-)
> 
> The only functional change is the handling of dv_timings_cap. Can you
> verify that that works as it should?

Tomasz,

Should I wait for feedback from you, or can I go ahead and make a pull
request for this?

Regards,

	Hans
