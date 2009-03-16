Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:49976 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbZCPS1C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 14:27:02 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] pxa_camera: Enforce YUV422P frame sizes to be 16 multiples
References: <1236986240-24115-1-git-send-email-robert.jarzmik@free.fr>
	<1236986240-24115-2-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0903142359230.8263@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 16 Mar 2009 19:26:50 +0100
Message-ID: <8763i9fhn9.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> @@ -162,6 +162,8 @@
>>  			CICR0_PERRM | CICR0_QDM | CICR0_CDM | CICR0_SOFM | \
>>  			CICR0_EOFM | CICR0_FOM)
>>  
>> +#define PIX_YUV422P_ALIGN 16	/* YUV422P pix size should be a multiple of 16 */
>
> What is a "pix size?" Did you mean "picture size?"
Yes. I'll change the comment from "pix size" into "picture size"

>> -	/* planar capture requires Y, U and V buffers to be page aligned */
>> -	if (pcdev->channels == 3) {
>> -		*size = PAGE_ALIGN(icd->width * icd->height); /* Y pages */
>> -		*size += PAGE_ALIGN(icd->width * icd->height / 2); /* U pages */
>> -		*size += PAGE_ALIGN(icd->width * icd->height / 2); /* V pages */
>> -	} else {
>> -		*size = icd->width * icd->height *
>> -			((icd->current_fmt->depth + 7) >> 3);
>> -	}
>> +	if (pcdev->channels == 3)
>> +		*size = icd->width * icd->height * 2;
>
> This is not very obvious, why "* 2". Maybe use
>
> pxa_camera_formats[0].depth / 8 or at least add a comment?

Yes.
I was wondering about simplifying the if (removing it actually), and changing :
>> +	if (pcdev->channels == 3)
>> +		*size = icd->width * icd->height * 2;
>> +	else
>> +		*size = roundup(icd->width * icd->height *
>> +				((icd->current_fmt->depth + 7) >> 3), 8);
into:
	*size = roundup(icd->width * icd->height *
			((icd->current_fmt->depth + 7) >> 3), 8);

>> +	if (xlate->host_fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
>> +		if (!IS_ALIGNED(pix->width * pix->height, PIX_YUV422P_ALIGN))
>> +			pix->height = ALIGN(pix->height, PIX_YUV422P_ALIGN / 2);
>> +		if (!IS_ALIGNED(pix->width * pix->height, PIX_YUV422P_ALIGN))
>> +			pix->width = ALIGN(pix->width, PIX_YUV422P_ALIGN / 2);
>
> Shouldn't this have been sqrt(PIX_YUV422P_ALIGN) (of course, not 
> literally) instead of PIX_YUV422P_ALIGN / 2? At least above you say, 
> height and width shall be 4 bytes aligned, not 8.
That's a very good catch.
Maybe 2 defines will fit better, as I'm not very please with log2 logic here ... :

/*
 * YUV422P picture size should be a multiple of 16, so the heuristic aligns
 * height, width on 4 byte boundaries to reach the 16 multiple for the size.
 */
#define YUV422P_X_Y_ALIGN 4
#define YUV422P_SIZE_ALIGN YUV422P_X_Y_ALIGN * YUV422P_X_Y_ALIGN

Cheers.

--
Robert
