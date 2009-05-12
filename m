Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:23978 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbZELEvV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 00:51:21 -0400
Subject: Re: [PATCH v2 1/7] v4l2: video device: Add V4L2_CTRL_CLASS_FMTX
 controls
From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Reply-To: ext-eero.nurkkala@nokia.com
To: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <1242034309-13448-2-git-send-email-eduardo.valentin@nokia.com>
References: <1242034309-13448-1-git-send-email-eduardo.valentin@nokia.com>
	 <1242034309-13448-2-git-send-email-eduardo.valentin@nokia.com>
Content-Type: text/plain
Date: Tue, 12 May 2009 07:49:25 +0300
Message-Id: <1242103765.19944.41.camel@eenurkka-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-05-11 at 11:31 +0200, Valentin Eduardo (Nokia-D/Helsinki) wrote:
> +enum v4l2_fmtx_preemphasis {
> +	V4L2_FMTX_PREEMPHASIS_75_uS		= 0,
> +	V4L2_FMTX_PREEMPHASIS_50_uS		= 1,
> +	V4L2_FMTX_PREEMPHASIS_DISABLED		= 2,
> +};

Hello there,

Would it make more sense to make:
"V4L2_FMTX_PREEMPHASIS_DISABLED" as "zero" (false). In my opinion,
that would be more clear.

- Eero

