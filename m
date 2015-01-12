Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:60532 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbbALLp4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 06:45:56 -0500
Message-ID: <54B3B3E4.20900@xs4all.nl>
Date: Mon, 12 Jan 2015 12:45:40 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, Hans Verkuil <hansverk@cisco.com>
Subject: Re: [RFC 1/6] cec: add new driver for cec support.
References: <1419345142-3364-1-git-send-email-k.debski@samsung.com> <1419345142-3364-2-git-send-email-k.debski@samsung.com>
In-Reply-To: <1419345142-3364-2-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/23/2014 03:32 PM, Kamil Debski wrote:
> From: Hans Verkuil <hansverk@cisco.com>
> 
> Add the CEC framework.
> 
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> [k.debski@samsung.com: Merged CEC Updates commit by Hans Verkuil]
> [k.debski@samsung.com: Merged Update author commit by Hans Verkuil]
> [k.debski@samsung.com: change kthread handling when setting logical
> address]
> [k.debski@samsung.com: code cleanup]
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  cec-rfc.txt              |  319 ++++++++++++++
>  cec.txt                  |   40 ++

A note regarding these text files: cec-rfc.txt should go to Documentation/cec.txt.
I'm not sure if it is up to date (Kamil, did you check?).

The cec.txt file is basically a bunch of notes to myself when I was working
on this. It contains some of the not-so-obvious CEC protocol specifications.

It should either be deleted for the final version of this patch series, or
it should be merged with cec-rfc.txt.

Regards,

	Hans

