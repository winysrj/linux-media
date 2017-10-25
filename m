Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:53226 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751421AbdJYW2H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Oct 2017 18:28:07 -0400
MIME-Version: 1.0
In-Reply-To: <354e3c31-e502-5ba6-d705-9d67764e78bf@osg.samsung.com>
References: <cover.1507325072.git.shuahkh@osg.samsung.com> <354e3c31-e502-5ba6-d705-9d67764e78bf@osg.samsung.com>
From: Marian Mihailescu <marian.mihailescu@adelaide.edu.au>
Date: Thu, 26 Oct 2017 08:58:05 +1030
Message-ID: <CAM3PiRzS966v=pWRq641sFF-Kg5wHc6fH524CQKusURNfcD0ew@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix s5p-mfc lock contention in request firmware paths
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        Andrzej Hajda <a.hajda@samsung.com>, mchehab@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

For MFC patch, you can delete the "dev" variable since it's not being
used anymore and results in a compile warning.

- struct s5p_mfc_dev *dev = ctx->dev;

Cheers,
Marian

On Thu, Oct 26, 2017 at 7:54 AM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> On 10/06/2017 03:30 PM, Shuah Khan wrote:
>> This patch series fixes inefficiencies and lock contention in the request
>> firmware paths.
>>
>> Shuah Khan (2):
>>   media: s5p-mfc: check for firmware allocation before requesting
>>     firmware
>>   media: s5p-mfc: fix lock confection - request_firmware() once and keep
>>     state
>>
>>  drivers/media/platform/s5p-mfc/s5p_mfc.c        |  4 ++++
>>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  3 +++
>>  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   | 15 ++++++++++-----
>>  3 files changed, 17 insertions(+), 5 deletions(-)
>>
>
> Any feedback on this series?
>
> thanks,
> -- Shuah
