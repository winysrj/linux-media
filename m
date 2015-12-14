Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37728 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932162AbbLNKdH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 05:33:07 -0500
Subject: Re: [PATCH 0/3] adv7604: .g_crop and .cropcap support
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
References: <1449849893-14865-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <566AF904.9050102@xs4all.nl>
Cc: magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, william.towle@codethink.co.uk
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <566E9ADC.1030608@xs4all.nl>
Date: Mon, 14 Dec 2015 11:33:00 +0100
MIME-Version: 1.0
In-Reply-To: <566AF904.9050102@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/11/2015 05:25 PM, Hans Verkuil wrote:
> Hi Ulrich,
> 
> On 12/11/2015 05:04 PM, Ulrich Hecht wrote:
>> Hi!
>>
>> The rcar_vin driver relies on these methods.  The third patch makes sure
>> that they return up-to-date data if the input signal has changed since
>> initialization.
>>
>> CU
>> Uli
>>
>>
>> Ulrich Hecht (3):
>>   media: adv7604: implement g_crop
>>   media: adv7604: implement cropcap
> 
> I'm not keen on these changes. The reason is that these ops are deprecated and
> soc-camera is - almost - the last user. The g/s_selection ops should be used instead.
> 
> Now, I have a patch that changes soc-camera to g/s_selection. The reason it was never
> applied is that I had a hard time finding hardware to test it with.
> 
> Since you clearly have that hardware I think I'll rebase my (by now rather old) patch
> and post it again. If you can switch the adv7604 patch to g/s_selection and everything
> works with my patch, then I think I should just make a pull request for it.
> 
> I hope to be able to do this on Monday.

OK, my http://git.linuxtv.org/hverkuil/media_tree.git/log/?h=rmcrop branch now has a
rebased patch to remove g/s_crop. Only compile-tested. It's just the one patch that you
need.

Regards,

	Hans

> If switching soc-camera over to g/s_selection isn't possible, then at the very least
> your adv7604 changes should provide the g/s_selection implementation. I don't want
> to have to convert this driver later to g/s_selection.
> 
> Regards,
> 
> 	Hans
> 
>>   media: adv7604: update timings on change of input signal
>>
>>  drivers/media/i2c/adv7604.c | 38 ++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 38 insertions(+)
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

