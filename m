Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.137]:44785 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750785AbeASHrR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 02:47:17 -0500
Reply-To: zhengsq@rock-chips.com
Subject: Re: [PATCH v6 4/4] media: ov2685: add support for OV2685 sensor
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
References: <1516094521-22708-1-git-send-email-zhengsq@rock-chips.com>
 <1516094521-22708-5-git-send-email-zhengsq@rock-chips.com>
 <20180118224854.zd3nqnhsxbwzxw7g@valkosipuli.retiisi.org.uk>
From: Shunqian Zheng <zhengsq@rock-chips.com>
Message-ID: <c470987f-a76e-fe38-b98c-e47176fe8279@rock-chips.com>
Date: Fri, 19 Jan 2018 15:47:05 +0800
MIME-Version: 1.0
In-Reply-To: <20180118224854.zd3nqnhsxbwzxw7g@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,


On 2018年01月19日 06:48, Sakari Ailus wrote:
> Hi Shunqian,
>
> On Tue, Jan 16, 2018 at 05:22:01PM +0800, Shunqian Zheng wrote:
>> +MODULE_DEVICE_TABLE(of, ov5695_of_match);
> ov2685? How was this tested?
>
> I can fix that while applying if that's the only one that needs to be taken
> care of. At least it was the only one I found.
>
Ah.. I didn't test module building.
Thank you very much~
