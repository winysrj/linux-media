Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:49717 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab3GQWRW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 18:17:22 -0400
Received: by mail-ea0-f172.google.com with SMTP id q10so1337241eaj.17
        for <linux-media@vger.kernel.org>; Wed, 17 Jul 2013 15:17:21 -0700 (PDT)
Message-ID: <51E717EF.9070703@zenburn.net>
Date: Thu, 18 Jul 2013 00:17:19 +0200
From: =?UTF-8?B?SmFrdWIgUGlvdHIgQ8WCYXBh?= <jpc-ml@zenburn.net>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [omap3isp] xclk deadlock
References: <51D37796.2000601@zenburn.net> <1604535.2Z0SUEyxcF@avalon> <51E0165C.5000401@zenburn.net> <3227918.6DpNM0vnE9@avalon>
In-Reply-To: <3227918.6DpNM0vnE9@avalon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17.07.13 14:50, Laurent Pinchart wrote:
> Hi Jakub,
>
>> 3. After setting up a simple pipeline using media-ctl[2] I get "CCDC
>> won't become idle errors". If I do this after running "live" I also get
>> (unless it hangs) the CCDC Register dump [1]. Otherwise I only get the
>> stream of kernel log messages without anything else from omap3isp.
>>
>> 4. I recreated the "live" pipeline (judging by the lack of differences
>> in media-ctl -p output [3]) and used yavta. I get the same hangs but
>> when I don't I can check the UYVY frames one by one. They look bad at
>> any stride (I dropped the UV components and tried to get some meaningful
>> output in the GIMP raw image data import dialog by adjustung the "width").
>
> Would you be able to bisect the problems ? Please also see below for more
> comments.

I think the clock & voltage regulator framework changes in omap3beagle.c 
would require reverting for earlier versions? Are there any other things 
I should watch out for?

> As a side note, you can use raw2rgbpnm (https://gitorious.org/raw2rgbpnm) to
> convert raw binary images to a more usable format.

Thanks. The nice thing about the GIMP import tool is interactiveness, 
which is good when (I suspect) I don't know the proper image dimensions.

>> [2]:
>> media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
>> CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>> media-ctl -v -f '"mt9p031 2-0048":0 [SGRBG12 800x600 (96,72)/2400x1800],
>> "OMAP3 ISP CCDC":1 [SGRBG8 800x600]'
>
> You're trying to configure the sensor output to 800x600, but the closest
> resolution the sensor can deliver is 864x648. The sensor driver will thus
> return that resolution, and media-ctl will automatically configure the
> connected pad (CCDC sink pad 0) with the same resolution. Similarly, you try
> to configure the CCDC output to 800x600, but the CCDC driver will
> automatically set its output resolution (on source pad 1) to 864x648. media-
> ctl won't complain, and your pipeline will be correctly configured, but not in
> the resolution you expect.

>> yavta -f SGRBG12 -s 800x600 -n 8 --skip 4 --capture=5 -F'frame-#.bin'
>> $(media-ctl -e "OMAP3 ISP CCDC output")
>
> Can you run this without error ? You're trying to capture in 800x600 at the
> CCDC output but the pipeline has been configured with a different resolution.
> The OMAP3 ISP driver should return an error when you start the video stream.
> If it doesn't, that's a driver bug.

I think you missed my ingenious sensor crop. ;) The sensor should be 
capable of scaling to 800x600 if it crops to (96,72)/2400x1800 first 
(this just requires 3x binning). I tried this on 3.2.24 and it worked.

>> [4]:
>>
>> @@ -21,9 +21,9 @@
>>    omap3isp omap3isp: ###RSZ YENH=0x00000000
>>    omap3isp omap3isp: --------------------------------------------
>>    omap3isp omap3isp: -------------Preview Register dump----------
>> -omap3isp omap3isp: ###PRV PCR=0x180e0609
>> -omap3isp omap3isp: ###PRV HORZ_INFO=0x0006035b
>> -omap3isp omap3isp: ###PRV VERT_INFO=0x00000286
>> +omap3isp omap3isp: ###PRV PCR=0x180e0600
>
> Bits 0 and 3 are the ENABLE and ONESHOT bits respectively. The registers dump
> might have been displayed at a different time in v3.2.24 (although I haven't
> checked);
>
>> +omap3isp omap3isp: ###PRV HORZ_INFO=0x00080359
>> +omap3isp omap3isp: ###PRV VERT_INFO=0x00020284
>
> Those two registers contain the input crop rectangle coordinates (left/top in
> bits 31-16, right/bottom in bits 15-0). Note that this is the internal crop
> rectangle, which takesrows and columns required for internal processing into
> account. It will thus not match the user-visible crop rectangle at the sink
> pad.
>
> The crop rectangle has changed from (6,0)/860x647 to (8,2)/850x643. The
> preview engine internally crops 4 rows and 4 columns (2 on each side) when
> converting from Bayer to YUV, so the (8,2)/850x643 crop rectangle becomes
> (10,4)/846x639 after manual and internal cropping, which matches the value
> reported by media-ctl -p.

But why does those cropping differences (between 3.2.24 and 3.10) happen 
at all? I run the same live code on 3.2.24 and 3.10, with the same 
sensor and output resolution. I think I got the same `media-ctl -p` 
output after running `live` on both kernels but will check this tomorrow.

If these internal cropping rectangles on 3.10 were wrong it would 
probably explain the "bad synchronization" problem.

>>    omap3isp omap3isp: ###PRV RSDR_ADDR=0x00000000
>>    omap3isp omap3isp: ###PRV RADR_OFFSET=0x00000000
>>    omap3isp omap3isp: ###PRV DSDR_ADDR=0x00000000
>> @@ -52,7 +52,7 @@
>>    omap3isp omap3isp: ###PRV CNT_BRT=0x00001000
>>    omap3isp omap3isp: ###PRV CSUP=0x00000000
>>    omap3isp omap3isp: ###PRV SETUP_YC=0xff00ff00
>> -omap3isp omap3isp: ###PRV SET_TBL_ADDR=0x00000800
>> +omap3isp omap3isp: ###PRV SET_TBL_ADDR=0x00001700
>>    omap3isp omap3isp: ###PRV CDC_THR0=0x0000000e
>>    omap3isp omap3isp: ###PRV CDC_THR1=0x0000000e
>>    omap3isp omap3isp: ###PRV CDC_THR2=0x0000000e

-- 
regards,
Jakub Piotr Cłapa
LoEE.pl
