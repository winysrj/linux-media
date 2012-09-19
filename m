Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54704 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab2ISUye (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 16:54:34 -0400
Received: by bkwj10 with SMTP id j10so779842bkw.19
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2012 13:54:32 -0700 (PDT)
Message-ID: <505A3112.10207@googlemail.com>
Date: Wed, 19 Sep 2012 22:54:42 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] gspca_pac7302: add support for green balance adjustment
References: <1347811240-4000-1-git-send-email-fschaefer.oss@googlemail.com> <1347811240-4000-4-git-send-email-fschaefer.oss@googlemail.com> <5059FFF1.30104@googlemail.com> <505A2C52.4040001@redhat.com>
In-Reply-To: <505A2C52.4040001@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 19.09.2012 22:34, schrieb Hans de Goede:
> Hi,
>
> On 09/19/2012 07:25 PM, Frank Schäfer wrote:
>> Am 16.09.2012 18:00, schrieb Frank Schäfer:
>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>>> ---
>>>   drivers/media/usb/gspca/pac7302.c |   23 ++++++++++++++++++++++-
>>>   1 files changed, 22 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/gspca/pac7302.c
>>> b/drivers/media/usb/gspca/pac7302.c
>>> index 8a0f4d6..9b62b74 100644
>>> --- a/drivers/media/usb/gspca/pac7302.c
>>> +++ b/drivers/media/usb/gspca/pac7302.c
>>> @@ -78,6 +78,7 @@
>>>    * Page | Register   | Function
>>>    *
>>> -----+------------+---------------------------------------------------
>>>    *  0   | 0x01       | setredbalance()
>>> + *  0   | 0x02       | setgreenbalance()
>>>    *  0   | 0x03       | setbluebalance()
>>>    *  0   | 0x0f..0x20 | setcolors()
>>>    *  0   | 0xa2..0xab | setbrightcont()
>>> @@ -121,6 +122,7 @@ struct sd {
>>>       struct v4l2_ctrl *saturation;
>>>       struct v4l2_ctrl *white_balance;
>>>       struct v4l2_ctrl *red_balance;
>>> +    struct v4l2_ctrl *green_balance;
>>>       struct v4l2_ctrl *blue_balance;
>>>       struct { /* flip cluster */
>>>           struct v4l2_ctrl *hflip;
>>> @@ -470,6 +472,17 @@ static void setredbalance(struct gspca_dev
>>> *gspca_dev)
>>>       reg_w(gspca_dev, 0xdc, 0x01);
>>>   }
>>>
>>> +static void setgreenbalance(struct gspca_dev *gspca_dev)
>>> +{
>>> +    struct sd *sd = (struct sd *) gspca_dev;
>>> +
>>> +    reg_w(gspca_dev, 0xff, 0x00);            /* page 0 */
>>> +    reg_w(gspca_dev, 0x02,
>>> +          rgbbalance_ctrl_to_reg_value(sd->green_balance->val));
>>> +
>>> +    reg_w(gspca_dev, 0xdc, 0x01);
>>> +}
>>> +
>>>   static void setbluebalance(struct gspca_dev *gspca_dev)
>>>   {
>>>       struct sd *sd = (struct sd *) gspca_dev;
>>> @@ -620,6 +633,9 @@ static int sd_s_ctrl(struct v4l2_ctrl *ctrl)
>>>       case V4L2_CID_RED_BALANCE:
>>>           setredbalance(gspca_dev);
>>>           break;
>>> +    case V4L2_CID_GREEN_BALANCE:
>>> +        setgreenbalance(gspca_dev);
>>> +        break;
>>>       case V4L2_CID_BLUE_BALANCE:
>>>           setbluebalance(gspca_dev);
>>>           break;
>>> @@ -652,7 +668,7 @@ static int sd_init_controls(struct gspca_dev
>>> *gspca_dev)
>>>       struct v4l2_ctrl_handler *hdl = &gspca_dev->ctrl_handler;
>>>
>>>       gspca_dev->vdev.ctrl_handler = hdl;
>>> -    v4l2_ctrl_handler_init(hdl, 12);
>>> +    v4l2_ctrl_handler_init(hdl, 13);
>>>
>>>       sd->brightness = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
>>>                       V4L2_CID_BRIGHTNESS, 0, 32, 1, 16);
>>> @@ -669,6 +685,11 @@ static int sd_init_controls(struct gspca_dev
>>> *gspca_dev)
>>>                       PAC7302_RGB_BALANCE_MIN,
>>>                       PAC7302_RGB_BALANCE_MAX,
>>>                       1, PAC7302_RGB_BALANCE_DEFAULT);
>>> +    sd->green_balance = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
>>> +                    V4L2_CID_GREEN_BALANCE,
>>> +                    PAC7302_RGB_BALANCE_MIN,
>>> +                    PAC7302_RGB_BALANCE_MAX,
>>> +                    1, PAC7302_RGB_BALANCE_DEFAULT);
>>>       sd->blue_balance = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
>>>                       V4L2_CID_BLUE_BALANCE,
>>>                       PAC7302_RGB_BALANCE_MIN,
>>
>> Hans, it seems like you didn't pick up these patches up yet...
>> Is there anything wrong with them ?
>
> I've somehow completely missed them. Can you resend the entire set
> please?

No problem, but I can't do that before weekend (I'm currently not at home).
I've sent these 4 patches on last Sunday (16. Sept) evening.
Maybe you can pick them up from patchwork ?
http://patchwork.linuxtv.org/patch/14433/

Regards,
Frank

>
> Thanks,
>
> Hans

