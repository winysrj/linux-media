Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36925 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751623AbdIMJRD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 05:17:03 -0400
MIME-Version: 1.0
In-Reply-To: <20170913091000.3dtzrx3rr4g5rql3@mwanda>
References: <1505293073-27622-1-git-send-email-allen.lkml@gmail.com> <20170913091000.3dtzrx3rr4g5rql3@mwanda>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 13 Sep 2017 14:47:01 +0530
Message-ID: <CAOMdWSLCuE3qteiTbovJqEd_LtDFp4qqguOvDKscHYE-rO_C5w@mail.gmail.com>
Subject: Re: [PATCH v3] drivers/staging:[media]atomisp:use ARRAY_SIZE()
 instead of open coding.
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mchehab@kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> bad:  [PATCH v3] drivers/staging:[media]atomisp:use ARRAY_SIZE() instead of open coding.
> good: [PATCH v4] [media] atomisp: use ARRAY_SIZE() instead of open coding.

My bad. Fixed it in V4. Thanks.

- Allen
