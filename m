Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:41547 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbaLANtF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 08:49:05 -0500
Message-ID: <547C71BF.4040907@xs4all.nl>
Date: Mon, 01 Dec 2014 14:48:47 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: linux-media@vger.kernel.org, marbugge@cisco.com,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 2/3] hdmi: added unpack and logging functions for InfoFrames
References: <1417186251-6542-1-git-send-email-hverkuil@xs4all.nl> <1417186251-6542-3-git-send-email-hverkuil@xs4all.nl> <20141201131507.GB11763@ulmo.nvidia.com>
In-Reply-To: <20141201131507.GB11763@ulmo.nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

Thanks for the review, see my comments below.

On 12/01/2014 02:15 PM, Thierry Reding wrote:
> On Fri, Nov 28, 2014 at 03:50:50PM +0100, Hans Verkuil wrote:
>> From: Martin Bugge <marbugge@cisco.com>
>>
>> When receiving video it is very useful to be able to unpack the InfoFrames.
>> Logging is useful as well, both for transmitters and receivers.
>>
>> Especially when implementing the VIDIOC_LOG_STATUS ioctl (supported by many
>> V4L2 drivers) for a receiver it is important to be able to easily log what
>> the InfoFrame contains. This greatly simplifies debugging.
>>
>> Signed-off-by: Martin Bugge <marbugge@cisco.com>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/video/hdmi.c | 622 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  include/linux/hdmi.h |   3 +
>>  2 files changed, 618 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
>> index 9e758a8..9f0f554 100644
>> --- a/drivers/video/hdmi.c
>> +++ b/drivers/video/hdmi.c
>> @@ -27,10 +27,10 @@
>>  #include <linux/export.h>
>>  #include <linux/hdmi.h>
>>  #include <linux/string.h>
>> +#include <linux/device.h>
>>  
>> -static void hdmi_infoframe_checksum(void *buffer, size_t size)
>> +static u8 hdmi_infoframe_calc_checksum(u8 *ptr, size_t size)
> 
> I'd personally keep the name here.

I'll do that.

> 
>> @@ -434,3 +441,604 @@ hdmi_infoframe_pack(union hdmi_infoframe *frame, void *buffer, size_t size)
>>  	return length;
>>  }
>>  EXPORT_SYMBOL(hdmi_infoframe_pack);
>> +
>> +static const char *hdmi_infoframe_type_txt(enum hdmi_infoframe_type type)
> 
> Perhaps: hdmi_infoframe_type_get_name()?

I think that's better as well, I'll change it.

> 
>> +{
>> +	switch (type) {
>> +	case HDMI_INFOFRAME_TYPE_VENDOR: return "Vendor";
>> +	case HDMI_INFOFRAME_TYPE_AVI: return "Auxiliary Video Information (AVI)";
>> +	case HDMI_INFOFRAME_TYPE_SPD: return "Source Product Description (SPD)";
>> +	case HDMI_INFOFRAME_TYPE_AUDIO: return "Audio";
> 
> I'd prefer "case ...:" and "return ...;" on separate lines for
> readability.

I actually think that makes it *less* readable. If you really want that, then I'll
change it, but I would suggest that you try it yourself first to see if it is
really more readable for you. It isn't for me, so I'll keep this for the next
version.

> 
>> +	}
>> +	return "Invalid/Unknown";
>> +}
> 
> Maybe include the numerical value here? Of course that either means that
> callers must pass in a buffer or we sacrifice thread-safety. The buffer
> could be optional, somewhat like this:
> 
> 	const char *hdmi_infoframe_get_name(char *buffer, size_t length,
> 					    enum hdmi_infoframe_type type)
> 	{
> 		const char *name = NULL;
> 
> 		switch (type) {
> 		case HDMI_INFOFRAME_TYPE_VENDOR:
> 			name = "Vendor";
> 			break;
> 		...
> 		}
> 
> 		if (buffer) {
> 			if (!name)
> 				snprintf(buffer, length, "unknown (%d)", type);
> 			else
> 				snprintf(buffer, length, name);
> 
> 			name = buffer;
> 		}
> 
> 		return name;
> 	}
> 
> That way the function would be generally useful and could even be made
> publicly available.

