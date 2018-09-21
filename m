Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:32771 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbeIUNlQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 09:41:16 -0400
Received: by mail-yb1-f196.google.com with SMTP id y9-v6so5069135ybh.0
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 00:53:35 -0700 (PDT)
Received: from mail-yw1-f42.google.com (mail-yw1-f42.google.com. [209.85.161.42])
        by smtp.gmail.com with ESMTPSA id l127-v6sm4708410ywc.5.2018.09.21.00.53.33
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Sep 2018 00:53:33 -0700 (PDT)
Received: by mail-yw1-f42.google.com with SMTP id 14-v6so4843771ywe.2
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 00:53:33 -0700 (PDT)
MIME-Version: 1.0
References: <1537163872-14567-1-git-send-email-bingbu.cao@intel.com>
 <CAAFQd5Dp8kp6fi8bXr6jODO0Cr4Kqu5L0eSXudsrOkHK6cKdjg@mail.gmail.com> <c2998a8f-90bf-e5c8-e45d-e52d2bebcca0@linux.intel.com>
In-Reply-To: <c2998a8f-90bf-e5c8-e45d-e52d2bebcca0@linux.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 21 Sep 2018 16:53:21 +0900
Message-ID: <CAAFQd5DWfwvQG2DYkT+2ONnxDwtBuRRmo5+o=6SLHX2-btE9zA@mail.gmail.com>
Subject: Re: [PATCH v5] media: add imx319 camera sensor driver
To: bingbu.cao@linux.intel.com
Cc: Cao Bing Bu <bingbu.cao@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 21, 2018 at 11:28 AM Bing Bu Cao <bingbu.cao@linux.intel.com> wrote:
>
>
> On 09/18/2018 05:49 PM, Tomasz Figa wrote:
> > Hi Bingbu,
> >
> > On Mon, Sep 17, 2018 at 2:53 PM <bingbu.cao@intel.com> wrote:
> >> From: Bingbu Cao <bingbu.cao@intel.com>
> >>
> >> Add a v4l2 sub-device driver for the Sony imx319 image sensor.
> >> This is a camera sensor using the i2c bus for control and the
> >> csi-2 bus for data.
> > Please see my comments inline. Also, I'd appreciate being CCed on
> > related work in the future.
> Ack.
> Sorry, will add you into the cc-list.
> >
> > [snip]
> >> +
> >> +static const char * const imx319_test_pattern_menu[] = {
> >> +       "Disabled",
> >> +       "100% color bars",
> >> +       "Solid color",
> >> +       "Fade to gray color bars",
> >> +       "PN9"
> >> +};
> >> +
> >> +static const int imx319_test_pattern_val[] = {
> >> +       IMX319_TEST_PATTERN_DISABLED,
> >> +       IMX319_TEST_PATTERN_COLOR_BARS,
> >> +       IMX319_TEST_PATTERN_SOLID_COLOR,
> >> +       IMX319_TEST_PATTERN_GRAY_COLOR_BARS,
> >> +       IMX319_TEST_PATTERN_PN9,
> >> +};
> > This array is not needed. All the entries are equal to corresponding
> > indices, i.e. the array is equivalent to { 0, 1, 2, 3, 4 }. We can use
> > ctrl->val directly.
> Ack.
> > [snip]
> >
> >> +/* Write a list of registers */
> >> +static int imx319_write_regs(struct imx319 *imx319,
> >> +                             const struct imx319_reg *regs, u32 len)
> >> +{
> >> +       struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> >> +       int ret;
> >> +       u32 i;
> >> +
> >> +       for (i = 0; i < len; i++) {
> >> +               ret = imx319_write_reg(imx319, regs[i].address, 1, regs[i].val);
> >> +               if (ret) {
> >> +                       dev_err_ratelimited(&client->dev,
> >> +
> > Hmm, the message is clipped here. Let me see if it's something with my
> > email client...
> The code here:
>
> 1827 for (i = 0; i < len; i++) {
> 1828 ret = imx319_write_reg(imx319, regs[i].address, 1, regs[i].val);
> 1829 if (ret) {
> 1830 dev_err_ratelimited(&client->dev,
> 1831 "write reg 0x%4.4x return err %d",
> 1832 regs[i].address, ret);
> 1833 return ret;
> 1834 }
> 1835 } Same as the code shown on your client?

That was an issue with my email client, which showed only lines until
1831. I've worked around it and reviewed rest of the code in next
reply. Sorry for the noise.

Best regards,
Tomasz
