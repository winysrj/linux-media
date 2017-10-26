Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42351 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751027AbdJZGxd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 02:53:33 -0400
Subject: Re: [PATCH 0/2] Fix s5p-mfc lock contention in request firmware paths
To: Marian Mihailescu <marian.mihailescu@adelaide.edu.au>
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        Andrzej Hajda <a.hajda@samsung.com>, mchehab@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
References: <cover.1507325072.git.shuahkh@osg.samsung.com>
 <354e3c31-e502-5ba6-d705-9d67764e78bf@osg.samsung.com>
 <CAM3PiRzS966v=pWRq641sFF-Kg5wHc6fH524CQKusURNfcD0ew@mail.gmail.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <ddde8616-6bbc-266b-f28c-3f6125ce5027@osg.samsung.com>
Date: Thu, 26 Oct 2017 00:53:28 -0600
MIME-Version: 1.0
In-Reply-To: <CAM3PiRzS966v=pWRq641sFF-Kg5wHc6fH524CQKusURNfcD0ew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/25/2017 04:28 PM, Marian Mihailescu wrote:
> Hi Shuah,
> 
> For MFC patch, you can delete the "dev" variable since it's not being
> used anymore and results in a compile warning.
> 
> - struct s5p_mfc_dev *dev = ctx->dev;
> 
> Cheers,
> Marian

Oops. I thought I handled that. I will fix that and resend the patch.

thanks,
-- Shuah