I would do this only where it makes sense. Some of these fields have only one or
two reserved bits left, and in that case is it easier to just say something
like "Reserved (3)" and do that for each reserved value.

> 
>> +static void hdmi_infoframe_log_header(struct device *dev, void *f)
>> +{
>> +	struct hdmi_any_infoframe *frame = f;
>> +	dev_info(dev, "HDMI infoframe: %s, version %d, length %d\n",
>> +		hdmi_infoframe_type_txt(frame->type), frame->version, frame->length);
>> +}
>> +
>> +static const char *hdmi_colorspace_txt(enum hdmi_colorspace colorspace)
>> +{
>> +	switch (colorspace) {
>> +	case HDMI_COLORSPACE_RGB: return "RGB";
>> +	case HDMI_COLORSPACE_YUV422: return "YCbCr 4:2:2";
>> +	case HDMI_COLORSPACE_YUV444: return "YCbCr 4:4:4";
>> +	case HDMI_COLORSPACE_YUV420: return "YCbCr 4:2:0";
>> +	case HDMI_COLORSPACE_IDO_DEFINED: return "IDO Defined";
>> +	}
>> +	return "Future";
>> +}
> 
> Similar comments as for the above.
> 
>> +static const char *hdmi_scan_mode_txt(enum hdmi_scan_mode scan_mode)
>> +{
>> +	switch(scan_mode) {
>> +	case HDMI_SCAN_MODE_NONE: return "No Data";
>> +	case HDMI_SCAN_MODE_OVERSCAN: return "Composed for overscanned display";
>> +	case HDMI_SCAN_MODE_UNDERSCAN: return "Composed for underscanned display";
>> +	}
>> +	return "Future";
>> +}
> 
> This isn't really a name any more, I think it should either stick to
> names like "None", "Overscan", "Underscan"

I agree with that, I'll change it.

> or it should return a
> description, in which case hdmi_scan_mode_get_description() might be
> more accurate for a name.
> 
>> +static const char *hdmi_colorimetry_txt(enum hdmi_colorimetry colorimetry)
>> +{
>> +	switch(colorimetry) {
>> +	case HDMI_COLORIMETRY_NONE: return "No Data";
>> +	case HDMI_COLORIMETRY_ITU_601: return "ITU601";
>> +	case HDMI_COLORIMETRY_ITU_709: return "ITU709";
>> +	case HDMI_COLORIMETRY_EXTENDED: return "Extended";
>> +	}
>> +	return "Invalid/Unknown";
>> +}
> 
> These are names again, so same comments as for the infoframe type. And
> perhaps "No Data" -> "None" in that case.

Yep.

