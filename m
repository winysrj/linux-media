Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750798AbdE1S0b (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 14:26:31 -0400
Subject: Re: [PATCH v5 2/7] staging: atomisp: Do not call dev_warn with a NULL
 device
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20170528123040.18555-1-hdegoede@redhat.com>
 <20170528123040.18555-2-hdegoede@redhat.com>
 <20170528180853.5a6c8f11@alans-desktop>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <508ccb9b-fcde-b040-593d-5e8552db5f24@redhat.com>
Date: Sun, 28 May 2017 20:26:28 +0200
MIME-Version: 1.0
In-Reply-To: <20170528180853.5a6c8f11@alans-desktop>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 28-05-17 19:08, Alan Cox wrote:
> On Sun, 28 May 2017 14:30:35 +0200
> Hans de Goede <hdegoede@redhat.com> wrote:
> 
>> Do not call dev_warn with a NULL device, this silence the following 2
>> warnings:
>>
>> [   14.392194] (NULL device *): Failed to find gmin variable gmin_V2P8GPIO
>> [   14.392257] (NULL device *): Failed to find gmin variable gmin_V1P8GPIO
>>
>> We could switch to using pr_warn for dev == NULL instead, but as comments
>> in the source indicate, the check for these 2 special gmin variables with
>> a NULL device is a workaround for 2 specific evaluation boards, so
>> completely silencing the missing warning for these actually is a good
>> thing.
> 
> At which point real missing variables won't get reported so NAK. I think
> the right fix is to make the offending callers pass
> 
> 	subdev->dev

The code for the special v1p8 / v2p8 gpios is ugly as sin, it operates on
a global v2p8_gpio value rather then storing info in the gmin_subdev struct,
as such passing the subdev->dev pointer would be simply wrong. AFAICT the
v1p8 / v2p8 gpio code is the only caller passing in a NULL pointer and
as said since thisv1p8 / v2p8 gpio code is only for some special evaluation
boards, silencing the error when these variables are not present actually
is the right thing to do.

> which if my understanding of the subdevices is correct should pass the
> right valid device field from the atomisp.
> 
> Please also cc me if you are proposing patches this driver - and also
> linux-media.

Sorry about that, I messed up my git send-email foo and send this to
a wrong set of addresses (and also added v5 in the subject which should
not be there) I did send out a fresh-copy with the full 7 patch patch-set
directly after CTRL+c-ing this wrong send-email (which only got the
first 3 patches send).

Regards,

Hans
