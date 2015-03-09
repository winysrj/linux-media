Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:30368 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbCIBdn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 21:33:43 -0400
Message-ID: <54FCF868.2050708@atmel.com>
Date: Mon, 9 Mar 2015 09:33:28 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] media: atmel-isi: remove mck back compatiable code
 as we don't need it
References: <1425531661-20040-1-git-send-email-josh.wu@atmel.com> <54F97DDF.7010403@atmel.com> <Pine.LNX.4.64.1503062124450.20271@axis700.grange> <2234113.JDoJN7Dx5y@avalon>
In-Reply-To: <2234113.JDoJN7Dx5y@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent

On 3/8/2015 8:28 AM, Laurent Pinchart wrote:
> On Friday 06 March 2015 21:25:36 Guennadi Liakhovetski wrote:
>> On Fri, 6 Mar 2015, Josh Wu wrote:
>>> On 3/5/2015 6:41 PM, Laurent Pinchart wrote:
>>>> On Thursday 05 March 2015 13:01:01 Josh Wu wrote:
>>>>> The master clock should handled by sensor itself.
>>>> I like that :-)
>>>>
>>>>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>>>>> ---
>>>>>
>>>>>    drivers/media/platform/soc_camera/atmel-isi.c | 32 -------------------
>>>>>    1 file changed, 32 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
>>>>> b/drivers/media/platform/soc_camera/atmel-isi.c index 4a384f1..50375ce
>>>>> 100644
>>>>> --- a/drivers/media/platform/soc_camera/atmel-isi.c
>>>>> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
>>>>> @@ -83,8 +83,6 @@ struct atmel_isi {
>>>>>
>>>>>    	struct completion		complete;
>>>>>    	/* ISI peripherial clock */
>>>>>    	struct clk			*pclk;
>>>>>
>>>>> -	/* ISI_MCK, feed to camera sensor to generate pixel clock */
>>>>> -	struct clk			*mck;
>>>>>
>>>>>    	unsigned int			irq;
>>>>>    	
>>>>>    	struct isi_platform_data	pdata;
>>>>>
>>>>> @@ -725,26 +723,12 @@ static void isi_camera_remove_device(struct
>>>>> soc_camera_device *icd) /* Called with .host_lock held */
>>>>>
>>>>>    static int isi_camera_clock_start(struct soc_camera_host *ici)
>>>>>    {
>>>>>
>>>>> -	struct atmel_isi *isi = ici->priv;
>>>>> -	int ret;
>>>>> -
>>>>> -	if (!IS_ERR(isi->mck)) {
>>>>> -		ret = clk_prepare_enable(isi->mck);
>>>>> -		if (ret) {
>>>>> -			return ret;
>>>>> -		}
>>>>> -	}
>>>>> -
>>>>>
>>>>>    	return 0;
>>>> Would it make sense to make the clock_start and clock_stop operations
>>>> optional in the soc-camera core ?
>>> I agree. For those camera host which don't provide master clock for
>>> sensor, clock_start and clock_stop should be optional.
>>>
>>> Hi, Guennadi
>>>
>>> Do you agree with this?
>> Yes, sure, we can do this. Would anyone like to prepare a patch?
> Josh, would you like to do that, or should I give it a go ?
>

Yes, you can do that if you have time. ;-)

Best Regards,
Josh Wu