> 
>> +
>> +static const char *hdmi_picture_aspect_txt(enum hdmi_picture_aspect picture_aspect)
>> +{
>> +	switch (picture_aspect) {
>> +	case HDMI_PICTURE_ASPECT_NONE: return "No Data";
>> +	case HDMI_PICTURE_ASPECT_4_3: return "4:3";
>> +	case HDMI_PICTURE_ASPECT_16_9: return "16:9";
>> +	}
>> +	return "Future";
>> +}
> 
> Same here.
> 
>> +static const char *hdmi_quantization_range_txt(enum hdmi_quantization_range quantization_range)
>> +{
>> +	switch (quantization_range) {
>> +	case HDMI_QUANTIZATION_RANGE_DEFAULT: return "Default (depends on video format)";
> 
> I think "Default" would do here ("depends on video format" can be
> derived from the reading of the specification). Generally I think these
> should focus on providing a human-readable version of the infoframes,
> not be a replacement for reading the specification.

Indeed.

> 
>> +/**
>> + * hdmi_avi_infoframe_log() - log info of HDMI AVI infoframe
>> + * @dev: device
>> + * @frame: HDMI AVI infoframe
>> + */
>> +static void hdmi_avi_infoframe_log(struct device *dev, struct hdmi_avi_infoframe *frame)
> 
> Perhaps allow this to take a log level? I can imagine drivers wanting to
> use this with dev_dbg() instead.

Makes sense.

> 
>> +/**
>> + * hdmi_vendor_infoframe_log() - log info of HDMI VENDOR infoframe
>> + * @dev: device
>> + * @frame: HDMI VENDOR infoframe
>> + */
>> +static void hdmi_vendor_any_infoframe_log(struct device *dev, union hdmi_vendor_any_infoframe *frame)
>> +{
>> +	struct hdmi_vendor_infoframe *hvf = &frame->hdmi;
>> +
>> +	hdmi_infoframe_log_header(dev, frame);
>> +
>> +	if (frame->any.oui != HDMI_IEEE_OUI) {
>> +		dev_info(dev, "    not a HDMI vendor infoframe\n");
>> +		return;
>> +	}
>> +	if (hvf->vic == 0 && hvf->s3d_struct == HDMI_3D_STRUCTURE_INVALID) {
>> +		dev_info(dev, "    empty frame\n");
>> +		return;
>> +	}
>> +
>> +	if (hvf->vic) {
>> +		dev_info(dev, "    Hdmi Vic: %d\n", hvf->vic);
> 
> "HDMI VIC"?

Will change.

> 
>> +	}
> 
> No need for these braces.

Will change.

> 
>> +/**
>> + * hdmi_infoframe_log() - log info of HDMI infoframe
>> + * @dev: device
>> + * @frame: HDMI infoframe
>> + */
>> +void hdmi_infoframe_log(struct device *dev, union hdmi_infoframe *frame)
>> +{
>> +	switch (frame->any.type) {
>> +	case HDMI_INFOFRAME_TYPE_AVI:
>> +		hdmi_avi_infoframe_log(dev, &frame->avi);
>> +		break;
>> +	case HDMI_INFOFRAME_TYPE_SPD:
>> +		hdmi_spd_infoframe_log(dev, &frame->spd);
>> +		break;
>> +	case HDMI_INFOFRAME_TYPE_AUDIO:
>> +		hdmi_audio_infoframe_log(dev, &frame->audio);
>> +		break;
>> +	case HDMI_INFOFRAME_TYPE_VENDOR:
>> +		hdmi_vendor_any_infoframe_log(dev, &frame->vendor);
>> +		break;
>> +	default:
>> +		WARN(1, "Bad infoframe type %d\n", frame->any.type);
> 
> Does it make sense for this to be WARN? It's perfectly legal for future
> devices to expose new types of infoframes. Perhaps even expected. But if
> we want to keep this here to help get bug reports so that we don't
> forget to update this code, then maybe we should do the same wherever we
> query the name of enum values above.

I'll drop the WARN from the log function. I think it should also be dropped
from the unpack. The only place it makes sense is for pack() since there the
data comes from the driver, not from an external source.

> 
>> +/**
>> + * hdmi_avi_infoframe_unpack() - unpack binary buffer to a HDMI AVI infoframe
>> + * @buffer: source buffer
>> + * @frame: HDMI AVI infoframe
>> + *
>> + * Unpacks the information contained in binary @buffer into a structured
>> + * @frame of the HDMI Auxiliary Video (AVI) information frame.
>> + * Also verifies the checksum as required by section 5.3.5 of the HDMI 1.4 specification.
>> + *
>> + * Returns 0 on success or a negative error code on failure.
>> + */
>> +static int hdmi_avi_infoframe_unpack(void *buffer, struct hdmi_avi_infoframe *frame)
> 
> I'm on the fence about ordering of arguments here. I think I'd slightly
> prefer the infoframe to be the first, to make the API more object-
> oriented.

I'll swap this. It's more consistent with pack() anyway.

> 
>> +{
>> +	u8 *ptr = buffer;
>> +	int ret;
>> +
>> +	if (ptr[0] != HDMI_INFOFRAME_TYPE_AVI ||
>> +	    ptr[1] != 2 ||
>> +	    ptr[2] != HDMI_AVI_INFOFRAME_SIZE) {
>> +		return -EINVAL;
>> +	}
> 
> No need for the braces.

Will change.

> 
> Thierry
> 

Regards,

	Hans
