Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39008 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751668AbdJYVZM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Oct 2017 17:25:12 -0400
Subject: Re: [PATCH 0/2] Fix s5p-mfc lock contention in request firmware paths
To: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
References: <cover.1507325072.git.shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <354e3c31-e502-5ba6-d705-9d67764e78bf@osg.samsung.com>
Date: Wed, 25 Oct 2017 15:24:57 -0600
MIME-Version: 1.0
In-Reply-To: <cover.1507325072.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/06/2017 03:30 PM, Shuah Khan wrote:
> This patch series fixes inefficiencies and lock contention in the request
> firmware paths.
> 
> Shuah Khan (2):
>   media: s5p-mfc: check for firmware allocation before requesting
>     firmware
>   media: s5p-mfc: fix lock confection - request_firmware() once and keep
>     state
> 
>  drivers/media/platform/s5p-mfc/s5p_mfc.c        |  4 ++++
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  3 +++
>  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   | 15 ++++++++++-----
>  3 files changed, 17 insertions(+), 5 deletions(-)
> 

Any feedback on this series?

thanks,
-- Shuah
