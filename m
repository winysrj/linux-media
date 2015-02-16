Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43388 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755888AbbBPOcG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 09:32:06 -0500
Message-ID: <54E1FF50.9030803@xs4all.nl>
Date: Mon, 16 Feb 2015 15:31:44 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Miguel Casas-Sanchez <mcasas@chromium.org>,
	linux-media@vger.kernel.org, pawel@osciak.com
Subject: Re: [PATCH] media: vivid test device: Add NV{12,21} and Y{U,V}12
 pixel format.
References: <CAPUS084EM0QMVapYxt8pDOn7=M+JK0BQMwufXsH94vD+bMDMgw@mail.gmail.com> <54E1FAAE.2000307@xs4all.nl>
In-Reply-To: <54E1FAAE.2000307@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/16/2015 03:11 PM, Hans Verkuil wrote:
> Hi Miguel,
> 
> On 02/11/2015 07:39 PM, Miguel Casas-Sanchez wrote:
>> Add support for vertical + horizontal subsampled formats to vivid and use it to
>> generate YU12, YV12, NV12, NV21 as defined in [1,2]. These formats are tightly
>> packed N planar, because they provide chroma(s) as a separate array, but they
>> are not mplanar yet, as discussed in the list.
>>
>> The modus operandi is to let tpg_fillbuffer() create a YUYV packed format per
>> pattern line as usual and apply downsampling if needed immediately afterwards,
>> in a new function called tpg_apply_downsampling(). This one will unpack as
>> needed, and average the chroma samples (note that luma samples are never
>> downsampled). (Some provisions for horizontal downsampling are made, so it can
>> be followed up with e.g. YUV410 etc formats, please understand in this context).
>> Writing the text information on top of the produced pattern also needs a bit of
>> a retouch.
>>
>> [1] http://linuxtv.org/downloads/v4l-dvb-apis/re30.html
>> [2] http://linuxtv.org/downloads/v4l-dvb-apis/re24.html
>>
>> Signed-off-by: Miguel Casas-Sanchez <mcasas@chromium.org>
> 
> I'm afraid there are a number of issues with this patch that prevent it from being
> merged. First of all, your mailer wraps around long lines, making it impossible to
> apply this patch. Instead, I've used your earlier post that attached the patch. I'm
> assuming the two are identical.
> 
> Secondly, I noticed various spurious whitespace changes that made the patch longer
> than necessary. Thirdly, you didn't check the patch with checkpatch.pl.
> 
> Also note that the ENUM_FMT descriptions are too long: the string is cut off. Easy
> to see with qv4l2.
> 
> Much more serious is that you break the pattern movements, the border, the square
> and the vertical flip support for these new pixel formats. That really must remain
> functional. The 'Insert SAV/EAV Code' controls are also not working, but in all
> fairness, I don't think those make sense for these subsampled formats.
> 
> Cropping and scaling is also broken.
> 
> I noticed that when printing the text you only fill in the luma and not the chroma,
> effectively making that transparent. Which may not be a bad idea. However, note that
> the 'Noise' test pattern is broken with the new formats.
> 
> Conclusion: there is a lot more work to be done here...

For the record, I really hope you'll continue with this as it is a very nice
and useful addition, but I did think you were overly optimistic about how easy
it would be to add this feature. There was a reason after all why I decided not
to add it and leave it for the future...

Regards,

	Hans
