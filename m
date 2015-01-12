Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:35925 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971AbbALLmU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 06:42:20 -0500
Message-ID: <54B3B30A.3080908@xs4all.nl>
Date: Mon, 12 Jan 2015 12:42:02 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: dri-devel@lists.freedesktop.org, marbugge@cisco.com,
	Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCHv3 0/3] hdmi: add unpack and logging functions
References: <1418991263-17934-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418991263-17934-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

On 12/19/2014 01:14 PM, Hans Verkuil wrote:
> This patch series adds new HDMI 2.0/CEA-861-F defines to hdmi.h and
> adds unpacking and logging functions to hdmi.c. It also uses those
> in the V4L2 adv7842 driver (and they will be used in other HDMI drivers
> once this functionality is merged).
> 
> Changes since v2:
> - Applied most comments from Thierry's review
> - Renamed HDMI_AUDIO_CODING_TYPE_EXT_STREAM as per Thierry's suggestion.
> 
> Thierry, if this OK, then please give your Ack and I'll post a pull
> request for 3.20 for the media git tree.

Can you Ack this patch series?

Thanks!

	Hans

> 
> Regards,
> 
> 	Hans
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

