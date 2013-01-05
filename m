Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:35598 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755572Ab3AEDMN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 22:12:13 -0500
From: Libin Yang <lbyang@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Albert Wang <twang13@marvell.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 4 Jan 2013 19:12:07 -0800
Subject: RE: [PATCH V3 03/15] [media] marvell-ccic: add clock tree support
 for marvell-ccic driver
Message-ID: <A63A0DC671D719488CD1A6CD8BDC16CF230AFE2590@SC-VEXCH4.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
 <1355565484-15791-4-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1301011633530.31619@axis700.grange>
 <A63A0DC671D719488CD1A6CD8BDC16CF230AFE224B@SC-VEXCH4.marvell.com>
 <Pine.LNX.4.64.1301041042560.28515@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1301041042560.28515@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Please see my comments below.

>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Friday, January 04, 2013 6:25 PM
>To: Libin Yang
>Cc: Albert Wang; corbet@lwn.net; linux-media@vger.kernel.org
>Subject: RE: [PATCH V3 03/15] [media] marvell-ccic: add clock tree support for
>marvell-ccic driver
>
>Hi Libin
>
>On Thu, 3 Jan 2013, Libin Yang wrote:
>
>> Hi Guennadi,
>>
>> Thanks for your review. Please see my comments below.
>>

[snip]

>> >>  /*
>> >> @@ -202,7 +223,7 @@ void mmpcam_calc_dphy(struct mcam_camera *mcam)
>> >>  	 * pll1 will never be changed, it is a fixed value
>> >>  	 */
>> >>
>> >> -	if (IS_ERR(mcam->pll1))
>> >> +	if (IS_ERR_OR_NULL(mcam->pll1))
>> >
>> >Why are you changing this? If this really were needed, you should do this
>> >already in the previous patch, where you add these lines. But I don't
>> >think this is a good idea, don't think Russell would like this :-) NULL is
>> >a valid clock. Only a negative error is a failure. In fact, if you like,
>> >you could initialise .pll1 to ERR_PTR(-EINVAL) in your previous patch in
>> >mmpcam_probe().
>>
>> In the below code, we will use platform related clk_get_rate() to get the rate.
>> In the function we do not judge the clk is NULL or not. If we do not judge here,
>> we need judge for NULL in the later, otherwise, error may happen. Or do you
>> think it is better that we should judge the pointer in the function clk_get_rate()?
>
>I think, there is a problem here. Firstly, if you really want to check for
>"clock API not supported" or a similar type of condition by checking
>get_clk() return value for NULL, you should do this immediately in the
>patch, where you add this code: in "[PATCH V3 02/15] [media] marvell-ccic:
>add MIPI support for marvell-ccic driver." Secondly, it's probably ok to
>check this to say - no clock, co reason to try to use it, in which case
>you skip calculating your ->dphy[2] value, and it remains == 0,
>presumably, is this what you want to have? But, I think, there's a bigger
>problem in your patch #02/15: you don't check for mcam->dphy != NULL. So,
>I think, this has to be fixed in that patch, not here.

Your understanding is right. We will try to use the default value if the pll1
is not available. So we just return if pll1 is error or NULL. And mostly the
default value should work. And this reminds me that there is a little issue:
we should not return fail in the mcam_v4l_open() function when failing
to get the pll1 clk because we can also use the default values.

What I plan to code in the next version is:
1. Remove the judgement of (IS_ERR(cam->pll1)) in the open function when
get the clk.
2. Still use IS_ERR_OR_NULL(mcam->pll1), so that we can use the default
vaule if pll1 is not available.

What do you think of it?

mcam->dphy != NULL may be a critical issue. Thanks for digging out this bug.
We will fix it in the next version.

>
>[snip]
>
>> >> +{
>> >> +	unsigned int i;
>> >> +
>> >> +	if (NR_MCAM_CLK < pdata->clk_num) {
>> >> +		dev_err(mcam->dev, "Too many mcam clocks defined\n");
>> >> +		mcam->clk_num = 0;
>> >> +		return;
>> >> +	}
>> >> +
>> >> +	if (init) {
>> >> +		for (i = 0; i < pdata->clk_num; i++) {
>> >> +			if (pdata->clk_name[i] != NULL) {
>> >> +				mcam->clk[i] = devm_clk_get(mcam->dev,
>> >> +						pdata->clk_name[i]);
>> >
>> >Sorry, no. Passing clock names in platform data doesn't look right to me.
>> >Clock names are a property of the consumer device, not of clock supplier.
>> >Also, your platform tells you to get clk_num clocks, you fail to get one
>> >of them, you don't continue trying the rest and just return with no error.
>> >This seems strange, usually a failure to get clocks, that the platform
>> >tells you to get, is fatal.
>>
>> I agree that after failing to get the clk, we should return error
>> instead of just returning.
>>
>> For the clock names, the clock names are different on different platforms.
>> So we need platform data passing the clock names. Do you have any suggestions?
>
>I think you should use the same names on all platforms. As I said, those
>are names of _consumer_ clocks, not of supplier. And the consumer on all
>platforms is the same - your camera unit. If you cannot remove existing
>clock entries for compatibility reasons you, probably, can just add clock
>lookup entries for them. In the _very_ worst case, maybe make a table of
>clock names and, depending on the SoC type use one of them, but that's
>really also not very apropriate, not sure, whether that would be accepted.

OK, I see. I will use the names directly in the camera driver without 
getting them from the platform data.

>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

Regards,
Libin
