Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:49365 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365Ab2LPVvx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 16:51:53 -0500
From: Albert Wang <twang13@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Sun, 16 Dec 2012 13:51:51 -0800
Subject: RE: [PATCH V3 03/15] [media] marvell-ccic: add clock tree support
 for marvell-ccic driver
Message-ID: <477F20668A386D41ADCC57781B1F70430D13C8CCDE@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-4-git-send-email-twang13@marvell.com>
 <20121216090305.13e6bca1@hpe.lwn.net>
In-Reply-To: <20121216090305.13e6bca1@hpe.lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Jonathan


>-----Original Message-----
>From: Jonathan Corbet [mailto:corbet@lwn.net]
>Sent: Monday, 17 December, 2012 00:03
>To: Albert Wang
>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH V3 03/15] [media] marvell-ccic: add clock tree support for marvell-
>ccic driver
>
>On Sat, 15 Dec 2012 17:57:52 +0800
>Albert Wang <twang13@marvell.com> wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch adds the clock tree support for marvell-ccic.
>>
>> Each board may require different clk enabling sequence.
>> Developer need add the clk_name in correct sequence in board driver
>> to use this feature.
>>
>> +static void mcam_clk_set(struct mcam_camera *mcam, int on)
>> +{
>> +	unsigned int i;
>> +
>> +	if (on) {
>> +		for (i = 0; i < mcam->clk_num; i++) {
>> +			if (mcam->clk[i])
>> +				clk_enable(mcam->clk[i]);
>> +		}
>> +	} else {
>> +		for (i = mcam->clk_num; i > 0; i--) {
>> +			if (mcam->clk[i - 1])
>> +				clk_disable(mcam->clk[i - 1]);
>> +		}
>> +	}
>> +}
>
>A couple of minor comments:
>
> - This function is always called with a constant value for "on".  It would
>   be easier to read (and less prone to unfortunate brace errors) if it
>   were just two functions: mcam_clk_enable() and mcam_clk_disable().
>
[Albert Wang] OK, that's fine to split it to 2 functions. :)

> - I'd write the second for loop as:
>
>	for (i = mcal->clk_num - 1; i >= 0; i==) {
>
>   just to match the values used in the other direction and avoid the
>   subscript arithmetic.
>
[Albert Wang] Yes, we can improve it. :)

>> +static void mcam_init_clk(struct mcam_camera *mcam,
>> +			struct mmp_camera_platform_data *pdata, int init)
>
>So why does an "init" function have an "init" parameter?  Again, I think
>this would be far better split into two functions.  Among other things,
>that would help to reduce the deep nesting below.
>
[Albert Wang] Yes, the parameter name is confused.
And we will split this function too. :)

>> +{
>> +	unsigned int i;
>> +
>> +	if (NR_MCAM_CLK < pdata->clk_num) {
>> +		dev_err(mcam->dev, "Too many mcam clocks defined\n");
>> +		mcam->clk_num = 0;
>> +		return;
>> +	}
>> +
>> +	if (init) {
>> +		for (i = 0; i < pdata->clk_num; i++) {
>> +			if (pdata->clk_name[i] != NULL) {
>> +				mcam->clk[i] = devm_clk_get(mcam->dev,
>> +						pdata->clk_name[i]);
>> +				if (IS_ERR(mcam->clk[i])) {
>> +					dev_err(mcam->dev,
>> +						"Could not get clk: %s\n",
>> +						pdata->clk_name[i]);
>> +					mcam->clk_num = 0;
>> +					return;
>> +				}
>> +			}
>> +		}
>> +		mcam->clk_num = pdata->clk_num;
>> +	} else
>> +		mcam->clk_num = 0;
>> +}
>
>Again, minor comments, but I do think the code would be improved by
>splitting those functions.  Meanwhile:
>
>Acked-by: Jonathan Corbet <corbet@lwn.net>
>
>jon

 
Thanks
Albert Wang
86-21-61092656
