Return-path: <linux-media-owner@vger.kernel.org>
Received: from exsmtp02.microchip.com ([198.175.253.38]:35097 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756425AbdCHDHk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 22:07:40 -0500
Subject: Re: [bug report] [media] atmel-isc: add the isc pipeline function
To: Dan Carpenter <dan.carpenter@oracle.com>
References: <20170307001729.GA1588@mwanda>
CC: <linux-media@vger.kernel.org>
From: "Wu, Songjun" <Songjun.Wu@microchip.com>
Message-ID: <dbe0c888-815d-b981-a9c9-9c7283e81ee0@microchip.com>
Date: Wed, 8 Mar 2017 11:01:36 +0800
MIME-Version: 1.0
In-Reply-To: <20170307001729.GA1588@mwanda>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

Thank you very much for your bug report.
Then I have question about 'error: we previously assumed 'fmt' could be 
null (see line 1480)'
Do you mean that the code should be written like 'if (fmt == NULL)'?

On 3/7/2017 08:17, Dan Carpenter wrote:
>   1476          while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
>   1477                 NULL, &mbus_code)) {
>   1478                  mbus_code.index++;
>   1479                  fmt = find_format_by_code(mbus_code.code, &i);
>   1480                  if (!fmt)
>                              ^^^
> Check for NULL.
