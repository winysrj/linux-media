Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4192 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaAaRVe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 12:21:34 -0500
Message-ID: <52EBDB8B.80202@xs4all.nl>
Date: Fri, 31 Jan 2014 18:21:15 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, k.debski@samsung.com
Subject: Re: [PATCH v4.1 3/3] v4l: Add V4L2_BUF_FLAG_TIMESTAMP_SOF and use
 it
References: <201308281419.52009.hverkuil@xs4all.nl> <344618801.kmLM0jZvMY@avalon> <52A9ADF6.2090900@xs4all.nl> <18082456.iNCn4Qe0lB@avalon> <52EBC534.8080903@xs4all.nl> <20140131164233.GB15383@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140131164233.GB15383@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 01/31/2014 05:42 PM, Sakari Ailus wrote:
> Hi Hans and Laurent,
> 
> On Fri, Jan 31, 2014 at 04:45:56PM +0100, Hans Verkuil wrote:
>> How about defining a capability for use with ENUMINPUT/OUTPUT? I agree that this
>> won't change between buffers, but it is a property of a specific input or output.
> 
> Over 80 characters per line. :-P

Stupid thunderbird doesn't show the column, and I can't enable
automatic word-wrap because that plays hell with patches. Solutions
welcome!

> 
>> There are more than enough bits available in v4l2_input/output to add one for
>> SOF timestamps.
> 
> In complex devices with a non-linear media graph inputs and outputs are not
> very relevant, and for that reason many drivers do not even implement them.
> I'd rather not bind video buffer queues to inputs or outputs.

Then we end up again with buffer flags. It's a property of the selected input
or output, so if you can't/don't want to use that, then it's buffer flags.

Which I like as well, but it's probably useful that the documentation states
that it can only change if the input or output changes as well.

> My personal favourite is still to use controls for the purpose but the
> buffer flags come close, too, especially now that we're using them for
> timestamp sources.

Laurent, can we please end this discussion? It makes perfect sense to store
this information as a BUF_FLAG IMHO. You can just do a QUERYBUF once after
you called REQBUFS and you know what you have to deal with.

Regards,

	Hans
