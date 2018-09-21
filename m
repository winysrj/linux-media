Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:26806 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbeIUIOp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 04:14:45 -0400
Subject: Re: [PATCH v5] media: add imx319 camera sensor driver
To: Tomasz Figa <tfiga@chromium.org>,
        Cao Bing Bu <bingbu.cao@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
References: <1537163872-14567-1-git-send-email-bingbu.cao@intel.com>
 <CAAFQd5Dp8kp6fi8bXr6jODO0Cr4Kqu5L0eSXudsrOkHK6cKdjg@mail.gmail.com>
From: Bing Bu Cao <bingbu.cao@linux.intel.com>
Message-ID: <c2998a8f-90bf-e5c8-e45d-e52d2bebcca0@linux.intel.com>
Date: Fri, 21 Sep 2018 10:31:54 +0800
MIME-Version: 1.0
In-Reply-To: <CAAFQd5Dp8kp6fi8bXr6jODO0Cr4Kqu5L0eSXudsrOkHK6cKdjg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 09/18/2018 05:49 PM, Tomasz Figa wrote:
> Hi Bingbu,
>
> On Mon, Sep 17, 2018 at 2:53 PM <bingbu.cao@intel.com> wrote:
>> From: Bingbu Cao <bingbu.cao@intel.com>
>>
>> Add a v4l2 sub-device driver for the Sony imx319 image sensor.
>> This is a camera sensor using the i2c bus for control and the
>> csi-2 bus for data.
> Please see my comments inline. Also, I'd appreciate being CCed on
> related work in the future.
Ack.
Sorry, will add you into the cc-list.
>
> [snip]
>> +
>> +static const char * const imx319_test_pattern_menu[] = {
>> +       "Disabled",
>> +       "100% color bars",
>> +       "Solid color",
>> +       "Fade to gray color bars",
>> +       "PN9"
>> +};
>> +
>> +static const int imx319_test_pattern_val[] = {
>> +       IMX319_TEST_PATTERN_DISABLED,
>> +       IMX319_TEST_PATTERN_COLOR_BARS,
>> +       IMX319_TEST_PATTERN_SOLID_COLOR,
>> +       IMX319_TEST_PATTERN_GRAY_COLOR_BARS,
>> +       IMX319_TEST_PATTERN_PN9,
>> +};
> This array is not needed. All the entries are equal to corresponding
> indices, i.e. the array is equivalent to { 0, 1, 2, 3, 4 }. We can use
> ctrl->val directly.
Ack.
> [snip]
>
>> +/* Write a list of registers */
>> +static int imx319_write_regs(struct imx319 *imx319,
>> +                             const struct imx319_reg *regs, u32 len)
>> +{
>> +       struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
>> +       int ret;
>> +       u32 i;
>> +
>> +       for (i = 0; i < len; i++) {
>> +               ret = imx319_write_reg(imx319, regs[i].address, 1, regs[i].val);
>> +               if (ret) {
>> +                       dev_err_ratelimited(&client->dev,
>> +
> Hmm, the message is clipped here. Let me see if it's something with my
> email client...
The code here:

1827 for (i = 0; i < len; i++) {
1828 ret = imx319_write_reg(imx319, regs[i].address, 1, regs[i].val);
1829 if (ret) {
1830 dev_err_ratelimited(&client->dev,
1831 "write reg 0x%4.4x return err %d",
1832 regs[i].address, ret);
1833 return ret;
1834 }
1835 } Same as the code shown on your client?

>
> Best regards,
> Tomasz
>
