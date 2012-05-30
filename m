Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:54180 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab2E3LXI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 May 2012 07:23:08 -0400
Message-ID: <4FC600D7.1020203@cisco.com>
Date: Wed, 30 May 2012 13:13:27 +0200
From: "Martin Bugge (marbugge)" <marbugge@cisco.com>
MIME-Version: 1.0
To: Soby Mathew <soby.mathew@st.com>
CC: linux-media@vger.kernel.org
Subject: Re: Preliminary proposal, new APIs for HDMI and DVI control in v4l2
References: <4D7E42AE.2080506@cisco.com> <loom.20120527T192755-466@post.gmane.org>
In-Reply-To: <loom.20120527T192755-466@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Soby

On 05/27/2012 07:30 PM, Soby Mathew wrote:
> Martin Bugge (marbugge<marbugge<at>  cisco.com>  writes:
>
>>
>> This is a preliminary proposal for an extension to the v4l2 api.
>> To be discussed at the  V4L2 'brainstorming' meeting in Warsaw, March 2011
>>
>> Purpose: Provide basic controls for HDMI and DVI devices.
>>
>>
> reposting the query since the earlier post did not appear in mailing list.
>
> Hi Martin,
>     We are also in requirement of these controls as described by you. I did a
> search in the archives but could not find a suitable conclusion to the RFC. I
> could find that the dv_timings structure has been modified as a result of
> further discussions. But for many items like S_EDID, DV_CABLE_DETECT, Info
> frames etc , I could not find the logical conclusion to this RFC. Could please
> let me know the further updates on these requirements?
It has been on hold for a very long time, but just last week Hans 
Verkuil posted a RFC
which is a follow up on this subject.

http://www.spinics.net/lists/linux-media/msg47671.html

So that thread has taken over.

>
>
> Thanks in Advance
> Best Regards
> Soby Mathew
>

Best regards
Martin Bugge

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

