Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:49602 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779AbaLALPU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 06:15:20 -0500
Message-ID: <547C4DB6.9090300@xs4all.nl>
Date: Mon, 01 Dec 2014 12:15:02 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: linux-media@vger.kernel.org, marbugge@cisco.com,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/3] hdmi: add new HDMI 2.0 defines
References: <1417186251-6542-1-git-send-email-hverkuil@xs4all.nl> <1417186251-6542-2-git-send-email-hverkuil@xs4all.nl> <20141201110321.GA11763@ulmo.nvidia.com>
In-Reply-To: <20141201110321.GA11763@ulmo.nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/01/2014 12:03 PM, Thierry Reding wrote:
> On Fri, Nov 28, 2014 at 03:50:49PM +0100, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add new Video InfoFrame colorspace information introduced in HDMI 2.0
>> and new Audio Coding Extension Types, also from HDMI 2.0.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  include/linux/hdmi.h | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>
>> diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
>> index 11c0182..38fd2a0 100644
>> --- a/include/linux/hdmi.h
>> +++ b/include/linux/hdmi.h
>> @@ -37,6 +37,8 @@ enum hdmi_colorspace {
>>  	HDMI_COLORSPACE_RGB,
>>  	HDMI_COLORSPACE_YUV422,
>>  	HDMI_COLORSPACE_YUV444,
>> +	HDMI_COLORSPACE_YUV420,
>> +	HDMI_COLORSPACE_IDO_DEFINED = 7,
>>  };
>>  
>>  enum hdmi_scan_mode {
>> @@ -77,6 +79,10 @@ enum hdmi_extended_colorimetry {
>>  	HDMI_EXTENDED_COLORIMETRY_S_YCC_601,
>>  	HDMI_EXTENDED_COLORIMETRY_ADOBE_YCC_601,
>>  	HDMI_EXTENDED_COLORIMETRY_ADOBE_RGB,
>> +
>> +	/* The following EC values are only defined in CEA-861-F. */
>> +	HDMI_EXTENDED_COLORIMETRY_BT2020_CONST_LUM,
>> +	HDMI_EXTENDED_COLORIMETRY_BT2020,
>>  };
>>  
>>  enum hdmi_quantization_range {
>> @@ -201,9 +207,23 @@ enum hdmi_audio_sample_frequency {
>>  
>>  enum hdmi_audio_coding_type_ext {
>>  	HDMI_AUDIO_CODING_TYPE_EXT_STREAM,
>> +
>> +	/*
>> +	 * The next three CXT values are defined in CEA-861-E only.
>> +	 * They do not exist in older versions, and in CEA-861-F they are
>> +	 * defined as 'Not in use'.
>> +	 */
>>  	HDMI_AUDIO_CODING_TYPE_EXT_HE_AAC,
>>  	HDMI_AUDIO_CODING_TYPE_EXT_HE_AAC_V2,
>>  	HDMI_AUDIO_CODING_TYPE_EXT_MPEG_SURROUND,
>> +
>> +	/* The following CXT values are only defined in CEA-861-F. */
>> +	HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_HE_AAC,
>> +	HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_HE_AAC_V2,
>> +	HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_AAC_LC,
>> +	HDMI_AUDIO_CODING_TYPE_EXT_DRA,
>> +	HDMI_AUDIO_CODING_TYPE_EXT_MPEG_HE_AAC_SURROUND,
>> +	HDMI_AUDIO_CODING_TYPE_EXT_MPEG_AAC_LC_SURROUND = 10,
> 
> I think the last two should be MPEG4_{HE_AAC,AAC}_SURROUND, and with
> that fixed:
> 
> Reviewed-by: Thierry Reding <treding@nvidia.com>
> 

You are correct, I will correct that.

Thanks,

	Hans
