Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:53533 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619AbbD0Lp1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 07:45:27 -0400
Message-ID: <553E2150.8060304@xs4all.nl>
Date: Mon, 27 Apr 2015 13:45:20 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH v4 06/10] cec: add HDMI CEC framework
References: <1429794192-20541-1-git-send-email-k.debski@samsung.com> <1429794192-20541-7-git-send-email-k.debski@samsung.com> <553DFFCF.5070608@xs4all.nl>
In-Reply-To: <553DFFCF.5070608@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/27/2015 11:22 AM, Hans Verkuil wrote:
> Hi Kamil,
> 
> Sorry for all the replies, but I'm writing the DocBook documentation, so
> whenever I find something missing I'll just reply to this patch.
>> +/* The CEC version */
> 
> Add support for version 1.3a here:
> 
> #define CEC_VERSION_1_3A		4
> 
>> +#define CEC_VERSION_1_4B		5

Hmm, reading up on this I see that '5' is used for HDMI 1.4, 1.4a or 1.4b.

I think it should be renamed to VERSION_1_4 (i.e. drop the 'B').

Regards,

	Hans

>> +#define CEC_VERSION_2_0			6
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

