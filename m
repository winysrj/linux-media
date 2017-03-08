Return-path: <linux-media-owner@vger.kernel.org>
Received: from exsmtp03.microchip.com ([198.175.253.49]:19993 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753093AbdCHFH6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Mar 2017 00:07:58 -0500
Subject: Re: [bug report] [media] atmel-isc: add the isc pipeline function
To: Dan Carpenter <dan.carpenter@oracle.com>
References: <20170307001729.GA1588@mwanda>
 <dbe0c888-815d-b981-a9c9-9c7283e81ee0@microchip.com>
 <20170308043814.GD4120@mwanda>
CC: <linux-media@vger.kernel.org>
From: "Wu, Songjun" <Songjun.Wu@microchip.com>
Message-ID: <6f20d036-a2bb-16aa-98e8-7603a4687847@microchip.com>
Date: Wed, 8 Mar 2017 13:06:49 +0800
MIME-Version: 1.0
In-Reply-To: <20170308043814.GD4120@mwanda>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

I understand now, thank you very much.

On 3/8/2017 12:38, Dan Carpenter wrote:
> No.  Imagine the v4l2_subdev_call() loop exits with "fmt" set to NULL.
> It will cause a crash.
>
> Please re-read my original email because I think you may have meant to
> reset fmt after that loop.
>
> regards,
> dan carpenter
>
