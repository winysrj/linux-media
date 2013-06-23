Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:45214 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3FWUuu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jun 2013 16:50:50 -0400
Received: by mail-bk0-f44.google.com with SMTP id r7so4002335bkg.31
        for <linux-media@vger.kernel.org>; Sun, 23 Jun 2013 13:50:48 -0700 (PDT)
Message-ID: <51C75FA4.2010303@gmail.com>
Date: Sun, 23 Jun 2013 22:50:44 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, k.debski@samsung.com,
	jtp.park@samsung.com, s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: Re: [PATCH v2 6/8] [media] V4L: Add support for integer menu controls
 with standard menu items
References: <1371560183-23244-1-git-send-email-arun.kk@samsung.com> <1371560183-23244-7-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1371560183-23244-7-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 06/18/2013 02:56 PM, Arun Kumar K wrote:
> @@ -806,6 +820,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>   	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
>   	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
>   	case V4L2_CID_RDS_RECEPTION:		return "RDS Reception";
> +
>   	default:
>   		return NULL;
>   	}

This change would need to be moved to patch 7/8.

Thanks,
Sylwester
