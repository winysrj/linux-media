Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:60035 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbaLSMJp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 07:09:45 -0500
Message-ID: <54941584.90801@xs4all.nl>
Date: Fri, 19 Dec 2014 13:09:40 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: linux-media@vger.kernel.org, marbugge@cisco.com,
	dri-devel@lists.freedesktop.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 2/3] hdmi: added unpack and logging functions for InfoFrames
References: <1417522126-31771-1-git-send-email-hverkuil@xs4all.nl> <1417522126-31771-3-git-send-email-hverkuil@xs4all.nl> <20141218081927.GA29856@ulmo>
In-Reply-To: <20141218081927.GA29856@ulmo>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

On 12/18/2014 09:19 AM, Thierry Reding wrote:
>> +static int hdmi_avi_infoframe_unpack(struct hdmi_avi_infoframe *frame,
>> +				     void *buffer)
>> +{
>> +	u8 *ptr = buffer;
>> +	int ret;
>> +
>> +	if (ptr[0] != HDMI_INFOFRAME_TYPE_AVI ||
>> +	    ptr[1] != 2 ||
>> +	    ptr[2] != HDMI_AVI_INFOFRAME_SIZE)
>> +		return -EINVAL;
>> +
>> +	if (hdmi_infoframe_checksum(buffer, HDMI_INFOFRAME_SIZE(AVI)) != 0)
> 
> You use the parameterized HDMI_INFOFRAME_SIZE() here, but the plain
> macro above. Perhaps make those consistent?

I'm not sure what you mean here since HDMI_AVI_INFOFRAME_SIZE != HDMI_INFOFRAME_SIZE(AVI).
The latter includes the infoframe header size.

I'm assuming you missed that. If not, then please clarify.

Regards,

	Hans
