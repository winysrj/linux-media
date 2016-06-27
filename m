Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:36954 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbcF0Jav (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 05:30:51 -0400
Subject: Re: [PATCH v4 6/8] media: rcar-vin: initialize EDID data
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	niklas.soderlund@ragnatech.se
References: <1462975376-491-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1462975376-491-7-git-send-email-ulrich.hecht+renesas@gmail.com>
 <573591F4.4050901@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fb91b675-d87f-4b7a-ae3b-ab7a61759393@xs4all.nl>
Date: Mon, 27 Jun 2016 11:30:45 +0200
MIME-Version: 1.0
In-Reply-To: <573591F4.4050901@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

On 05/13/2016 10:36 AM, Hans Verkuil wrote:
> On 05/11/2016 04:02 PM, Ulrich Hecht wrote:
>> Initializes the decoder subdevice with a fixed EDID blob.
>>
>> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> 
> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Instead implement the g/s_edid ioctls.
> 
> You truly cannot default to an EDID. When an EDID is set the HPD will go high.
> But you don't know the EDID here, the contents of the EDID is something that
> only userspace will know depending on the type of device you're building.
> 
> In practice userspace will overwrite the EDID with the real one and so the HPD
> will go down and up again. And while transmitters are supposed to handle that
> cleanly, in reality this is a different story.
> 
> Just add the g/s_edid ioctls and you can use 'v4l2-ctl --set-edid=edid=hdmi' to
> fill in a default EDID.
> 
> I won't accept this patch since I know from my own experience that this doesn't
> work.

I haven't seen a follow-up on this. Can you do a v5? It's likely that will be the
last version and I can commit this.

Thanks!

	Hans
