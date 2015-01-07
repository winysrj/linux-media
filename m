Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39694 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbbAGXPb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 18:15:31 -0500
Message-ID: <54ADBE0E.5030205@collabora.com>
Date: Wed, 07 Jan 2015 18:15:26 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Kamil Debski <k.debski@samsung.com>,
	Arun Kumar K <arun.kk@samsung.com>
Subject: Re: [PATCH 0/3] Various fixes for s5p-mfc driver
References: <1418677859-31440-1-git-send-email-nicolas.dufresne@collabora.com>
In-Reply-To: <1418677859-31440-1-git-send-email-nicolas.dufresne@collabora.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just a friendly reminder that this patch is pending review ;-P

cheers,
Nicolas

Le 2014-12-15 16:10, Nicolas Dufresne a écrit :
> This patchset fixes ability to drain the decoder due to use of wrong
> enumeration name and fixes implementation of display delay controls
> for MFC firmware v6 and higher.
>
> Note that there is no need in the display delay fix for trying to be
> backward compatible with what the comment was saying since the control
> properties was preventing it. There was basically no way other then
> setting a large delay value to get the frames in display order.
>
> Nicolas Dufresne (3):
>    s5p-mfc-v6+: Use display_delay_enable CID
>    s5p-mfc-dec: Don't use encoder stop command
>    media-doc: Fix MFC display delay control doc
>
>   Documentation/DocBook/media/v4l/controls.xml    | 11 +++++------
>   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |  2 +-
>   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  6 +-----
>   3 files changed, 7 insertions(+), 12 deletions(-)
>

